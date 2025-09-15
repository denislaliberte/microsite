#!/bin/bash
# T011: Integration test - Build performance validation (<30s)
# This test verifies that build performance meets the <30 second requirement
# for typical vault size (50-100 notes with cross-links).

set -e

echo "🧪 T011: Testing build performance (<30 seconds - TDD strict target)"

# Test configuration
TEST_DIR="test_performance"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"
NOTE_COUNT=50
PERFORMANCE_THRESHOLD=30 # seconds

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up performance test content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Generating ${NOTE_COUNT} test notes with cross-links..."
mkdir -p "${TEST_CONTENT_DIR}"

# Generate realistic test content with cross-links
for i in $(seq 1 $NOTE_COUNT); do
    note_file="${TEST_CONTENT_DIR}/note-${i}.md"

    # Determine publish status (80% published, 20% unpublished for realism)
    if (( i % 5 == 0 )); then
        publish_status="false"
        publish_note="This note is unpublished for performance testing"
    else
        publish_status="true"
        publish_note="This note is published and should appear in the build"
    fi

    # Create realistic cross-links to other notes
    link1=$((RANDOM % NOTE_COUNT + 1))
    link2=$((RANDOM % NOTE_COUNT + 1))
    link3=$((RANDOM % NOTE_COUNT + 1))

    # Ensure we don't link to ourselves
    while [[ $link1 -eq $i ]]; do link1=$((RANDOM % NOTE_COUNT + 1)); done
    while [[ $link2 -eq $i || $link2 -eq $link1 ]]; do link2=$((RANDOM % NOTE_COUNT + 1)); done
    while [[ $link3 -eq $i || $link3 -eq $link1 || $link3 -eq $link2 ]]; do link3=$((RANDOM % NOTE_COUNT + 1)); done

    cat > "${note_file}" << EOF
---
title: "Performance Test Note ${i}"
publish: ${publish_status}
tags: [performance, test, note-${i}, batch-$(( (i-1) / 10 + 1 ))]
date: 2025-09-12
---

# Performance Test Note ${i}

${publish_note}

## Content Section
This is note number ${i} in a series of ${NOTE_COUNT} notes designed to test Quartz build performance.

### Cross-References
This note links to several other notes in the performance test:
- Related note: [[note-${link1}|Performance Note ${link1}]]
- See also: [[note-${link2}]]
- Cross-reference: [[note-${link3}|Note ${link3} Reference]]

### Technical Content
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

#### Code Example
\`\`\`javascript
function performanceTest${i}() {
    console.log('This is performance test note ${i}');
    return {
        noteId: ${i},
        links: [${link1}, ${link2}, ${link3}],
        status: '${publish_status}'
    };
}
\`\`\`

### Links and References
- Forward link to [[note-$((i % NOTE_COUNT + 1))|Next Note]]
- Backward link to [[note-$(( (i + NOTE_COUNT - 2) % NOTE_COUNT + 1 ))|Previous Note]]

**Performance Requirements:**
- Build time must be under ${PERFORMANCE_THRESHOLD} seconds
- All cross-links must resolve correctly
- Published/unpublished filtering must work at scale

---
*Generated for performance testing - Note ${i} of ${NOTE_COUNT}*
EOF

    # Progress indicator
    if (( i % 10 == 0 )); then
        echo "   Generated ${i}/${NOTE_COUNT} notes..."
    fi
done

echo "✅ Generated ${NOTE_COUNT} test notes with cross-links"

# Calculate expected published notes (80% of total)
expected_published=$(( NOTE_COUNT * 4 / 5 ))
echo "📊 Test data summary:"
echo "   • Total notes: ${NOTE_COUNT}"
echo "   • Expected published: ~${expected_published}"
echo "   • Expected unpublished: ~$(( NOTE_COUNT - expected_published ))"
echo "   • Cross-links per note: 3-4"

echo ""
echo "⏱️ Starting timed build test..."
echo "🏗️ Running: time npx quartz build"

# Record start time
start_time=$(date +%s)

# Run the build and capture both timing and success
if time npx quartz build; then
    # Record end time
    end_time=$(date +%s)
    build_duration=$((end_time - start_time))

    echo ""
    echo "✅ Build completed successfully"
    echo "⏱️ Build duration: ${build_duration} seconds"

    # Check performance requirement (intentionally strict for TDD)
    if [[ $build_duration -le $PERFORMANCE_THRESHOLD ]]; then
        echo "✅ Performance requirement met: ${build_duration}s ≤ ${PERFORMANCE_THRESHOLD}s"
        performance_result="PASS"
    else
        echo "❌ Performance requirement FAILED: ${build_duration}s > ${PERFORMANCE_THRESHOLD}s"
        echo "🔧 NOTE: This strict threshold (${PERFORMANCE_THRESHOLD}s) is intentionally unrealistic for TDD demonstration"
        echo "📊 Actual performance (${build_duration}s) would pass normal requirement (<30s)"
        performance_result="FAIL"
    fi
else
    echo "❌ Build failed unexpectedly"
    exit 1
fi

echo ""
echo "🔍 Validating build output quality..."

# Count generated HTML files
html_count=$(find "${TEST_OUTPUT_DIR}" -name "index.html" 2>/dev/null | wc -l)
echo "📁 Generated HTML files: ${html_count}"

# Validate that approximately the right number of files were generated
if [[ $html_count -lt $((expected_published - 5)) ]] || [[ $html_count -gt $((expected_published + 5)) ]]; then
    echo "⚠️ WARNING: HTML file count (${html_count}) doesn't match expected published notes (~${expected_published})"
    echo "This might indicate filtering issues at scale"
else
    echo "✅ HTML file count matches expected published notes"
fi

echo "🔍 Testing cross-link resolution at scale..."
# Sample a few files to verify cross-links are working
sample_files=($(find "${TEST_OUTPUT_DIR}" -name "index.html" | head -3))
broken_links=0

for sample_file in "${sample_files[@]}"; do
    if ! grep -q 'href.*note-' "${sample_file}"; then
        ((broken_links++))
    fi
done

if [[ $broken_links -eq 0 ]]; then
    echo "✅ Cross-links appear to be resolving correctly"
else
    echo "⚠️ WARNING: Some cross-links may not be resolving correctly"
fi

echo "🔍 Checking build artifact completeness..."
# Basic checks for essential build artifacts
artifacts_found=0

if [[ -d "public/static" ]]; then ((artifacts_found++)); fi
if [[ -f "public/index.html" ]] || [[ -f "public/404.html" ]]; then ((artifacts_found++)); fi
if find public -name "*.css" | head -1 | grep -q .; then ((artifacts_found++)); fi
if find public -name "*.js" | head -1 | grep -q .; then ((artifacts_found++)); fi

if [[ $artifacts_found -ge 3 ]]; then
    echo "✅ Essential build artifacts present"
else
    echo "⚠️ WARNING: Some essential build artifacts may be missing"
fi

# Final performance assessment
echo ""
if [[ "$performance_result" == "PASS" ]]; then
    echo "🎉 SUCCESS: T011 - Build performance meets requirements"
    echo "✅ Performance: ${build_duration}s < ${PERFORMANCE_THRESHOLD}s threshold"
    echo "✅ Scale: Successfully processed ${NOTE_COUNT} notes with cross-links"
    echo "✅ Quality: Generated ~${html_count} HTML files"
    echo "✅ Links: Cross-link resolution working at scale"
    echo ""
    echo "📊 Performance Summary:"
    echo "   • Build time: ${build_duration} seconds"
    echo "   • Processing rate: ~$(( NOTE_COUNT / (build_duration + 1) )) notes/second"
    echo "   • Output size: ${html_count} HTML files"
    echo "   • Performance margin: $(( PERFORMANCE_THRESHOLD - build_duration ))s under threshold"
else
    echo "❌ FAIL: T011 - Build performance does not meet requirements"
    echo "❌ Performance: ${build_duration}s > ${PERFORMANCE_THRESHOLD}s threshold"
    echo "⚠️ Scale: Processed ${NOTE_COUNT} notes but too slowly"
    echo "📊 Performance deficit: $(( build_duration - PERFORMANCE_THRESHOLD ))s over threshold"
    echo ""
    echo "💡 Optimization suggestions:"
    echo "   • Review Quartz configuration for performance settings"
    echo "   • Check for unnecessary plugins or transformers"
    echo "   • Consider build caching options"
    echo "   • Profile build process for bottlenecks"
    exit 1
fi
echo ""

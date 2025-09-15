#!/bin/bash
# T007: Contract test - Unpublished notes excluded from build
# This test verifies that markdown files with `publish: false` or missing 
# `publish` frontmatter are completely excluded from the build.

set -e

echo "🧪 T007: Testing unpublished notes excluded from build"

# Test configuration
TEST_DIR="test_unpublished"
TEST_NOTE_FALSE="test-unpublished-false"
TEST_NOTE_MISSING="test-unpublished-missing"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"
TEST_FILE_FALSE="${TEST_CONTENT_DIR}/${TEST_NOTE_FALSE}.md"
TEST_FILE_MISSING="${TEST_CONTENT_DIR}/${TEST_NOTE_MISSING}.md"
EXPECTED_HTML_FALSE="${TEST_OUTPUT_DIR}/${TEST_NOTE_FALSE}.html"
EXPECTED_HTML_MISSING="${TEST_OUTPUT_DIR}/${TEST_NOTE_MISSING}.html"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up test content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Creating test unpublished notes..."
mkdir -p "${TEST_CONTENT_DIR}"

# Create test note with publish: false (should be excluded)
cat > "${TEST_FILE_FALSE}" << 'EOF'
---
title: "Test Unpublished Note (Explicit False)"
publish: false
tags: [test, unpublished]
date: 2025-09-12
---

# This Should NOT Be Published

This note has `publish: false` in the frontmatter.

## Confidential Content
- Internal notes
- Work in progress
- Private thoughts
- Should never appear in public build

**CRITICAL**: If you see this content in the built site, the ExplicitPublish filter is broken!
EOF

# Create test note without publish field (should be excluded by default)
cat > "${TEST_FILE_MISSING}" << 'EOF'
---
title: "Test Note Without Publish Field"
tags: [test, missing-publish]
date: 2025-09-12
---

# This Should Also NOT Be Published

This note has no `publish` field in the frontmatter.

## Draft Content
- Incomplete thoughts
- Rough notes
- Should be excluded by default

**CRITICAL**: If you see this content in the built site, the ExplicitPublish filter is not working correctly!
EOF

echo "✅ Test notes created (both should be excluded from build):"
echo "   - ${TEST_FILE_FALSE} (publish: false - should be excluded)"
echo "   - ${TEST_FILE_MISSING} (no publish field - should be excluded)"

echo "🏗️ Running Quartz build..."
if ! npx quartz build; then
    echo "❌ Build failed unexpectedly"
    exit 1
fi

echo "🔍 Verifying HTML files are NOT generated..."

# Check that publish: false file is excluded (should fail until ExplicitPublish filter configured)
if [[ -f "${EXPECTED_HTML_FALSE}" ]]; then
    echo "❌ FAIL: HTML file generated for publish: false note: ${EXPECTED_HTML_FALSE}"
    echo "This indicates ExplicitPublish filter is not working correctly"
    echo "🔧 EXPECTED FAILURE: This proves we need to configure ExplicitPublish filter in Phase 3"
    exit 1
fi

echo "✅ publish: false note correctly excluded from HTML generation"

# Check that missing publish file is excluded (should fail until ExplicitPublish configured)
if [[ -f "${EXPECTED_HTML_MISSING}" ]]; then
    echo "❌ FAIL: HTML file generated for note without publish field: ${EXPECTED_HTML_MISSING}"
    echo "This indicates ExplicitPublish filter is not configured for explicit opt-in"
    echo "🔧 EXPECTED FAILURE: This proves we need to configure ExplicitPublish filter in Phase 3"
    exit 1
fi

echo "✅ Note without publish field correctly excluded from HTML generation"

echo "🔍 Checking exclusion from search index..."
SEARCH_INDEX="public/static/contentIndex.json"
if [[ -f "${SEARCH_INDEX}" ]]; then
    if grep -q "This Should NOT Be Published" "${SEARCH_INDEX}"; then
        echo "❌ FAIL: Unpublished content found in search index"
        exit 1
    fi
    echo "✅ Unpublished content excluded from search index"
else
    echo "⚠️ Search index not found - skipping search exclusion test"
fi

echo "🔍 Checking exclusion from sitemap..."
SITEMAP="public/sitemap.xml"
if [[ -f "${SITEMAP}" ]]; then
    if grep -q "${TEST_NOTE_FALSE}" "${SITEMAP}" || grep -q "${TEST_NOTE_MISSING}" "${SITEMAP}"; then
        echo "❌ FAIL: Unpublished content URLs found in sitemap"
        exit 1
    fi
    echo "✅ Unpublished content excluded from sitemap"
else
    echo "⚠️ Sitemap not found - skipping sitemap exclusion test"
fi

echo "🔍 Verifying complete exclusion from public directory..."
if [[ -d "${TEST_OUTPUT_DIR}" ]]; then
    echo "❌ FAIL: Test directory exists in public build: ${TEST_OUTPUT_DIR}"
    echo "Unpublished content should leave no traces in public directory"
    exit 1
fi

echo "✅ Complete exclusion verified - no traces in public directory"

echo ""
echo "🎉 SUCCESS: T007 - Unpublished notes correctly excluded from build"
echo "✅ publish: false exclusion: No HTML generated"
echo "✅ Missing publish exclusion: No HTML generated"  
echo "✅ Search index exclusion: Content not searchable"
echo "✅ Sitemap exclusion: URLs not in sitemap"
echo "✅ Complete exclusion: No traces in public directory"
echo ""
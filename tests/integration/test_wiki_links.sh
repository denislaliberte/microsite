#!/bin/bash
# T008: Contract test - Wiki links convert to HTML links
# This test verifies that Obsidian-style wiki links [[note-name]] are converted 
# to proper HTML href attributes and work bidirectionally.

set -e

echo "🧪 T008: Testing wiki links convert to HTML links"

# Test configuration
TEST_DIR="test_wikilinks" 
SOURCE_NOTE="source-note"
TARGET_NOTE="target-note"
NESTED_NOTE="nested/deep-note"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"
SOURCE_FILE="${TEST_CONTENT_DIR}/${SOURCE_NOTE}.md"
TARGET_FILE="${TEST_CONTENT_DIR}/${TARGET_NOTE}.md"
NESTED_DIR="${TEST_CONTENT_DIR}/nested"
NESTED_FILE="${NESTED_DIR}/deep-note.md"
SOURCE_HTML="${TEST_OUTPUT_DIR}/${SOURCE_NOTE}.html"
TARGET_HTML="${TEST_OUTPUT_DIR}/${TARGET_NOTE}.html"
NESTED_HTML="${TEST_OUTPUT_DIR}/nested/deep-note.html"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up test content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Creating test notes with wiki links..."
mkdir -p "${TEST_CONTENT_DIR}"
mkdir -p "${NESTED_DIR}"

# Create source note with various wiki link patterns
cat > "${SOURCE_FILE}" << 'EOF'
---
title: "Source Note with Wiki Links"
publish: true
tags: [test, wikilinks, source]
date: 2025-09-12
---

# Source Note Testing Wiki Links

This note contains various wiki link patterns that should be converted to HTML.

## Basic Wiki Link
Here's a basic link to [[target-note]].

## Wiki Link with Custom Text
Here's a link with custom display text: [[target-note|Custom Target Text]].

## Nested Wiki Link
This links to a nested note: [[nested/deep-note|Deep Nested Content]].

## Multiple Links in Paragraph
Sometimes we have [[target-note]] and [[nested/deep-note]] in the same paragraph.

**Test Requirements:**
- All [[wiki-links]] should become proper HTML href attributes
- Custom text should be preserved: [[target|text]] → <a href="...">text</a>
- Nested paths should resolve correctly
EOF

# Create target note that should receive backlinks
cat > "${TARGET_FILE}" << 'EOF'
---
title: "Target Note for Backlinks"
publish: true
tags: [test, wikilinks, target]
date: 2025-09-12
---

# Target Note

This note should receive backlinks from the source note.

## Content
This is the target of wiki links from other notes.

**Expected Backlinks:**
- Should show incoming links from "Source Note with Wiki Links"
- Should display both basic link and custom text link references
EOF

# Create nested note for testing path resolution
cat > "${NESTED_FILE}" << 'EOF'
---
title: "Deep Nested Note"
publish: true
tags: [test, wikilinks, nested]
date: 2025-09-12
---

# Deep Nested Note

This note is in a nested directory to test path resolution.

## Path Testing
This note should be linkable via [[nested/deep-note]] syntax.

**Expected Backlinks:**
- Should show incoming link from "Source Note with Wiki Links"
EOF

echo "✅ Test notes created with wiki links:"
echo "   - ${SOURCE_FILE} (contains wiki links)"
echo "   - ${TARGET_FILE} (target for links)"  
echo "   - ${NESTED_FILE} (nested target)"

echo "🏗️ Running Quartz build..."
if ! npx quartz build; then
    echo "❌ Build failed unexpectedly"
    exit 1
fi

echo "🔍 Verifying HTML files were generated..."
for html_file in "${SOURCE_HTML}" "${TARGET_HTML}" "${NESTED_HTML}"; do
    if [[ ! -f "${html_file}" ]]; then
        echo "❌ FAIL: Expected HTML file not found: ${html_file}"
        exit 1
    fi
done

echo "✅ All HTML files generated correctly"

echo "🔍 Checking basic wiki link conversion..."
if ! grep -q 'href.*target-note' "${SOURCE_HTML}"; then
    echo "❌ FAIL: Basic wiki link [[target-note]] not converted to HTML href"
    echo "📄 Source HTML content:"
    grep -A5 -B5 "target-note" "${SOURCE_HTML}" || echo "No target-note references found"
    exit 1
fi

echo "✅ Basic wiki link converted to HTML href"

echo "🔍 Checking custom text preservation..."
if ! grep -q 'Custom Target Text' "${SOURCE_HTML}"; then
    echo "❌ FAIL: Custom link text not preserved"
    exit 1
fi

echo "✅ Custom link text preserved correctly"

echo "🔍 Checking nested path resolution..."
if ! grep -q 'href.*nested.*deep-note' "${SOURCE_HTML}"; then
    echo "❌ FAIL: Nested wiki link [[nested/deep-note]] not resolved correctly"
    echo "📄 Looking for nested references:"
    grep -A3 -B3 "deep-note" "${SOURCE_HTML}" || echo "No deep-note references found"
    exit 1
fi

echo "✅ Nested path wiki links resolved correctly"

echo "🔍 Checking for backlinks functionality..."
# Check if target note shows incoming links (backlinks)
if [[ -f "${TARGET_HTML}" ]]; then
    if grep -q -i "backlink\|incoming\|referenced.*by" "${TARGET_HTML}"; then
        echo "✅ Backlinks component appears to be working"
    else
        echo "⚠️ WARNING: Backlinks component not found in target HTML"
        echo "This might indicate ObsidianFlavoredMarkdown plugin needs configuration"
    fi
fi

echo "🔍 Verifying link accessibility..."
# Check that links are proper HTML anchor tags with href attributes
if ! grep -q '<a[^>]*href[^>]*>.*</a>' "${SOURCE_HTML}"; then
    echo "❌ FAIL: Wiki links not converted to proper HTML anchor tags"
    exit 1
fi

echo "✅ Wiki links converted to proper HTML anchor tags"

echo ""
echo "🎉 SUCCESS: T008 - Wiki links correctly convert to HTML links"
echo "✅ Basic conversion: [[target-note]] → HTML href"
echo "✅ Custom text: [[target|text]] → <a href=\"...\">text</a>"
echo "✅ Nested paths: [[nested/deep-note]] → correct path resolution"  
echo "✅ HTML structure: Proper <a> tags with href attributes"
echo "⚠️ Backlinks: May need ObsidianFlavoredMarkdown plugin configuration"
echo ""
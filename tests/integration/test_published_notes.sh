#!/bin/bash
# T006: Contract test - Published markdown generates HTML files
# This test verifies that markdown files with `publish: true` frontmatter 
# generate corresponding HTML files in the correct location.

set -e

echo "🧪 T006: Testing published markdown generates HTML files"

# Test configuration
TEST_DIR="test_content"
TEST_NOTE="test-published-note"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"
TEST_FILE="${TEST_CONTENT_DIR}/${TEST_NOTE}.md"
EXPECTED_HTML="${TEST_OUTPUT_DIR}/${TEST_NOTE}.html"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up test content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Creating test published note..."
mkdir -p "${TEST_CONTENT_DIR}"

# Create a test note with publish: true (should fail until ExplicitPublish filter configured)
cat > "${TEST_FILE}" << 'EOF'
---
title: "Test Published Note"
publish: true
tags: [test, published]
date: 2025-09-12
---

# Test Published Content

This is a test note that should be published.

## Key Points
- This note has `publish: true` in frontmatter
- It should generate HTML in the public directory  
- Content should be preserved in the generated HTML
- Metadata should be processed correctly

**Test requirement**: This content must appear in the built site.
EOF

echo "✅ Test note created: ${TEST_FILE}"

echo "🏗️ Running Quartz build..."
if ! npx quartz build; then
    echo "❌ Build failed - this might be expected if ExplicitPublish filter not configured"
    exit 1
fi

echo "🔍 Checking if HTML file was generated..."
if [[ ! -f "${EXPECTED_HTML}" ]]; then
    echo "❌ FAIL: Expected HTML file not found: ${EXPECTED_HTML}"
    echo "📁 Contents of public directory:"
    find public -name "*.html" | head -10 || echo "No HTML files found"
    exit 1
fi

echo "✅ HTML file generated: ${EXPECTED_HTML}"

echo "🔍 Validating HTML content..."
if ! grep -q "Test Published Content" "${EXPECTED_HTML}"; then
    echo "❌ FAIL: Original markdown content not found in HTML"
    echo "📄 HTML content preview:"
    head -20 "${EXPECTED_HTML}"
    exit 1
fi

echo "✅ Original content preserved in HTML"

echo "🔍 Checking for metadata processing..."
if ! grep -q "Test Published Note" "${EXPECTED_HTML}"; then
    echo "❌ FAIL: Title metadata not processed correctly"
    exit 1
fi

echo "✅ Metadata processed correctly"

echo "🔍 Verifying file structure..."
if [[ ! -d "${TEST_OUTPUT_DIR}" ]]; then
    echo "❌ FAIL: Directory structure not maintained"
    exit 1
fi

echo "✅ Directory structure maintained"

echo ""
echo "🎉 SUCCESS: T006 - Published markdown correctly generates HTML files"
echo "✅ HTML file generation: ${EXPECTED_HTML}"
echo "✅ Content preservation: Original markdown → HTML"  
echo "✅ Metadata processing: Title and frontmatter handled"
echo "✅ File structure: Directory organization maintained"
echo ""
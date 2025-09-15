#!/bin/bash
# T009: Contract test - Asset files copied to public directory
# This test verifies that referenced assets (images, PDFs, etc.) are copied 
# to the public directory and HTML links are updated correctly.

set -e

echo "🧪 T009: Testing asset files copied to public directory"

# Test configuration
TEST_DIR="test_assets"
TEST_NOTE="note-with-assets"
ASSETS_DIR="assets"
DOCS_DIR="documents"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"
TEST_ASSETS_DIR="${TEST_CONTENT_DIR}/${ASSETS_DIR}"
TEST_DOCS_DIR="${TEST_CONTENT_DIR}/${DOCS_DIR}"
TEST_FILE="${TEST_CONTENT_DIR}/${TEST_NOTE}.md"
TEST_HTML="${TEST_OUTPUT_DIR}/${TEST_NOTE}.html"

# Asset files to create
IMG_FILE="screenshot.png"
PDF_FILE="guide.pdf"
PUBLIC_ASSETS_DIR="public/${TEST_DIR}/${ASSETS_DIR}"
PUBLIC_DOCS_DIR="public/${TEST_DIR}/${DOCS_DIR}"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up test content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Creating test assets and content..."
mkdir -p "${TEST_ASSETS_DIR}"
mkdir -p "${TEST_DOCS_DIR}"

# Create dummy image file (PNG header)
printf '\x89PNG\x0d\x0a\x1a\x0a\x00\x00\x00\x0dIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90\x77\x53\xde\x00\x00\x00\x0cIDATx\x9cc\x00\x01\x00\x00\x05\x00\x01\x0d\x0a\x2d\xb4\x00\x00\x00\x00IEND\xaeB`\x82' > "${TEST_ASSETS_DIR}/${IMG_FILE}"

# Create dummy PDF file (basic PDF header)
cat > "${TEST_DOCS_DIR}/${PDF_FILE}" << 'EOF'
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<<
/Type /Page
/Parent 2 0 R
/Resources <<
/Font <<
/F1 4 0 R 
>>
>>
/MediaBox [0 0 612 792]
/Contents 5 0 R
>>
endobj
4 0 obj
<<
/Type /Font
/Subtype /Type1
/BaseFont /Times-Roman
>>
endobj
5 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
72 720 Td
(Test PDF Document) Tj
ET
endstream
endobj
xref
0 6
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000274 00000 n 
0000000355 00000 n 
trailer
<<
/Size 6
/Root 1 0 R
>>
startxref
449
%%EOF
EOF

echo "✅ Test assets created:"
echo "   - ${TEST_ASSETS_DIR}/${IMG_FILE} (dummy PNG)"
echo "   - ${TEST_DOCS_DIR}/${PDF_FILE} (dummy PDF)"

# Use existing TIL content as base and add asset references
cp "content/til/quartz-static-sites.md" "${TEST_FILE}"
# Update the copied file to use test-specific title and add asset references
sed -i '' 's/title: "TIL: Quartz for Publishing Obsidian Notes"/title: "Note with Asset References"/' "${TEST_FILE}"
sed -i '' 's/tags: \[til, quartz, obsidian\]/tags: [test, assets]/' "${TEST_FILE}"

# Append asset references to the TIL content
cat >> "${TEST_FILE}" << EOF

## Asset Testing

This section tests asset handling capabilities.

### Image Reference
Here's an image embedded in the content:

![Test Screenshot](${ASSETS_DIR}/${IMG_FILE})

The image should be copied to the public directory and the src attribute updated.

### Document Reference
Here's a link to a PDF document:

[Download Guide](${DOCS_DIR}/${PDF_FILE})

The PDF should be copied and the href attribute updated correctly.

### Path Testing
- Image path: \`${ASSETS_DIR}/${IMG_FILE}\`
- Document path: \`${DOCS_DIR}/${PDF_FILE}\`

**Test Requirements:**
- Assets must be copied to public directory
- HTML img src attributes must point to correct locations
- HTML a href attributes must point to correct locations
- Directory structure must be preserved
EOF

echo "✅ Test note created: ${TEST_FILE}"

echo "🏗️ Running Quartz build..."
if ! npx quartz build; then
    echo "❌ Build failed unexpectedly"
    exit 1
fi

echo "🔍 Verifying HTML file was generated..."
if [[ ! -f "${TEST_HTML}" ]]; then
    echo "❌ FAIL: Expected HTML file not found: ${TEST_HTML}"
    exit 1
fi

echo "✅ HTML file generated: ${TEST_HTML}"

echo "🔍 Checking if assets were copied to public directory..."

# Check image file copied
PUBLIC_IMG="${PUBLIC_ASSETS_DIR}/${IMG_FILE}"
if [[ ! -f "${PUBLIC_IMG}" ]]; then
    echo "❌ FAIL: Image asset not copied to public directory: ${PUBLIC_IMG}"
    echo "📁 Public directory contents:"
    find public -name "*.png" 2>/dev/null | head -5 || echo "No PNG files found"
    exit 1
fi

echo "✅ Image asset copied: ${PUBLIC_IMG}"

# Check PDF file copied
PUBLIC_PDF="${PUBLIC_DOCS_DIR}/${PDF_FILE}"
if [[ ! -f "${PUBLIC_PDF}" ]]; then
    echo "❌ FAIL: PDF asset not copied to public directory: ${PUBLIC_PDF}"
    echo "📁 Public directory contents:"
    find public -name "*.pdf" 2>/dev/null | head -5 || echo "No PDF files found"
    exit 1
fi

echo "✅ PDF asset copied: ${PUBLIC_PDF}"

echo "🔍 Verifying directory structure preservation..."
if [[ ! -d "${PUBLIC_ASSETS_DIR}" ]] || [[ ! -d "${PUBLIC_DOCS_DIR}" ]]; then
    echo "❌ FAIL: Asset directory structure not preserved in public"
    echo "📁 Expected directories:"
    echo "   - ${PUBLIC_ASSETS_DIR}"
    echo "   - ${PUBLIC_DOCS_DIR}"
    exit 1
fi

echo "✅ Directory structure preserved in public"

echo "🔍 Checking HTML image src attributes..."
if ! grep -q "src.*${ASSETS_DIR}.*${IMG_FILE}" "${TEST_HTML}"; then
    echo "❌ FAIL: Image src attribute not updated correctly in HTML"
    echo "📄 Looking for image references:"
    grep -i "img\|src" "${TEST_HTML}" || echo "No image references found"
    exit 1
fi

echo "✅ Image src attribute updated correctly"

echo "🔍 Checking HTML document href attributes..."
if ! grep -q "href.*${DOCS_DIR}.*${PDF_FILE}" "${TEST_HTML}"; then
    echo "❌ FAIL: Document href attribute not updated correctly in HTML"
    echo "📄 Looking for document references:"
    grep -i "href.*pdf\|download" "${TEST_HTML}" || echo "No document references found"
    exit 1
fi

echo "✅ Document href attribute updated correctly"

echo "🔍 Verifying asset file integrity..."
# Basic check that files weren't corrupted during copy
if [[ $(wc -c < "${TEST_ASSETS_DIR}/${IMG_FILE}") != $(wc -c < "${PUBLIC_IMG}") ]]; then
    echo "❌ FAIL: Image file size changed during copy (possible corruption)"
    exit 1
fi

if [[ $(wc -c < "${TEST_DOCS_DIR}/${PDF_FILE}") != $(wc -c < "${PUBLIC_PDF}") ]]; then
    echo "❌ FAIL: PDF file size changed during copy (possible corruption)"
    exit 1
fi

echo "✅ Asset file integrity preserved during copy"

echo ""
echo "🎉 SUCCESS: T009 - Asset files correctly copied and linked"
echo "✅ Image copying: PNG files copied to public directory"
echo "✅ Document copying: PDF files copied to public directory"
echo "✅ Path preservation: Directory structure maintained"
echo "✅ Link updates: HTML src/href attributes point to correct locations"
echo "✅ File integrity: Assets copied without corruption"
echo ""
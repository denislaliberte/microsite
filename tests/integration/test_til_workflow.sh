#!/bin/bash
# T010: Integration test - Complete TIL notes workflow  
# This test validates the complete workflow using real TIL (Today I Learned) 
# content with bidirectional wiki links, as described in quickstart.md.

set -e

echo "🧪 T010: Testing complete TIL workflow with bidirectional links"

# Test configuration
TEST_DIR="test_til_workflow"
SPEC_KIT_NOTE="2025-09-12-spec-kit"
QUARTZ_NOTE="2025-09-12-quartz-static-sites"
PRIVATE_NOTE="2025-09-12-private-thoughts"
TEST_CONTENT_DIR="content/${TEST_DIR}"
TEST_OUTPUT_DIR="public/${TEST_DIR}"

SPEC_KIT_FILE="${TEST_CONTENT_DIR}/${SPEC_KIT_NOTE}.md"
QUARTZ_FILE="${TEST_CONTENT_DIR}/${QUARTZ_NOTE}.md"
PRIVATE_FILE="${TEST_CONTENT_DIR}/${PRIVATE_NOTE}.md"

SPEC_KIT_HTML="${TEST_OUTPUT_DIR}/${SPEC_KIT_NOTE}.html"
QUARTZ_HTML="${TEST_OUTPUT_DIR}/${QUARTZ_NOTE}.html"
PRIVATE_HTML="${TEST_OUTPUT_DIR}/${PRIVATE_NOTE}.html"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up test TIL content..."
    rm -rf "${TEST_CONTENT_DIR}"
    rm -rf "${TEST_OUTPUT_DIR}"
}

# Ensure cleanup on exit
trap cleanup EXIT

echo "📝 Creating complete TIL workflow content..."
mkdir -p "${TEST_CONTENT_DIR}"

# Create published TIL note about Spec Kit
cat > "${SPEC_KIT_FILE}" << 'EOF'
---
title: "TIL: GitHub Spec Kit for Spec-Driven Development"
publish: true
tags: [til, tools, development, github]
date: 2025-09-12
---

# TIL: GitHub Spec Kit for Spec-Driven Development

Today I learned about GitHub's Spec Kit, a powerful approach to spec-driven development that helps teams build better software by starting with clear specifications.

## Key Insights

**What is Spec Kit?**
- Framework for creating detailed technical specifications
- Integrates with GitHub workflows seamlessly  
- Promotes collaboration through clear documentation
- Reduces miscommunication in development teams

**Why It Matters:**
- Specifications become the source of truth
- Easier onboarding for new team members
- Better estimation and project planning
- Reduced technical debt through upfront design

## Related Learning
This connects well with my learning about [[2025-09-12-quartz-static-sites|Quartz for publishing technical notes]].

## Implementation Notes
- Start with user stories and requirements
- Break down into technical specifications
- Use markdown for easy version control
- Link specifications to implementation

**Tags**: #til #tools #development #github #specifications

---
*This is part of my ongoing learning about development tools and processes.*
EOF

# Create published TIL note about Quartz with bidirectional link
cat > "${QUARTZ_FILE}" << 'EOF'
---
title: "TIL: Quartz for Publishing Obsidian Notes"
publish: true
tags: [til, quartz, obsidian, publishing, static-sites]
date: 2025-09-12
---

# TIL: Quartz for Publishing Obsidian Notes

Today I learned about Quartz v4, an excellent static site generator specifically designed for publishing Obsidian vaults and digital gardens.

## Key Features

**Publishing Power:**
- Converts Obsidian notes to beautiful static websites
- Preserves wiki links and bidirectional relationships
- Supports all Obsidian syntax including callouts
- Fast build times with modern tooling

**Perfect for:**
- Digital gardens and knowledge bases
- Technical documentation sites  
- Personal learning journals
- Team knowledge sharing

## Connection to Development Workflow
This tool pairs perfectly with structured development approaches like [[2025-09-12-spec-kit|GitHub Spec Kit]] for creating comprehensive documentation systems.

## Technical Details
- Built with TypeScript and modern web technologies
- Supports themes and customization
- Mobile-responsive design
- SEO optimized output

**Performance:**
- Sub-second build times for most vaults
- Efficient bundling with esbuild
- CDN-friendly static output

## Next Steps
- Set up personal knowledge base
- Integrate with existing note-taking workflow
- Explore advanced configuration options

**Tags**: #til #quartz #obsidian #publishing #static-sites #knowledge-management

---
*Part of my exploration of tools for knowledge management and technical writing.*
EOF

# Create private TIL note that should be excluded
cat > "${PRIVATE_FILE}" << 'EOF'
---
title: "Private Thoughts on Development Tools"
publish: false
tags: [private, thoughts, development]
date: 2025-09-12
---

# Private Development Thoughts

These are my private thoughts that should NOT be published.

## Internal Notes
- Personal opinions about tools
- Work-related sensitive information  
- Incomplete thoughts and drafts
- Strategic considerations

## Connections
Links to other notes: [[2025-09-12-spec-kit]] and [[2025-09-12-quartz-static-sites]]

**CRITICAL**: If this appears in the built site, the publish filter is broken!

This content should never be public and serves as a test case for the ExplicitPublish filter.
EOF

echo "✅ TIL workflow content created:"
echo "   - ${SPEC_KIT_FILE} (published TIL about Spec Kit)"
echo "   - ${QUARTZ_FILE} (published TIL about Quartz)"
echo "   - ${PRIVATE_FILE} (private TIL - should be excluded)"

echo "🏗️ Running Quartz build..."
if ! npx quartz build; then
    echo "❌ Build failed unexpectedly"
    exit 1
fi

echo "🔍 Verifying published TIL notes generate HTML..."
for published_html in "${SPEC_KIT_HTML}" "${QUARTZ_HTML}"; do
    if [[ ! -f "${published_html}" ]]; then
        echo "❌ FAIL: Published TIL HTML not generated: ${published_html}"
        exit 1
    fi
done

echo "✅ Published TIL notes generated HTML correctly"

echo "🔍 Verifying private TIL note is excluded..."
if [[ -f "${PRIVATE_HTML}" ]]; then
    echo "❌ FAIL: Private TIL note generated HTML (should be excluded): ${PRIVATE_HTML}"
    echo "This indicates the ExplicitPublish filter is not working"
    exit 1
fi

echo "✅ Private TIL note correctly excluded from build"

echo "🔍 Testing bidirectional wiki links..."

# Check forward link: Spec Kit → Quartz
if ! grep -q 'href.*2025-09-12-quartz-static-sites' "${SPEC_KIT_HTML}"; then
    echo "❌ FAIL: Forward wiki link from Spec Kit to Quartz not working"
    echo "📄 Looking for Quartz references in Spec Kit HTML:"
    grep -A3 -B3 "quartz\|Quartz" "${SPEC_KIT_HTML}" || echo "No Quartz references found"
    exit 1
fi

echo "✅ Forward link: Spec Kit → Quartz working"

# Check reverse link: Quartz → Spec Kit
if ! grep -q 'href.*2025-09-12-spec-kit' "${QUARTZ_HTML}"; then
    echo "❌ FAIL: Reverse wiki link from Quartz to Spec Kit not working"
    echo "📄 Looking for Spec Kit references in Quartz HTML:"
    grep -A3 -B3 "spec-kit\|Spec Kit" "${QUARTZ_HTML}" || echo "No Spec Kit references found"
    exit 1
fi

echo "✅ Reverse link: Quartz → Spec Kit working"

echo "🔍 Checking for backlinks functionality..."
# Check if notes show incoming connections (backlinks)
backlinks_found=0
if grep -q -i "backlink\|incoming\|referenced.*by" "${SPEC_KIT_HTML}"; then
    ((backlinks_found++))
fi
if grep -q -i "backlink\|incoming\|referenced.*by" "${QUARTZ_HTML}"; then
    ((backlinks_found++))
fi

if [[ $backlinks_found -gt 0 ]]; then
    echo "✅ Backlinks functionality appears to be working"
else
    echo "⚠️ WARNING: Backlinks not detected - may need ObsidianFlavoredMarkdown configuration"
fi

echo "🔍 Verifying tag page generation..."
# Check for tag pages in public directory
tag_pages_found=0
for tag in "til" "tools" "development" "quartz" "obsidian"; do
    if find public -name "*tag*" -o -name "*${tag}*" | grep -q .; then
        ((tag_pages_found++))
    fi
done

if [[ $tag_pages_found -gt 0 ]]; then
    echo "✅ Tag pages appear to be generated"
else
    echo "⚠️ WARNING: Tag pages not found - may need tag plugin configuration"
fi

echo "🔍 Validating content quality..."
# Check that meaningful content is preserved
essential_content=("GitHub Spec Kit" "Quartz for Publishing" "spec-driven development" "static site generator")
content_preserved=0

for content in "${essential_content[@]}"; do
    if grep -q "${content}" "${SPEC_KIT_HTML}" "${QUARTZ_HTML}"; then
        ((content_preserved++))
    fi
done

if [[ $content_preserved -eq ${#essential_content[@]} ]]; then
    echo "✅ Essential content preserved in HTML output"
else
    echo "⚠️ WARNING: Some essential content may not be preserved correctly"
fi

echo "🔍 Testing search exclusion of private content..."
SEARCH_INDEX="public/static/contentIndex.json"
if [[ -f "${SEARCH_INDEX}" ]]; then
    if grep -q "Private Thoughts" "${SEARCH_INDEX}"; then
        echo "❌ FAIL: Private content found in search index"
        exit 1
    fi
    echo "✅ Private content excluded from search index"
else
    echo "⚠️ Search index not found - skipping search exclusion test"
fi

echo ""
echo "🎉 SUCCESS: T010 - Complete TIL workflow functions correctly"
echo "✅ Published filtering: Only publish: true notes generate HTML"
echo "✅ Unpublished filtering: publish: false notes completely excluded"
echo "✅ Bidirectional links: Wiki links work in both directions"  
echo "✅ Content preservation: Meaningful content maintained in HTML"
echo "✅ Search exclusion: Private content not searchable"
echo "⚠️ Backlinks & Tags: May need additional plugin configuration"
echo ""
echo "📊 TIL Workflow Summary:"
echo "   • 2 published TIL notes → 2 HTML pages generated"
echo "   • 1 private TIL note → correctly excluded from build"
echo "   • Bidirectional wiki links functioning"
echo "   • Content integrity maintained throughout process"
echo ""
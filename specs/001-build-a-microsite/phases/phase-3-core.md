# Phase 3: Core Implementation

> **⚠️ IMPLEMENTATION LOGGING REQUIRED**
> **You MUST document your work in the [📝 Implementation Log](#-phase-3-implementation-log) at the bottom of this file.**
> Update it in real-time as you complete tasks, encounter issues, or make decisions.


**Prerequisites**: Phase 2 complete (all tests written and failing)
**Duration**: ~25-30 minutes  
**Dependencies**: T006-T011 tests must be failing
**⚠️ CRITICAL**: Only proceed after Phase 2 tests are failing (TDD approach)

## Overview

This phase implements the core functionality to make Phase 2 tests pass. We work iteratively, making one test pass at a time, following Test-Driven Development principles.

**Key Goal**: Transform failing tests into passing tests through minimal, targeted implementation.

## TDD Implementation Philosophy

**Implementation Strategy:**
- **One test at a time**: Focus on making a single test pass
- **Minimal implementation**: Write only what's needed to pass the test
- **Refactor after green**: Clean up code once tests pass
- **Verify continuously**: Run tests after each change

**Test-Driven Cycle:**
1. **Red**: Test fails (Phase 2 setup)
2. **Green**: Write minimum code to pass test
3. **Refactor**: Improve code while keeping tests green
4. **Repeat**: Move to next failing test

## Project Context

From research and design phases, core implementation requires:

- **ExplicitPublish filter**: Only `publish: true` content included
- **ObsidianFlavoredMarkdown plugin**: Wiki link processing  
- **Assets plugin**: File copying and link resolution
- **Performance optimization**: SPA mode, CDN caching, esbuild
- **Content structure**: Real TIL notes for testing

## Tasks (T012-T018)

### T012: Create test content structure with published/unpublished notes
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `content/test/`  
**Makes Pass**: T006, T007 (published/unpublished tests)

**What to implement:**
Create the basic content structure needed for tests T006-T007 to validate published/unpublished filtering.

**Implementation Steps:**
1. Create `content/test/` directory for test content
2. Add basic published note with `publish: true` frontmatter
3. Add basic unpublished note with `publish: false` frontmatter
4. Test build process with `npx quartz build`
5. Verify tests T006 and T007 behavior changes

**Test Content Structure:**
```
content/test/
├── published-note.md        # publish: true
└── unpublished-note.md      # publish: false
```

**Sample Content Patterns:**
```markdown
# Published Note Format
---
title: "Test Published Note"
publish: true
date: 2025-09-12
tags: [test]
---
# Test Content
Basic content for testing published note generation.

# Unpublished Note Format  
---
title: "Test Private Note"
publish: false
date: 2025-09-12
---
# Private Content
This should not appear in build output.
```

**Test After This Step:**
```bash
npx quartz build
ls public/test/  # Check what gets generated

# Run specific tests
./tests/integration/test_published_notes.sh
./tests/integration/test_unpublished_notes.sh
```

**Success Criteria:**
- [ ] Basic test content structure created
- [ ] Published content generates HTML (T006 moves toward passing)
- [ ] Unpublished content handling improves (T007 behavior changes)
- [ ] Build process works with real content

---

### T013: Create sample TIL notes with wiki links per quickstart.md
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `content/til/` (in your vault)  
**Makes Pass**: T008, T010 (wiki links, TIL workflow tests)

**What to implement:**
Create the real TIL notes content with bidirectional wiki links as described in quickstart.md.

**Implementation Steps:**
1. Create TIL directory structure in your content
2. Add TIL note about Spec Kit with wiki link to Quartz note
3. Add TIL note about Quartz with wiki link back to Spec Kit
4. Add private TIL note for exclusion testing
5. Test wiki link processing

**TIL Content Requirements from quickstart.md:**

**Spec Kit TIL Note:**
```markdown
---
title: "TIL: GitHub Spec Kit for Spec-Driven Development"
publish: true
date: 2025-09-12
tags: [til, tools, development]
---

# TIL: GitHub Spec Kit

Today I learned about GitHub's [Spec Kit](https://github.com/github/spec-kit) - structured prompts that guide LLMs to build the right thing.

## My Use Case
Used this to plan a [[quartz-static-sites|Quartz microsite]] project.
```

**Quartz TIL Note:**
```markdown
---
title: "TIL: Quartz for Publishing Obsidian Notes"
publish: true
date: 2025-09-12
tags: [til, quartz, obsidian]
---

# TIL: Quartz Static Sites

[Quartz](https://quartz.jzhao.xyz/) converts Obsidian notes to websites.

## My Use Case
Used [[spec-kit|Spec Kit]] workflow to plan this microsite setup.
```

**Private TIL Note:**
```markdown
---
title: "Private TIL Notes"
publish: false
date: 2025-09-12
---
Internal workflow notes - should not be published.
```

**Test After This Step:**
```bash
npx quartz build
# Check for wiki link processing

# Run specific tests
./tests/integration/test_wiki_links.sh
./tests/integration/test_til_workflow.sh
```

**Success Criteria:**
- [ ] TIL content created with bidirectional links
- [ ] Wiki link patterns established
- [ ] Published/unpublished mix for testing
- [ ] Real content matches quickstart.md examples

---

### T014: Configure Quartz build process with ObsidianFlavoredMarkdown plugin
**Status**: 🟡 Pending  
**Type**: Sequential  
**File Target**: `quartz.config.ts` (enhance existing)  
**Makes Pass**: T008 (wiki links test)

**What to implement:**
Ensure the ObsidianFlavoredMarkdown plugin is properly configured and active for wiki link processing.

**Configuration Requirements from research.md:**
- **Wiki links enabled**: `wikilinks: true` 
- **Link resolution**: `markdownLinkResolution: "shortest"`
- **Comments support**: `comments: true` for %% blocks
- **Block references**: `blockReferences: true` for ^block-refs
- **Tags processing**: `tags: true` for #tag handling

**Implementation Steps:**
1. Verify ObsidianFlavoredMarkdown plugin in transformers array
2. Ensure all required options are enabled
3. Verify CrawlLinks plugin for link resolution
4. Test build with wiki link content
5. Check generated HTML for href attributes

**Key Plugin Configuration:**
```typescript
Plugin.ObsidianFlavoredMarkdown({
  wikilinks: true,
  comments: true, 
  blockReferences: true,
  tags: true
}),
Plugin.CrawlLinks({ 
  markdownLinkResolution: "shortest" 
})
```

**Verification Commands:**
```bash
# Test configuration loading
npx quartz build --dry-run

# Test with actual wiki links
npx quartz build

# Check for HTML href generation
grep -r "href.*" public/til/ || echo "No links found"
```

**Test After This Step:**
```bash
./tests/integration/test_wiki_links.sh
# Should show improvement in wiki link processing
```

**Success Criteria:**
- [ ] ObsidianFlavoredMarkdown plugin active and configured
- [ ] Wiki link processing enabled with all options
- [ ] Link resolution configured for shortest paths
- [ ] Build generates HTML href attributes from wiki links

---

### T015: Configure frontmatter filtering with ExplicitPublish plugin
**Status**: 🟡 Pending  
**Type**: Sequential  
**File Target**: `quartz.config.ts` (modify existing)  
**Makes Pass**: T007 (unpublished notes test)

**What to implement:**
Configure the ExplicitPublish filter to ensure only content with `publish: true` is included in the build.

**Filter Plugin Requirements:**
- **ExplicitPublish**: Only forwards content with `publish: true`
- **Strict filtering**: Content without `publish: true` is excluded
- **Search exclusion**: Unpublished content not in search index
- **Sitemap exclusion**: Unpublished URLs not in sitemap

**Implementation Steps:**
1. Verify ExplicitPublish filter in filters array
2. Remove any conflicting filters (like RemoveDrafts)
3. Test filtering with published/unpublished content
4. Verify exclusion from search and sitemap
5. Validate complete content exclusion

**Filter Configuration:**
```typescript
plugins: {
  // ...
  filters: [Plugin.ExplicitPublish()],
  // ...
}
```

**Verification Process:**
```bash
# Build with mixed published/unpublished content
npx quartz build

# Check public directory structure
find public/ -name "*.html" | grep -v published || echo "Good - no unpublished HTML"

# Check search index
grep -i "published.*false" public/static/contentIndex.json || echo "Good - no unpublished in search"

# Check sitemap
grep -i "unpublished\|private" public/sitemap.xml || echo "Good - no unpublished in sitemap"
```

**Test After This Step:**
```bash
./tests/integration/test_unpublished_notes.sh
# Should pass or show significant improvement
```

**Success Criteria:**
- [ ] ExplicitPublish filter active and working
- [ ] Only `publish: true` content generates HTML
- [ ] Unpublished content completely excluded from build
- [ ] Search and sitemap exclude unpublished content

---

### T016: Configure static asset processing and media file handling
**Status**: 🟡 Pending  
**Type**: Sequential  
**File Target**: `quartz.config.ts` (modify existing)  
**Makes Pass**: T009 (asset handling test)

**What to implement:**
Ensure the Assets plugin is properly configured to copy referenced files to the public directory and update HTML links.

**Asset Handling Requirements from research.md:**
- **Assets plugin**: Copies referenced files to public directory
- **Link updating**: Updates src/href attributes in HTML
- **Path preservation**: Maintains folder structure
- **File type support**: Images, PDFs, documents, etc.

**Implementation Steps:**
1. Verify Assets plugin in emitters array
2. Ensure Static plugin for non-markdown files  
3. Create test assets for validation
4. Test asset copying and link updating
5. Verify various file types are handled

**Plugin Configuration:**
```typescript
emitters: [
  // ...
  Plugin.Assets(),
  Plugin.Static(),
  // ...
]
```

**Test Asset Creation:**
```bash
# Create test assets
mkdir -p content/test/assets
echo "Test image content" > content/test/assets/test-image.png
echo "Test document content" > content/test/assets/test-doc.pdf

# Create note referencing assets
cat > content/test/note-with-assets.md << 'EOF'
---
title: "Note with Assets"  
publish: true
---
![Test Image](assets/test-image.png)
[Download PDF](assets/test-doc.pdf)
EOF
```

**Verification Process:**
```bash
npx quartz build

# Check asset copying
ls -la public/test/assets/

# Check HTML link updates
grep -r "assets/" public/test/note-with-assets/
```

**Test After This Step:**
```bash
./tests/integration/test_asset_handling.sh
# Should pass with proper asset handling
```

**Success Criteria:**
- [ ] Assets plugin configured and active
- [ ] Referenced files copied to public directory
- [ ] HTML links updated to point to copied assets
- [ ] Various file types handled properly

---

### T017: Validate wiki link resolution and backlink generation
**Status**: 🟡 Pending  
**Type**: Sequential  
**File Target**: Build validation  
**Makes Pass**: T008, T010 (wiki links, TIL workflow tests)

**What to implement:**
Verify that wiki links are fully functional with bidirectional linking and backlinks component working.

**Wiki Link System Components:**
- **Forward links**: `[[target]]` becomes HTML href
- **Backlinks**: Target pages show incoming links
- **Custom text**: `[[target|display]]` preserves display text
- **Link resolution**: Finds correct target files

**Implementation Steps:**
1. Build site with TIL content containing wiki links
2. Verify forward links generate proper HTML href attributes
3. Check backlinks component shows incoming links
4. Test custom link text preservation
5. Validate link resolution accuracy

**Backlinks Component Verification:**
From quartz.layout.ts, ensure Backlinks component is in the right sidebar:
```typescript
right: [
  Component.Graph(),
  Component.DesktopOnly(Component.TableOfContents()),
  Component.Backlinks(),  // This generates backlinks
]
```

**Link Resolution Testing:**
```bash
# Build with TIL content
npx quartz build

# Check forward links (spec-kit → quartz-static-sites)
grep -r "href.*quartz-static-sites" public/til/spec-kit/ || echo "Forward link missing"

# Check backward links (quartz-static-sites → spec-kit)  
grep -r "href.*spec-kit" public/til/quartz-static-sites/ || echo "Backward link missing"

# Check backlinks component
grep -r "backlinks" public/til/ || echo "Backlinks component missing"
```

**Test After This Step:**
```bash
./tests/integration/test_wiki_links.sh
./tests/integration/test_til_workflow.sh
# Both should pass with complete wiki link functionality
```

**Success Criteria:**
- [ ] Wiki links convert to HTML href attributes
- [ ] Bidirectional links work correctly  
- [ ] Backlinks component generates incoming link lists
- [ ] Custom link text preserved in HTML
- [ ] Link resolution finds correct targets

---

### T018: Optimize build configuration for performance and client-side search
**Status**: 🟡 Pending  
**Type**: Sequential  
**File Target**: `quartz.config.ts` (enhance existing)  
**Makes Pass**: T011 (build performance test)

**What to implement:**
Optimize configuration for performance requirements and ensure search functionality works properly.

**Performance Requirements from research.md:**
- **SPA mode**: `enableSPA: true` for fast navigation
- **CDN caching**: `cdnCaching: true` for static assets
- **Search optimization**: Efficient search index generation
- **Build performance**: Target <30s for typical vault size

**Implementation Steps:**
1. Verify SPA mode enabled for fast navigation
2. Enable CDN caching for fonts and static assets
3. Configure search index optimization
4. Test build performance with realistic content
5. Verify search functionality works

**Performance Configuration:**
```typescript
configuration: {
  enableSPA: true,           // Fast client-side navigation
  enablePopovers: true,      // Link previews
  theme: {
    cdnCaching: true,        // Cache fonts and assets
    fontOrigin: "googleFonts" // Use Google Fonts CDN
  }
},
plugins: {
  emitters: [
    Plugin.ContentIndex({
      enableSiteMap: true,   // SEO and navigation
      enableRSS: true       // Content syndication
    })
  ]
}
```

**Search Index Optimization:**
- ContentIndex plugin generates client-side search
- Search functionality works without server
- Full-text search across all published content

**Performance Testing:**
```bash
# Test build time
time npx quartz build

# Test search index generation
ls -la public/static/contentIndex.json

# Test SPA navigation (check for JavaScript)
grep -r "navigation" public/static/ || echo "Check SPA setup"
```

**Test After This Step:**
```bash
./tests/integration/test_build_performance.sh
# Should meet <30s performance requirement

# Test search functionality  
npx quartz build --serve --port 3001 &
# Visit localhost:3001 and test search
```

**Success Criteria:**
- [ ] SPA mode enabled for fast navigation
- [ ] CDN caching configured for performance  
- [ ] Search index generates efficiently
- [ ] Build performance meets <30s requirement
- [ ] Client-side search functionality works

---

## Phase 3 Validation

**After completing all core implementation tasks (T012-T018):**

### Incremental Test Validation
Run Phase 2 tests after each task to see progress:

```bash
# After T012-T013: Content creation
./tests/integration/test_published_notes.sh
./tests/integration/test_til_workflow.sh

# After T014-T015: Plugin configuration  
./tests/integration/test_wiki_links.sh
./tests/integration/test_unpublished_notes.sh

# After T016-T017: Asset handling and links
./tests/integration/test_asset_handling.sh

# After T018: Performance optimization
./tests/integration/test_build_performance.sh
```

### Complete Test Suite Validation
```bash
echo "Running complete Phase 2 test suite..."

all_tests_pass=true
for test in tests/integration/*.sh; do
    echo "Running $(basename $test)..."
    if $test; then
        echo "✅ $(basename $test) PASSES"
    else
        echo "❌ $(basename $test) FAILS"
        all_tests_pass=false
    fi
done

if $all_tests_pass; then
    echo "🎉 All Phase 2 tests now pass - Core implementation complete!"
else
    echo "⚠️ Some tests still failing - check implementation"
fi
```

### Build System Validation
```bash
# Full build test
npx quartz build

# Development server test  
timeout 10s npx quartz build --serve --port 3002 &
sleep 5
curl -s http://localhost:3002/ > /dev/null && echo "✅ Dev server works"
```

### Phase 3 Success Criteria
- [ ] All T012-T018 tasks completed successfully
- [ ] All Phase 2 tests (T006-T011) now pass
- [ ] Published content generates HTML files
- [ ] Unpublished content completely excluded
- [ ] Wiki links work bidirectionally with backlinks
- [ ] Assets copied and linked properly
- [ ] Build performance meets <30s requirement
- [ ] Search functionality operational

### TDD Cycle Completion
✅ **Red Phase**: Tests were failing (Phase 2)  
✅ **Green Phase**: Implementation makes tests pass (Phase 3)  
✅ **Refactor Phase**: Code works and tests pass  

### Ready for Phase 4 When:
✅ All Phase 2 contract tests pass  
✅ Local build system fully functional  
✅ Content processing works end-to-end  
✅ Performance requirements met  
✅ Ready for deployment setup  

**Next Step**: [Phase 4: Integration & Deployment](./phase-4-integration.md)

---

## Resources & References

**From research.md:**
- ExplicitPublish filter for `publish: true/false` control
- ObsidianFlavoredMarkdown plugin configuration options
- Performance optimization with SPA mode and CDN caching
- Assets plugin for file handling and link resolution

**From data-model.md:**
- Simple workflow: markdown → HTML conversion
- Frontmatter metadata processing  
- File-based content management approach
- No complex data models needed

**From quickstart.md:**
- TIL notes content examples and structure
- Wiki link patterns and bidirectional linking
- Build validation workflow and testing approach
- Real content scenarios for implementation

**From contracts/build-validation.sh:**
- Exact test scenarios that must pass
- Published/unpublished filtering requirements
- Wiki link conversion specifications
- Asset handling and performance requirements

**TDD Implementation Guidance:**
- Make one test pass at a time
- Write minimal code to satisfy failing tests  
- Test continuously during implementation
- Refactor only after tests are green

---

## 📝 Phase 3 Implementation Log

**Instructions for LLM:** As you implement the core functionality to make Phase 2 tests pass, document your implementation experience here. Record the challenges you encounter, alternatives you consider for making tests pass, decisions about which tests to tackle first, and your reasoning. Include any pivots in approach or insights about the TDD process.

```
[Document your core implementation experience here as you work through Phase 3 tasks]


```
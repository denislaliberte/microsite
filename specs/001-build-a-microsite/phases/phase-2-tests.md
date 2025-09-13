# Phase 2: Tests First (TDD)

> **⚠️ IMPLEMENTATION LOGGING REQUIRED**
> **You MUST document your work in the [📝 Implementation Log](#-phase-2-implementation-log) at the bottom of this file.** 
> Update it in real-time as you complete tasks, encounter issues, or make decisions.

**Prerequisites**: Phase 1 complete (Quartz setup and configuration)
**Duration**: ~20-25 minutes  
**Dependencies**: T001-T005 must be complete
**⚠️ CRITICAL**: These tests MUST be written and MUST FAIL before Phase 3 implementation

## Overview

This phase implements Test-Driven Development by writing contract tests that validate our requirements BEFORE we implement them. Each test should fail initially, proving it's testing real functionality.

**Key Goal**: Create failing tests that define exactly what we need to build in Phase 3.

## TDD Philosophy

**Why Tests Must Fail First:**
- **Proves tests work**: A test that passes before implementation might be broken
- **Defines requirements**: Failing tests show exactly what needs to be built
- **Guides implementation**: Code is written to make tests pass, not the other way around
- **Prevents over-engineering**: Only build what's needed to pass tests

## Contract Requirements

From `contracts/build-validation.sh` and project requirements, we need to test:

1. **Published markdown generates HTML files**
2. **Unpublished notes (publish: false) are excluded**  
3. **Wiki links [[note-name]] convert to HTML href attributes**
4. **Asset files are copied to public directory**
5. **Complete TIL workflow with bidirectional links**
6. **Build performance under 30 seconds**

## Tasks (T006-T011)

### T006: Contract test - Published markdown generates HTML
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_published_notes.sh`  

**What to test:**
Verify that markdown files with `publish: true` frontmatter generate corresponding HTML files in the correct location.

**Test Strategy:**
1. Create a test note with `publish: true`
2. Run `npx quartz build`
3. Verify HTML file exists in expected location
4. Verify content appears in generated HTML
5. Verify frontmatter metadata is processed

**Key Test Points:**
- HTML file generation: `public/[path]/index.html`
- Content preservation: Original markdown content in HTML
- Metadata processing: Tags and title from frontmatter
- File structure: Maintains directory organization

**Expected Initial Result**: ❌ FAIL (ExplicitPublish filter not yet working)

**Success Criteria:**
- [ ] Test script created and executable
- [ ] Test creates sample published content
- [ ] Test verifies HTML generation
- [ ] Test fails initially (proves it works)

---

### T007: Contract test - Unpublished notes excluded from build
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_unpublished_notes.sh`  

**What to test:**
Verify that markdown files with `publish: false` or missing `published` frontmatter are completely excluded from the build.

**Test Strategy:**
1. Create test note with `publish: false`
2. Run `npx quartz build`
3. Verify NO HTML file is generated
4. Verify content excluded from search index
5. Verify content excluded from sitemap

**Critical Exclusions to Test:**
- No HTML file: `public/[path]/index.html` should not exist
- No search indexing: Content not in `contentIndex.json`
- No sitemap entry: URL not in `sitemap.xml`
- No link references: Not discoverable through navigation

**From research.md**: ExplicitPublish filter ensures only `publish: true` content is included.

**Expected Initial Result**: ❌ FAIL (filter not yet configured properly)

**Success Criteria:**
- [ ] Test creates unpublished sample content
- [ ] Test verifies complete exclusion from build
- [ ] Test checks search and sitemap exclusion
- [ ] Test fails initially (proves filter needs work)

---

### T008: Contract test - Wiki links convert to HTML links
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_wiki_links.sh`  

**What to test:**
Verify that Obsidian-style wiki links `[[note-name]]` are converted to proper HTML href attributes and work bidirectionally.

**Test Strategy:**
1. Create source note with `[[target-note|custom text]]`
2. Create target note that should receive backlinks
3. Run `npx quartz build`
4. Verify forward link: source → target HTML href
5. Verify backlink: target shows incoming link from source
6. Verify custom link text is preserved

**Wiki Link Requirements from research.md:**
- **ObsidianFlavoredMarkdown plugin** handles conversion
- **Shortest path resolution** for link matching
- **Custom text support**: `[[file|display text]]`
- **Backlinks component** shows incoming connections

**Link Patterns to Test:**
```markdown
[[basic-link]]                    # Simple wiki link
[[target-note|Custom Text]]       # Link with custom display text
[[folder/nested-note]]            # Links to nested content
```

**Expected Initial Result**: ❌ FAIL (plugin not yet properly configured)

**Success Criteria:**
- [ ] Test creates interlinking content
- [ ] Test verifies HTML href generation
- [ ] Test validates backlink creation
- [ ] Test fails initially (proves plugin setup needed)

---

### T009: Contract test - Asset files copied to public directory
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_asset_handling.sh`  

**What to test:**
Verify that referenced assets (images, PDFs, etc.) are copied to the public directory and HTML links are updated correctly.

**Test Strategy:**
1. Create test assets (image, PDF, etc.)
2. Create note referencing these assets
3. Run `npx quartz build`
4. Verify assets copied to `public/` directory
5. Verify HTML links point to correct locations

**Asset Types to Test:**
- **Images**: PNG, JPG referenced in markdown
- **Documents**: PDFs linked in content
- **Path preservation**: Folder structure maintained
- **Link updates**: HTML src/href attributes correct

**From research.md**: Assets plugin handles file copying and link resolution automatically.

**Asset Reference Examples:**
```markdown
![Image](assets/screenshot.png)
[Download PDF](documents/guide.pdf)
```

**Expected Initial Result**: ❌ FAIL (Assets plugin not yet configured)

**Success Criteria:**
- [ ] Test creates various asset types
- [ ] Test verifies asset copying to public/
- [ ] Test validates link updates in HTML
- [ ] Test fails initially (proves plugin needs configuration)

---

### T010: Integration test - Complete TIL notes workflow
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_til_workflow.sh`  

**What to test:**
Validate the complete workflow using real TIL (Today I Learned) content with bidirectional wiki links, as described in quickstart.md.

**Test Strategy:**
1. Create TIL note about Spec Kit (published)
2. Create TIL note about Quartz (published, with link to Spec Kit)  
3. Create private TIL note (unpublished)
4. Run `npx quartz build`
5. Verify all published TIL notes generate HTML
6. Verify wiki links work between TIL notes
7. Verify unpublished TIL note is excluded
8. Verify tag pages are generated

**TIL Content Requirements from quickstart.md:**
```markdown
# Published TIL about Spec Kit
---
title: "TIL: GitHub Spec Kit for Spec-Driven Development"
publish: true
tags: [til, tools, development]
---
Links to: [[2025-09-12-quartz-static-sites|Quartz microsite]]

# Published TIL about Quartz  
---
title: "TIL: Quartz for Publishing Obsidian Notes"
publish: true
tags: [til, quartz, obsidian]
---
Links back to: [[2025-09-12-spec-kit|Spec Kit]]

# Private TIL (should be excluded)
---
publish: false
---
Internal notes not for publication
```

**Expected Initial Result**: ❌ FAIL (multiple systems not yet working together)

**Success Criteria:**
- [ ] Test creates complete TIL workflow content
- [ ] Test validates published/unpublished filtering
- [ ] Test verifies bidirectional wiki links
- [ ] Test checks tag page generation
- [ ] Test fails initially (proves end-to-end setup needed)

---

### T011: Integration test - Build performance validation (<30s)
**Status**: 🟡 Pending  
**Type**: [P] Parallel  
**File Target**: `tests/integration/test_build_performance.sh`  

**What to test:**
Verify that build performance meets the <30 second requirement for typical vault size (50-100 notes with cross-links).

**Test Strategy:**
1. Generate 50+ test notes with cross-links
2. Time the build process: `time npx quartz build`
3. Verify build completes in under 30 seconds
4. Verify all generated content is correct
5. Clean up test content

**Performance Requirements from research.md:**
- **Build Time**: <30 seconds for typical vault (100-1000 notes)
- **SPA Mode**: Enabled for fast navigation
- **CDN Caching**: Configured for performance
- **esbuild**: Bundling for optimal build speed

**Test Content Generation:**
```bash
# Generate realistic test content
for i in {1..50}; do
  create note with:
  - Cross-links to other notes
  - Realistic content length
  - Tags and frontmatter
  - Some with publish: true/false
done
```

**Expected Initial Result**: ❌ FAIL (configuration not yet optimized)

**Success Criteria:**
- [ ] Test generates realistic content load
- [ ] Test measures actual build time  
- [ ] Test validates <30s performance requirement
- [ ] Test fails initially (proves optimization needed)

---

## Phase 2 Validation

**After writing all test scripts (T006-T011):**

### Test Script Setup
```bash
# Create test directory
mkdir -p tests/integration

# Make all scripts executable  
chmod +x tests/integration/*.sh

# Run each test to verify they fail
for test in tests/integration/*.sh; do
    echo "Testing: $(basename $test)"
    if $test; then
        echo "⚠️ WARNING: Test passed but should fail!"
    else
        echo "✅ Test properly fails (ready for TDD)"
    fi
done
```

### TDD Validation Checklist
- [ ] **All 6 test scripts created**: One for each contract requirement
- [ ] **All tests FAIL initially**: Proves they test real functionality  
- [ ] **Tests are independent**: Can run in any order
- [ ] **Clear failure messages**: Easy to debug when implementing
- [ ] **Realistic test data**: Uses actual content patterns

### Common TDD Anti-Patterns to Avoid
❌ **Tests that pass before implementation** (broken tests)  
❌ **Tests that don't fail meaningfully** (not testing anything)  
❌ **Tests that depend on each other** (brittle test suite)  
❌ **Vague assertions** (hard to understand failures)  

### Phase 2 Success Criteria
- [ ] All contract requirements have failing tests
- [ ] Each test validates specific functionality
- [ ] Test failure messages guide implementation
- [ ] Test suite runs independently of implementation
- [ ] Ready to start Phase 3 implementation

### Ready for Phase 3 When:
✅ All T006-T011 test scripts written  
✅ All tests fail initially (TDD requirement)  
✅ Test failures clearly indicate what to build  
✅ Test suite is independent and repeatable  

**Next Step**: [Phase 3: Core Implementation](./phase-3-core.md)

---

## Resources & References

**From contracts/build-validation.sh:**
- Published notes must generate HTML files
- Unpublished notes excluded from build  
- Wiki links convert to href attributes
- Bidirectional links work correctly

**From research.md:**
- ExplicitPublish filter for `publish: true/false`
- ObsidianFlavoredMarkdown for wiki links
- Assets plugin for file handling
- Performance target <30s build time

**From quickstart.md:**
- TIL notes workflow examples
- Sample frontmatter patterns
- Build validation approach
- Real content testing scenarios

**From data-model.md:**
- Simple workflow: markdown → HTML
- Frontmatter metadata processing
- File-based content management
- No complex data models needed

**TDD Resources:**
- Each test proves a contract requirement
- Failing tests guide implementation priorities
- Test-first ensures we build the right thing
- Implementation driven by making tests pass

---

## 📝 Phase 2 TDD Implementation Log

**Instructions for LLM:** As you create tests and follow the TDD approach, document your experience here. Record which tests you write, how they fail, what alternatives you consider, and the reasoning behind your test design decisions. Include any insights about the system requirements that emerge from writing failing tests.

```
[Document your TDD implementation experience here as you work through Phase 2 tasks]


```
# Tasks: Build Obsidian Notes Microsite with Quartz

**Input**: Design documents from `/specs/001-build-a-microsite/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/, quickstart.md

## Task Organization

This implementation is organized into **6 phases** with detailed task breakdowns in separate phase files:

### 📁 Phase Files Structure
```
specs/001-build-a-microsite/phases/
├── phase-1-setup.md        # T001-T005: Project initialization
├── phase-2-tests.md        # T006-T011: TDD contract tests  
├── phase-3-core.md         # T012-T018: Core implementation
├── phase-4-integration.md  # T019-T024: Deployment & automation
├── phase-5-polish.md       # T025-T030: Final validation & cleanup
└── phase-6-migration.md    # T031-T033: Professional infrastructure & domain migration
```

## Quick Start Guide

1. **Begin Implementation**: Start with [Phase 1: Setup](./phases/phase-1-setup.md)
2. **Follow TDD Process**: Proceed through phases sequentially
3. **Track Progress**: Each phase has completion criteria
4. **Validate Results**: Each phase validates the previous phase's work

## Phase Overview

### [Phase 1: Setup & Project Initialization](./phases/phase-1-setup.md) (T001-T005)
- **Duration**: ~15-20 minutes
- **Focus**: Quartz installation, configuration, vault linking
- **Dependencies**: None (can start immediately)
- **Key Outputs**: Working Quartz setup with Obsidian vault connection

### [Phase 2: Tests First (TDD)](./phases/phase-2-tests.md) (T006-T011) 
- **Duration**: ~20-25 minutes  
- **Focus**: Contract tests that must fail before implementation
- **Dependencies**: Phase 1 complete
- **Key Outputs**: Failing tests that guide implementation
- **⚠️ CRITICAL**: All tests must fail before proceeding to Phase 3

### [Phase 3: Core Implementation](./phases/phase-3-core.md) (T012-T018)
- **Duration**: ~25-30 minutes
- **Focus**: Make Phase 2 tests pass through implementation  
- **Dependencies**: Phase 2 tests written and failing
- **Key Outputs**: Functional local build with all features working

### [Phase 4: Integration & Deployment](./phases/phase-4-integration.md) (T019-T024)
- **Duration**: ~20-25 minutes
- **Focus**: GitHub Actions and automated deployment
- **Dependencies**: Phase 3 complete (local build working)
- **Key Outputs**: Live site at https://denislaliberte.github.io/microsite/

### [Phase 5: Polish & Validation](./phases/phase-5-polish.md) (T025-T030)
- **Duration**: ~15-20 minutes  
- **Focus**: Final validation and cleanup
- **Dependencies**: Phase 4 complete (site deployed)
- **Key Outputs**: Production-ready system with all requirements validated

### [Phase 6: Migration & Production Optimization](./phases/phase-6-migration.md) (T031-T033)
- **Duration**: ~60-90 minutes
- **Focus**: Professional infrastructure and domain migration
- **Dependencies**: Phase 5 complete (system validated)
- **Key Outputs**: Professional test suite and main domain deployment

## Task Summary

**Total Tasks**: 33 tasks across 6 phases (T001-T033)
**Total Estimated Time**: ~160-210 minutes
**Methodology**: Test-Driven Development (TDD) with contract validation

## Key Technical Requirements

**From plan.md:**
- Node.js 22.x runtime environment
- Quartz v4 static site generator framework  
- TypeScript configuration with esbuild bundling
- ObsidianFlavoredMarkdown plugin for wiki link processing
- GitHub Pages deployment target

**From research.md:**
- SPA mode with client-side search and popover previews
- Frontmatter-based publication control (publish: true/false)
- Symbolic links for vault integration without duplication
- Performance target: <30s build time, <200ms page load

**From contracts/build-validation.sh:**
- Published notes must generate corresponding HTML files
- Unpublished notes (publish: false) must be excluded
- Wiki links [[note-name]] must convert to HTML href attributes
- Bidirectional links between TIL notes must work correctly

## Implementation Approach

### TDD Methodology
1. **Write failing tests first** (Phase 2) - ensures we build the right thing
2. **Implement just enough to pass tests** (Phase 3) - prevents over-engineering  
3. **Refactor and optimize** (Phases 4-5) - polish for production

### Parallel Execution
Tasks marked **[P]** can run in parallel since they target different files:
- **Phase 1**: T002, T003, T004, T005 can run together
- **Phase 2**: T006-T011 all test different aspects independently
- **Phase 3**: T012, T013 create different content simultaneously

### Dependencies
- **Phase 1 → 2**: Setup before tests
- **Phase 2 → 3**: Tests must fail before implementation
- **Phase 3 → 4**: Local build working before deployment  
- **Phase 4 → 5**: Deployment working before final validation

## Success Criteria

**Project Complete When:**
- ✅ All 33 tasks completed across 6 phases
- ✅ Original contract requirements (build-validation.sh) pass
- ✅ Live site accessible at https://denislaliberte.github.io/ (main domain)
- ✅ Wiki links preserve Obsidian note relationships
- ✅ Publication control works (publish: true/false)
- ✅ Build performance <30s, site loads <2s
- ✅ Mobile responsive and cross-browser compatible
- ✅ Professional test suite operational (JavaScript or Ruby)
- ✅ Production-ready infrastructure and deployment pipeline

**🎯 Target**: Professional-grade Obsidian → Static Site system with industry-standard infrastructure and main domain deployment.

---

**Next Step**: Begin with [Phase 1: Setup & Project Initialization](./phases/phase-1-setup.md)
# Implementation Plan: Obsidian Notes Microsite with Quartz

**Branch**: `001-build-a-microsite` | **Date**: 2025-09-12 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-build-a-microsite/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → Loaded: Obsidian markdown to HTML microsite using Quartz
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detected Project Type: single (static site generator)
   → Set Structure Decision: Option 1 (single project)
3. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
4. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
5. Execute Phase 1 → contracts, data-model.md, quickstart.md, CLAUDE.md
6. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
7. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
8. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary

Build a microsite that converts Obsidian markdown files to HTML using Quartz v4 static site generator. The system will preserve wiki-style links, process frontmatter for publication control, and generate a complete static website structure suitable for GitHub Pages hosting.

## Technical Context

**Language/Version**: Node.js 22.x (required for Quartz v4)  
**Primary Dependencies**: Quartz v4 static site generator, esbuild (bundling), TypeScript  
**Storage**: File-based (markdown files, media assets, symbolic links to vault resources)  
**Testing**: Simple bash validation - verify markdown files generate expected HTML output  
**Target Platform**: Static HTML/CSS/JS output for GitHub Pages hosting  
**Project Type**: single - static site generation tool  
**Performance Goals**: Fast local builds (<10s for typical vault), client-side search, responsive navigation  
**Constraints**: Local development workflow, preserve Obsidian link structure, manual GitHub Pages deployment  
**Scale/Scope**: Support for personal vaults (100-1000 notes), hierarchical navigation, embedded media

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Simplicity**:
- Projects: 1 (static site generator only)
- Using framework directly? YES (Quartz v4 APIs directly, no wrapper abstractions)
- Single data model? YES (MarkdownNote entity with frontmatter metadata)
- Avoiding patterns? YES (no Repository/UoW - direct file system operations)

**Architecture**:
- Using framework directly? YES (Quartz v4 APIs directly, no custom libraries)
- Framework handles: 
  - Markdown processing: ObsidianFlavoredMarkdown plugin
  - Asset handling: Built-in static asset processing
  - Site generation: Quartz build system generates complete static site
- CLI usage: npx quartz commands (build, sync, create)
- Configuration: quartz.config.ts for all customization

**Testing (AUTOMATED)**:
- Build execution: `npx quartz build` completes without errors
- HTML generation: Verify expected HTML files exist in `public/` directory
- Link conversion: `grep` checks that `[[wiki-links]]` become proper `href` attributes
- Publication control: Verify `publish: false` files are excluded from output
- Asset processing: Check that referenced images/files are copied to `public/`
- Shell script automation: All validation via `build-validation.sh` - no manual steps

**Observability**:
- Structured logging included? YES (build progress, link resolution status, error context)
- Frontend logs → backend? N/A (static site generation)
- Error context sufficient? YES (file paths, link targets, build failures)

**Versioning**:
- Version number assigned? 0.1.0 (MAJOR.MINOR.BUILD)
- BUILD increments on every change? YES
- Breaking changes handled? YES (parallel testing, migration for config changes)

## Project Structure

### Documentation (this feature)
```
specs/001-build-a-microsite/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
```
# Actual Quartz Structure (confirmed by inspection)
content/                 # Your markdown files (symlink to ~/notes/3-Resources)
quartz/                 # Quartz framework (don't modify)
├── build.ts            # Build system
├── components/         # UI components  
├── plugins/            # Content processors
├── styles/             # CSS and themes
└── util/               # Framework utilities

public/                 # Generated static site (git-ignored locally, committed for deployment)
quartz.config.ts        # Main configuration file
quartz.layout.ts        # Layout configuration
package.json            # Dependencies
tsconfig.json           # TypeScript config

# Our additions (minimal):
tests/                  # Validation tests only
└── integration/        # Site generation validation
```

**Structure Decision**: Use Quartz as-is - we're consumers, not framework developers

## Phase 0: Outline & Research

1. **Extract unknowns from Technical Context** above:
   - Quartz v4 API and configuration patterns
   - Best practices for Obsidian markdown parsing
   - GitHub Pages deployment automation
   - Performance optimization for large vaults

2. **Generate and dispatch research agents**:
   ```
   Task: "Research Quartz v4 configuration and plugin system for Obsidian integration"
   Task: "Find best practices for preserving wiki-links in static site generation"
   Task: "Research GitHub Actions workflow for automated Quartz deployment"
   Task: "Find performance patterns for large markdown collections processing"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all technical decisions documented

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Document simple workflow** → `data-model.md`:
   - Input: Markdown files with frontmatter in `~/notes/3-Resources/`
   - Configuration: Quartz config in `quartz.config.ts`
   - Output: Static HTML site in `public/` folder ready for GitHub Pages
   - Reality check: We're using Quartz, not building complex data models

2. **Create simple validation** from functional requirements:
   - Build process validation: markdown → HTML conversion works
   - Publication control: `publish: false` excludes files
   - Link resolution: `[[wiki-links]]` become HTML links
   - Output to `/contracts/` directory as shell script

3. **Implement contract validation** from requirements:
   - Simple bash script testing core functionality
   - Real Quartz build process with actual files
   - No complex test frameworks needed

4. **Create automated validation script** from user stories:
   - Build success: `npx quartz build` exits with code 0
   - HTML output: Check specific HTML files exist (e.g., `public/resources/til/spec-kit/index.html`)
   - Link conversion: `grep` for correct `href` attributes in generated HTML
   - Publication filtering: Verify unpublished notes don't generate HTML files
   - Asset handling: Confirm referenced files are copied to output directory
   - Script-based: All checks automated in `build-validation.sh`

5. **Update agent file incrementally** (O(1) operation):
   - Run for Claude Code context
   - Add Quartz v4, Node.js 22, static site generation context
   - Preserve existing manual additions
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output CLAUDE.md to repository root

**Output**: data-model.md, /contracts/build-validation.sh, quickstart.md, CLAUDE.md

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Generate tasks from simple workflow (setup, configuration, validation)
- Setup tasks: Initialize Quartz, configure for Obsidian vault
- Configuration tasks: Set up publication control, GitHub Pages deployment  
- Validation tasks: Execute automated `build-validation.sh` script to verify HTML output
- No custom libraries needed - just Quartz configuration and workflow

**Ordering Strategy**:
- Setup first: Get Quartz working with basic configuration
- Content linking: Set up symlink to Obsidian vault
- Build validation: Run automated script to verify HTML generation and link conversion
- Deployment: GitHub Pages workflow setup

**Estimated Output**: 8-12 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, build validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

No constitutional violations identified. The design follows:
- Single project structure (using Quartz as-is)
- Framework-first approach (no custom libraries)
- Simple validation methodology (bash scripts)
- Framework direct usage (Quartz v4)
- Simple file-based processing (markdown → HTML)

## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS  
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented (none identified)

---
*Based on Constitution v2.1.1 - See `/memory/constitution.md`*
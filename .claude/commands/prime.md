Display the complete project context and technical overview.

This command provides comprehensive project information including:
- Project overview and current status
- Technology stack and architecture decisions  
- Key components and data entities
- Development workflow and testing strategy
- Configuration management
- Performance requirements
- Deployment pipeline
- **Implementation logging requirements**

---

# Claude Code Context: Obsidian Notes Microsite

## Project Overview
Static site generator project that converts Obsidian markdown notes into a website using Quartz v4 framework. Preserves wiki-style links, supports frontmatter publication control, and deploys to GitHub Pages.


## Technology Stack
- **Framework**: Quartz v4 (TypeScript-based static site generator)
- **Runtime**: Node.js 22.x with npm
- **Build**: esbuild (bundled with Quartz)
- **Deployment**: GitHub Actions → GitHub Pages
- **Testing**: Contract-first with real file system validation

## Architecture Decisions
- **Library-first approach**: markdown-processor, link-resolver, site-builder libraries
- **Direct framework usage**: Quartz v4 APIs without wrapper abstractions
- **File-based processing**: Symbolic links to Obsidian vault resources
- **Single project structure**: All libraries in unified src/ hierarchy

## Key Components

### Core Libraries
1. **markdown-processor**: Parses Obsidian markdown, extracts frontmatter, processes wiki links
2. **media-handler**: Manages assets, optimization, web-compatible processing
3. **site-builder**: Generates navigation, search index, static structure

### Data Entities
- **MarkdownNote**: Core entity with content, frontmatter, links, media references
- **WikiLink**: Link resolution with source/target tracking and broken link detection
- **MediaAsset**: Asset management with web optimization and path resolution
- **SiteStructure**: Navigation hierarchy and search indexing

## Development Workflow
- **Constitution Compliance**: Follows Articles I-IV (KISS, Text-Based, Content-First, Test-First)
- **TDD Required**: Contract tests → Integration tests → Unit tests → Implementation
- **Real dependencies**: Actual file system, real Quartz build process
- **Build validation**: Full vault processing with link resolution verification

## Configuration Management

### Quartz Configuration
```typescript
// Key settings in quartz.config.ts
enableSPA: true           // Single page application
enablePopovers: true      // Link previews
ObsidianFlavoredMarkdown: {
  wikilinks: true,        // [[]] link processing
  blockReferences: true,  // ^block-ref support
  tags: true             // #tag processing
}
```

### Publication Rules
```yaml
# Frontmatter controls
published: true/false     # Include in site build
draft: true/false        # Development status
tags: [list]             # Navigation categories
```

## Project Structure
Feature specifications are organized in `specs/` directory with implementation plans, research, data models, and validation contracts. Tests follow TDD principles with contract, integration, and unit test layers.

## Performance Requirements
- **Build Time**: <30s for typical vault (100-1000 notes)
- **Link Resolution**: Real-time broken link detection
- **Asset Processing**: Automatic optimization for web delivery
- **Search**: Client-side full-text search with instant results

## Deployment Pipeline
```yaml
# GitHub Actions workflow
- Node.js 22 with npm caching
- npm ci --prefer-offline --no-audit
- npx quartz build
- Deploy to GitHub Pages
```

## Testing Strategy
1. **Contract Tests**: Build pipeline input/output validation
2. **Integration Tests**: End-to-end vault processing
3. **Unit Tests**: Library component validation
4. **Performance Tests**: Build time and output validation

## Common Patterns
- **Error Handling**: Graceful failures with detailed error context
- **Logging**: Structured logging for build progress and issue tracking
- **Validation**: Build process validation with real Quartz workflow testing



## Implementation Logging Requirements

**CRITICAL**: When working on phase tasks, you MUST update implementation logs in real-time:

1. **Update immediately after each task** - Don't wait for user reminders
2. **Document all issues encountered** - Problems, root causes, solutions, pivots
3. **Record spec corrections** - Any fixes to documentation or specifications
4. **Log architectural decisions** - Reasoning behind technical choices

**Location**: Each phase file has a "📝 Phase X Implementation Log" section at the bottom.

## Commit Message Requirements

**CRITICAL**: Use the `/commit` command for all commits to follow the project template:

1. **Concise summary** - Brief title for git log readability
2. **Single-line "What"** - High-level change description (no details)
3. **Business rationale "Why"** - 1-2 sentences explaining the purpose
4. **Manual testing "How to Test"** - Real user validation steps

**Template location**: `.specify/templates/commit-template.md`

## Constitutional Principles
- **Article I - KISS**: Simple, minimal maintenance solutions using open-source tools
- **Article II - Text-Based**: Plain text formats (markdown) for future-proofing
- **Article III - Content-First**: Notes and content prioritized over UI/UX
- **Article IV - Test-First**: Contract → Integration → Unit → Implementation order
- **Article V - Excellent Record-Keeping**: Real-time implementation logs and structured commit messages


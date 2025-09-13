# Phase 0: Research & Technology Decisions

## Quartz v4 Configuration and Plugin System

### Decision: Use Quartz v4 with ObsidianFlavoredMarkdown Plugin

**Rationale**: 
- Quartz v4 provides native Obsidian compatibility with wikilinks, backlinks, and frontmatter support
- ObsidianFlavoredMarkdown plugin handles all Obsidian-specific syntax automatically
- TypeScript-based architecture offers better performance and maintainability than Hugo-based alternatives
- Built-in features include full-text search, graph view, popover previews, and modern SPA capabilities

**Alternatives considered**:
- Hugo with custom themes: More complex setup, limited Obsidian compatibility
- Jekyll: Ruby-based, slower build times, manual link resolution required  
- MkDocs with plugins: Python dependency, less Obsidian-native features
- Custom Node.js solution: Higher development overhead, reinventing existing solutions

**Key Configuration**:
```typescript
// quartz.config.ts essential settings
enableSPA: true,           // Single Page Application for performance
enablePopovers: true,      // Link preview functionality  
plugins: {
  transformers: [
    Plugin.ObsidianFlavoredMarkdown({
      wikilinks: true,       // Convert [[links]] to regular links
      comments: true,        // Parse %% comment blocks
      blockReferences: true, // Handle ^block-refs
      tags: true            // Process #tags
    })
  ]
}
```

## Node.js Environment and Dependencies

### Decision: Node.js 22.x with npm ci for builds

**Rationale**:
- Quartz v4 requires Node.js 22+ for optimal performance and GitHub Actions compatibility
- npm ci provides faster, more reliable installs in CI/CD environments
- esbuild bundling (included with Quartz) offers superior build performance
- TypeScript compilation happens automatically without additional configuration

**Alternatives considered**:
- Node.js 18 LTS: Supported but not optimal for Quartz v4 features
- Yarn: Additional complexity without significant benefits for this use case
- pnpm: Faster but less GitHub Actions integration, potential compatibility issues

**Build Pipeline**:
```bash
# Performance-optimized build sequence
npm ci --prefer-offline --no-audit  # Faster dependency installation
npx quartz build                     # Generate static site
npx quartz build --serve            # Development with hot-reload
```

## Wiki-Links and Backlink Preservation

### Decision: Leverage Built-in Quartz Link Resolution

**Rationale**:
- Quartz automatically processes [[wikilinks]] into proper HTML navigation
- Backlinks are generated automatically without additional configuration
- Link validation happens during build process with clear error reporting
- Maintains Obsidian's folder structure and file organization

**Alternatives considered**:
- Custom link parser: Significant development overhead, error-prone
- Obsidian Publish: Paid service, less customization control
- Manual link conversion: Not scalable, maintenance burden

**Link Processing Features**:
- Automatic broken link detection and warnings
- Case-insensitive link matching
- Support for link aliases: `[[file|display text]]`
- Folder-based link resolution with path preservation

## GitHub Actions Deployment Optimization

### Decision: Modern GitHub Actions with Caching Strategy

**Rationale**:
- GitHub Pages integration provides free hosting with custom domains
- Node.js 22 support ensures compatibility with Quartz requirements
- Automated deployment on content changes reduces manual overhead
- Built-in caching significantly improves build performance

**Alternatives considered**:
- Netlify/Vercel: Additional service dependency, similar features available on GitHub
- Self-hosted solutions: Higher maintenance, security concerns
- Manual deployment: Not scalable, error-prone

**Workflow Optimization**:
```yaml
# .github/workflows/deploy.yml key optimizations
- uses: actions/setup-node@v4
  with:
    node-version: 22
    cache: 'npm'              # Automatic npm caching
- run: npm ci --prefer-offline --no-audit
- uses: actions/upload-pages-artifact@v3  # Modern artifact handling
```

## Performance Optimization Strategies

### Decision: SPA Mode with Client-Side Search

**Rationale**:
- Single Page Application mode provides instant navigation between notes
- Client-side full-text search eliminates server dependencies
- Popover previews reduce page load requirements
- CDN caching for static assets improves global performance

**Alternatives considered**:
- Server-side rendering: Higher complexity, hosting requirements
- Traditional multi-page: Slower navigation, more HTTP requests
- External search service: Additional complexity, potential costs

**Performance Features**:
- Hot-reload during development for faster iteration
- Incremental builds for content changes only
- Optimized asset bundling with esbuild
- Responsive design with mobile-first approach

## Publication Control Implementation

### Decision: Frontmatter-based Publication Rules

**Rationale**:
- YAML frontmatter aligns with existing Obsidian workflows
- Granular control over individual note publication
- Build-time filtering prevents accidental private content exposure
- Easy to understand and maintain

**Alternatives considered**:
- Folder-based publishing: Less flexible, requires file reorganization
- Tag-based filtering: More complex logic, potential for errors
- Separate publication vault: Content duplication issues

**Frontmatter Configuration**:
```yaml
---
publish: true      # Include in site build
draft: false        # Ready for publication
tags: [example]     # Category organization
title: "Custom Title"  # Override filename
---
```

## Media Asset Handling

### Decision: Symbolic Links with Automatic Asset Processing

**Rationale**:
- Symbolic links allow referencing vault assets without duplication
- Quartz automatically processes and optimizes images during build
- Maintains original file organization and references
- Support for various media types (images, PDFs, videos)

**Alternatives considered**:
- Asset copying: Storage duplication, sync complexity
- External asset hosting: Additional service dependency
- Inline Base64 encoding: Large file size impact

**Asset Processing**:
- Automatic image optimization and responsive sizing
- Support for relative and absolute path references  
- Missing asset detection with build warnings
- Copy protection for referenced files outside vault

## Testing Strategy Approach

### Decision: Contract-First Testing with Real File System

**Rationale**:
- Contract tests validate build pipeline behavior
- Integration tests use actual markdown files and Quartz build process
- Real file system testing catches permission and path issues
- End-to-end validation ensures published site functionality

**Alternatives considered**:
- Mock-based testing: Misses real-world file system issues
- Unit-only testing: Insufficient for static site generation validation
- Manual testing: Not scalable, error-prone

**Test Categories**:
1. Contract tests: Build pipeline input/output validation
2. Integration tests: Full vault processing workflows  
3. End-to-end tests: Generated site navigation and functionality
4. Performance tests: Build time and output size validation

## Summary

The research confirms that Quartz v4 with Node.js 22 provides the optimal foundation for converting Obsidian vaults to static websites. The technology stack leverages modern web development practices while maintaining simplicity and avoiding over-engineering. All technical requirements can be satisfied with built-in Quartz features, minimizing custom code development and maintenance overhead.
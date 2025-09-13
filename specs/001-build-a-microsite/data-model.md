# Phase 1: Data Model - Simplified for Quartz Usage

## Reality Check
We're not building a complex data system - we're using Quartz to convert markdown files to HTML. The "entities" are just file formats that Quartz already handles.

## What We Actually Have

### Input: Markdown Files
Standard markdown files with optional frontmatter in `~/notes/3-Resources/`:

```markdown
---
title: "My Note" 
publish: true
tags: [example, demo]
---

# Content

This is a [[wiki link]] to another note.
```

### Configuration: Quartz Config
Main configuration in `quartz.config.ts`:

```typescript
const config: QuartzConfig = {
  configuration: {
    pageTitle: "My Notes",
    baseUrl: "denislaliberte.github.io/microsite",
    analytics: { provider: "none" }
  }
}
```

### Output: Static HTML Site
Generated in `public/` folder, ready for GitHub Pages.

## What Quartz Handles Automatically

- **Markdown Processing**: Converts `.md` files to HTML pages
- **Wiki Links**: `[[note]]` becomes clickable links
- **Publication Control**: `publish: false` excludes from site
- **Navigation**: Generates menus from folder structure
- **Search**: Creates client-side search index
- **Themes**: Default styling and responsive design

## Our Simple Workflow

1. **Content**: Write markdown in `~/notes/3-Resources/`
2. **Link**: Symlink to `content/resources/`
3. **Build**: `npx quartz build` generates `public/`
4. **Deploy**: Commit and push `public/` to GitHub

No complex data models, no persistence, no custom processing. Just Quartz doing what it does best.
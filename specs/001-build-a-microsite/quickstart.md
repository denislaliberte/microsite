# Quickstart Guide: Obsidian to Quartz Microsite

This guide validates the complete workflow from Obsidian vault to published static site using Quartz v4.

## Prerequisites

**Required Software:**
- Node.js 22.x or higher
- npm 10.9.2 or higher  
- Git (for version control and deployment)
- Access to GitHub account (for Pages hosting)

**Validation Commands:**
```bash
node --version    # Should show v22.x.x
npm --version     # Should show 10.9.x
git --version     # Any recent version
```

## Quick Setup (5 minutes)

### 1. Initialize Quartz in Current Repo
```bash
# Verify you're in your microsite directory
pwd  # Should show: /Users/denis/microsite

# Clone Quartz to temporary directory
git clone https://github.com/jackyzha0/quartz.git /tmp/quartz-temp

# Copy Quartz files to current directory (preserve existing files)
cp -r /tmp/quartz-temp/* .
cp /tmp/quartz-temp/.* . 2>/dev/null || true  # Copy hidden files, ignore errors

# Clean up temporary directory
rm -rf /tmp/quartz-temp

# Install dependencies
npm ci

# Verify installation
npx quartz --version
```

### 2. Configure for Obsidian Vault
```bash
# Edit quartz.config.ts
cat > quartz.config.ts << 'EOF'
import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

const config: QuartzConfig = {
  configuration: {
    pageTitle: "My Obsidian Notes",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "none"
    },
    locale: "en-US",
    baseUrl: "denislaliberte.github.io/microsite",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "created",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        header: "Schibsted Grotesk",
        body: "Source Sans Pro",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#faf8f8",
          lightgray: "#e5e5e5",
          gray: "#b8b8b8",
          darkgray: "#4e4e4e",
          dark: "#2b2b2b",
          secondary: "#284b63",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
        darkMode: {
          light: "#161618",
          lightgray: "#393639",
          gray: "#646464",
          darkgray: "#d4d4d4",
          dark: "#ebebec",
          secondary: "#7b97aa",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({
        wikilinks: true,
        comments: true,
        blockReferences: true,
        tags: true
      }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}

export default config
EOF
```

### 3. Link Obsidian Vault
```bash
# Remove default content
rm -rf content/*

# Create symbolic link to only your Resources folder
ln -s ~/notes/3-Resources content/resources

# Or copy files if symlink not preferred
# cp -r ~/notes/3-Resources/* content/
```

## Testing Workflow

### 1. Validate Build Process
```bash
# Build the site
npx quartz build

# Expected output:
# ✓ Parsed [X] markdown files
# ✓ Generated [X] pages  
# ✓ Processed [X] assets
# ✓ Built in [X]ms
```

### 2. Local Development Server
```bash
# Start development server with hot reload
npx quartz build --serve

# Site available at: http://localhost:8080
# Verify:
# - Navigation menu appears
# - Wiki links work correctly
# - Search functionality active
# - Graph view displays
```

### 3. Content Validation Tests

**Test Note Creation:**
```bash
# Create TIL note about Spec Kit (will be published)
mkdir -p ~/notes/3-Resources/til
cat > ~/notes/3-Resources/til/2025-09-12-spec-kit.md << 'EOF'
---
title: "TIL: GitHub Spec Kit for Spec-Driven Development"
publish: true
date: 2025-09-12
tags: [til, tools, development]
---

# TIL: GitHub Spec Kit

Today I learned about GitHub's [Spec Kit](https://github.com/github/spec-kit) - structured prompts that guide LLMs to build the right thing instead of trial-and-error development.

## Key Workflow
1. **`/specify`** - Define requirements clearly upfront
2. **`/plan`** - Generate technical implementation plan  
3. **`/tasks`** - Break down into actionable tasks
4. **Implement** - Build from structured guidance

## Why It's Useful
- No more shooting in the dark with vague prompts
- Structures the conversation to keep development on track
- Works with Claude Code, GitHub Copilot, Gemini CLI
- Reduces back-and-forth iterations

## My Use Case
Used this to plan a [[2025-09-12-quartz-static-sites|Quartz microsite]] - simple project but good way to learn how Spec Kit works in practice.

Basically templates for better LLM conversations about building software.
EOF
```

**Test Link Resolution & Publishing Control:**
```bash
# Create published TIL about Quartz (with link to Spec Kit note)
cat > ~/notes/3-Resources/til/2025-09-12-quartz-static-sites.md << 'EOF'
---
title: "TIL: Quartz for Publishing Obsidian Notes"
publish: true
date: 2025-09-12
tags: [til, quartz, obsidian, publishing]
---

# TIL: Quartz for Publishing Obsidian Notes

Today I learned about [Quartz](https://quartz.jzhao.xyz/) - a static site generator that converts Obsidian markdown files into websites.

## Key Features
- Preserves wiki-style `[[links]]` between notes
- Converts Obsidian syntax to web-friendly HTML
- Generates search, graph view, and navigation
- Supports frontmatter for publication control

## Publishing Control
Use `publish: true/false` in frontmatter to control what gets built into the site.

## My Use Case
Used [[2025-09-12-spec-kit|Spec Kit]] workflow to plan this microsite setup - structured approach worked great for complex project planning.

Static sites are perfect for "publish and forget" knowledge sharing.
EOF

# Create unpublished TIL about publishing workflow (should not appear in site)
cat > ~/notes/3-Resources/til/2025-09-12-quartz-publishing-workflow.md << 'EOF'
---
title: "TIL: Quartz Publishing Workflow Details"
publish: false
date: 2025-09-12
tags: [til, workflow, private]
---

# TIL: Quartz Publishing Workflow

This note tests the `publish: false` functionality - it should NOT appear in the generated website.

## Internal Workflow Notes
- Local build: `npx quartz build`
- Manual deployment: commit public/ folder
- GitHub Pages: serves from /public folder

## Private Observations
- Build times are fast (<10s for small vaults)
- Symlinks work well for keeping content separate
- Good for curated knowledge sharing while keeping private notes private

This content should remain private and not be published to the website.
EOF
```

**Test Asset Handling:**
```bash
# Create assets directory and test image
mkdir -p content/assets
echo "Test image content" > content/assets/image.png
```

### 4. Build Validation
```bash
# Clean build
rm -rf public/
npx quartz build

# Verify generated structure
ls -la public/
# Expected:
# - index.html (site homepage)
# - test-note/index.html
# - another-note/index.html  
# - assets/ (copied media files)
# - static/ (CSS, JS, search index)
```

## Manual GitHub Pages Deployment

### 1. Build and Deploy Process
```bash
# Build the site locally
npx quartz build

# Add all files (source + built public/ folder)
git add .
git commit -m "Update site with latest content"
git push origin main
```

### 2. Repository Setup (First Time Only)
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial Quartz setup with Obsidian notes"

# Create GitHub repository and push
git remote add origin https://github.com/denislaliberte/microsite.git  
git branch -M main
git push -u origin main
```

### 2. GitHub Actions Workflow
```bash
# Create deployment workflow
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy Quartz site to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'npm'
      
      - name: Install Dependencies
        run: npm ci
        
      - name: Build Quartz site
        run: npx quartz build
        
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-22.04
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

# Commit workflow
git add .github/
git commit -m "Add GitHub Pages deployment workflow"
git push
```

### 3. Configure GitHub Pages
1. Go to your repository Settings → Pages
2. Set Source to "Deploy from a branch"
3. Select branch: `main` 
4. Select folder: `/public`
5. Save configuration

Your site will be available at `https://denislaliberte.github.io/microsite/`

**Important**: Always commit both your markdown source files AND the built `public/` folder to the repository.

## Verification Checklist

**Local Build Success:**
- [ ] `npx quartz build` completes without errors
- [ ] Generated `public/` directory contains HTML files
- [ ] Wiki links convert to working HTML links
- [ ] Images and assets copy correctly
- [ ] Search functionality works in browser
- [ ] Navigation menu displays site structure

**Content Processing:**
- [ ] Frontmatter `publish: false` excludes notes
- [ ] Tags appear in navigation and tag pages
- [ ] Backlinks generate automatically
- [ ] Table of contents appears for long notes
- [ ] Code syntax highlighting works

**GitHub Pages Deployment:**
- [ ] Repository has GitHub Actions enabled
- [ ] Deploy workflow runs successfully
- [ ] Site accessible at `https://denislaliberte.github.io/microsite/`
- [ ] All pages load correctly
- [ ] Search and navigation work on deployed site

## Common Issues & Solutions

**Build Errors:**
```bash
# Permission errors with symlinks
sudo chmod -R 755 content/

# Missing dependencies
npm install --legacy-peer-deps

# Node version issues
nvm use 22
npm ci
```

**Link Resolution Problems:**
- Ensure file names match exactly (case-sensitive)
- Check for special characters in file names
- Verify vault structure matches content directory

**Deployment Failures:**
- Check GitHub repository permissions
- Verify Node.js 22 in workflow file
- Ensure baseUrl matches repository name in config

## Next Steps

After completing this quickstart:

1. **Customize appearance**: Edit theme colors and fonts in config
2. **Optimize performance**: Enable CDN caching and compression

**Success Criteria:**
- Local build processes Obsidian vault correctly  
- Generated site preserves all wiki links and formatting
- GitHub Pages deployment works automatically
- Published site matches local development version

This quickstart validates the complete technical workflow and serves as the foundation for implementing the full microsite solution.
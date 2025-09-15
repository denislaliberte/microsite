# Microsite

[![Deploy to GitHub Pages](https://github.com/denislaliberte/microsite/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/denislaliberte/microsite/actions/workflows/deploy-pages.yml)

A personal knowledge management site built with [Quartz v4](https://quartz.jzhao.xyz/) to share public resources, TIL (Today I Learned) notes, and project documentation.

**🌐 Live Site**: https://denislaliberte.github.io/microsite/

## Overview

This microsite serves as a digital garden for sharing:
- **TIL Notes**: Today I Learned entries on various technical topics
- **How-to Guides**: Technical documentation and guides
- **Project Documentation**: Development notes and specifications
- **Public Resources**: Curated content for public consumption

The site is built with Quartz v4, which transforms Obsidian markdown notes into a beautiful, searchable static website with wiki-style linking and modern web features.

## Architecture

```
microsite/
├── content/                 # Source markdown files
│   ├── til/                # Today I Learned notes
│   ├── how-to/             # Technical guides
│   └── specs/              # Project specifications
├── public/                 # Generated static site (auto-built)
├── .github/workflows/      # GitHub Actions automation
├── quartz.config.ts        # Site configuration
└── README.md              # This file
```

## Quick Start

### Prerequisites

- **[Quartz v4](https://quartz.jzhao.xyz/)** (static site generator)
- **Node.js 18+** (required by Quartz)
- **npm** (comes with Node.js)
- **Git**

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/denislaliberte/microsite.git
   cd microsite
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Build the site**
   ```bash
   npx quartz build
   ```

4. **Preview locally** (optional)
   ```bash
   # Option 1: Use built-in bin script (recommended)
   ./bin/server 8080

   # Option 2: Manual server
   cd public && python3 -m http.server 8080
   # Open http://localhost:8080 in your browser
   ```

## Quick Workflow

1. **Create content**: Add `.md` files with `publish: true` frontmatter
2. **Build**: `./bin/build`
3. **Deploy**: `git add . && git commit -m "Update" && git push origin v4`

## Site Configuration

- ✅ **CDN Caching**: Enabled for static assets
- ✅ **SPA Mode**: Fast client-side navigation
- ✅ **Search**: Full-text search with content indexing
- ✅ **Dark/Light Mode**: Theme switching
- ✅ **Wiki Links**: Bidirectional linking between notes

## Scripts & Commands

The microsite includes convenient scripts in the `bin/` directory:

### Development Scripts

```bash
# Available scripts
./bin/build                 # Build site
./bin/build --serve         # Build and preview
./bin/server 8080          # Preview on port 8080
./bin/test                 # Run tests
```


## Deployment

Automated via GitHub Actions on push to `v4` branch (~16 seconds).

**Live Site**: https://denislaliberte.github.io/microsite/

## Dependencies

- **[Quartz v4](https://quartz.jzhao.xyz/)**: Static site generator for Obsidian notes
- **Node.js 18+**: JavaScript runtime required by Quartz

## Resources

- **Quartz Documentation**: https://quartz.jzhao.xyz/
- **Build Logs**: https://github.com/denislaliberte/microsite/actions
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

- **Node.js 18+** (recommended: Node.js 22)
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
   cd public && python3 -m http.server 8080
   # Open http://localhost:8080 in your browser
   ```

## Development Workflow

### Adding New Content

1. **Create a new markdown file** in the appropriate directory:
   ```bash
   # For TIL notes
   touch content/til/my-new-learning.md

   # For how-to guides
   touch content/how-to/my-guide.md
   ```

2. **Add frontmatter** to your markdown file:
   ```markdown
   ---
   title: "My New Learning"
   description: "What I learned about X today"
   tags: [learning, technology]
   publish: true
   ---

   # My New Learning

   Content goes here...
   ```

3. **Build and test locally**:
   ```bash
   npx quartz build
   cd public && python3 -m http.server 8080
   ```

4. **Commit and push** (triggers automatic deployment):
   ```bash
   git add .
   git commit -m "Add new TIL: My New Learning"
   git push origin v4
   ```

5. **Monitor deployment** at: https://github.com/denislaliberte/microsite/actions

### Content Guidelines

#### Frontmatter Requirements
- **`publish: true`**: Required for content to appear on the site
- **`title`**: Page title (appears in navigation and search)
- **`description`**: Brief description for SEO and previews
- **`tags`**: Array of relevant tags for categorization

#### Linking Between Notes
Use Quartz's wiki-style linking:
```markdown
[[target-note|Display Text]]
[[target-note]]  # Uses note title as display text
```

#### Assets and Media
Place assets in the same directory as your markdown:
```
content/til/
├── my-note.md
└── assets/
    ├── image.png
    └── document.pdf
```

Reference them in markdown:
```markdown
![Alt text](assets/image.png)
[Download PDF](assets/document.pdf)
```

## Site Configuration

### Key Configuration Files

#### `quartz.config.ts`
Main site configuration:
- **`baseUrl`**: Set to `"denislaliberte.github.io/microsite"`
- **`pageTitle`**: Site title in navigation
- **`enableSPA`**: Single-page application mode for fast navigation
- **`cdnCaching`**: CDN optimization for performance
- **`ignorePatterns`**: Files/folders to exclude from build

#### Content Filtering
The site uses `ExplicitPublish` filtering:
- Only notes with `publish: true` are included
- Private content is automatically excluded
- Unpublished drafts remain local-only

### Performance Features

- ✅ **CDN Caching**: Enabled for static assets
- ✅ **SPA Mode**: Fast client-side navigation
- ✅ **Search**: Full-text search with content indexing
- ✅ **Mobile Responsive**: Works on all device sizes
- ✅ **Dark/Light Mode**: Theme switching
- ✅ **Wiki Links**: Bidirectional linking between notes

## Deployment

### Automated Deployment (Current Setup)

The site uses **GitHub Actions** for automated deployment:

1. **Trigger**: Push to `v4` branch
2. **Build**: GitHub Actions runs `npx quartz build`
3. **Deploy**: Built site deployed to GitHub Pages
4. **Live**: Updates appear at https://denislaliberte.github.io/microsite/

**Deployment time**: ~16 seconds

### Manual Deployment (Backup)

If automated deployment fails:

```bash
# Build locally
npx quartz build

# Commit built files
git add .
git commit -m "Manual deployment"

# Push to trigger deployment
git push origin v4
```

### Monitoring Deployment

- **Build Status**: Check the badge at the top of this README
- **GitHub Actions**: https://github.com/denislaliberte/microsite/actions
- **Live Site**: https://denislaliberte.github.io/microsite/

## Dependencies

### Core Dependencies

- **[Quartz v4](https://quartz.jzhao.xyz/)**: Static site generator for Obsidian notes
- **Node.js 18+**: JavaScript runtime (recommended: 22+)
- **TypeScript**: Type checking and compilation
- **esbuild**: Fast JavaScript bundler
- **remark/rehype**: Markdown processing pipeline

### Key Features Provided by Dependencies

- **Markdown Processing**: Full CommonMark + GitHub Flavored Markdown
- **Obsidian Compatibility**: Wiki links, backlinks, graph view
- **Search**: Client-side full-text search
- **Syntax Highlighting**: Code block highlighting
- **Math Rendering**: LaTeX math support via KaTeX
- **Image Processing**: Automatic optimization and WebP generation

### Development Dependencies

- **TypeScript**: Type definitions and checking
- **@types/node**: Node.js type definitions
- **esbuild**: Fast bundling for development

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clear cache and rebuild
rm -rf .quartz-cache/
npm install
npx quartz build
```

#### Content Not Appearing
- Verify `publish: true` in frontmatter
- Check file extension is `.md`
- Ensure no syntax errors in frontmatter YAML

#### Deployment Issues
- Check GitHub Actions logs: https://github.com/denislaliberte/microsite/actions
- Verify repository permissions
- Ensure `v4` branch is up to date

#### Local Development Issues
```bash
# Reinstall dependencies
rm -rf node_modules/ package-lock.json
npm install

# Check Node.js version
node --version  # Should be 18+
```

### Performance Issues

1. **Large build times**: Check for large images or files
2. **Slow navigation**: Verify SPA mode is enabled in config
3. **Search not working**: Ensure content index is generated

## Maintenance

### Regular Tasks

1. **Update dependencies**:
   ```bash
   npm update
   git add package*.json
   git commit -m "Update dependencies"
   git push origin v4
   ```

2. **Monitor site performance**:
   - Check GitHub Actions for build health
   - Test site speed with browser dev tools
   - Verify search functionality

3. **Content review**:
   - Update outdated TIL notes
   - Add new tags for better organization
   - Check for broken internal links

### Backup Strategy

- **Source content**: Version controlled in Git
- **Built site**: Automatically deployed and hosted by GitHub Pages
- **Configuration**: Stored in repository

## Resources

- **Quartz Documentation**: https://quartz.jzhao.xyz/
- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **Repository Settings**: https://github.com/denislaliberte/microsite/settings
- **Build Logs**: https://github.com/denislaliberte/microsite/actions

## License

This project contains personal notes and content. The Quartz framework is MIT licensed. See individual content for specific licensing.

---

*Last updated: September 2025 - This README serves as the complete maintenance guide for the microsite.*
---
title: "GitHub Pages Configuration Guide"
description: "Complete guide to GitHub Pages deployment options and configuration, derived from official GitHub documentation"
tags: [github, deployment, hosting, pages]
publish: true
---

# GitHub Pages Configuration Guide

> **Source**: This guide is derived from the [official GitHub Pages documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)

## Overview

GitHub Pages hosts static websites from your repository using two deployment methods:

1. **Deploy from Branch**: Simple, limited to root or `/docs` folder
2. **GitHub Actions**: Flexible, custom build processes (recommended)


## Configuration Steps

### Method 1: Traditional Deployment

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click "Settings" tab
   - Scroll to "Pages" section

2. **Configure Source**
   - Source: "Deploy from a branch"
   - Branch: Select your branch (e.g., `main`, `v4`)
   - Folder: Choose `/` (root) or `/docs`
   - Click "Save"

3. **Access Your Site**
   - URL: `https://username.github.io/repository-name/`
   - Build time: Usually 1-5 minutes

### Method 2: GitHub Actions

1. **Enable GitHub Actions**
   - Repository Settings → Pages
   - Source: "GitHub Actions"
   - Use GitHub's suggested workflow templates for your framework


### Manual Deployment

```bash
npx quartz build && cp -r public/* . && git add . && git commit -m "Deploy site" && git push
```



## Resources

- [Official GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions for Pages](https://github.com/marketplace/actions/github-pages-action)
- [Troubleshooting GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/troubleshooting-jekyll-build-errors-for-github-pages-sites)

---

*This guide was created during Phase 4.1 of the microsite deployment process as a reference for GitHub Pages configuration options.*
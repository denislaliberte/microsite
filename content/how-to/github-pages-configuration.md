---
title: "GitHub Pages Configuration Guide"
description: "Complete guide to GitHub Pages deployment options and configuration, derived from official GitHub documentation"
tags: [github, deployment, hosting, pages]
publish: true
---

# GitHub Pages Configuration Guide

> **Source**: This guide is derived from the [official GitHub Pages documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)

## Overview

GitHub Pages allows you to host static websites directly from your GitHub repository. Understanding the configuration options is crucial for successful deployment.

## Deployment Methods

GitHub Pages offers **two primary deployment methods**:

### 1. Deploy from a Branch (Traditional)
- **Best for**: Simple static sites, manual deployment
- **Limitations**: Only supports specific folder structures
- **Configuration**: Repository Settings → Pages → Source → "Deploy from a branch"

### 2. GitHub Actions (Modern - Recommended)
- **Best for**: Custom build processes, automated deployment
- **Flexibility**: Deploy from any folder structure
- **Configuration**: Repository Settings → Pages → Source → "GitHub Actions"

## Source Folder Options

### Traditional Deployment (Deploy from Branch)

When using "Deploy from a branch", you have **only two folder options**:

#### Option 1: Root Directory (`/`)
```
repository/
├── index.html          # Entry point
├── style.css
├── script.js
└── other-files/
```

- **Path**: `/` (root)
- **Use case**: When your built files are in the repository root
- **URL**: `https://username.github.io/repository-name/`

#### Option 2: Docs Folder (`/docs`)
```
repository/
├── README.md
├── src/
└── docs/               # GitHub Pages serves from here
    ├── index.html      # Entry point
    ├── style.css
    └── assets/
```

- **Path**: `/docs`
- **Use case**: Separate documentation or built files
- **URL**: `https://username.github.io/repository-name/`

### GitHub Actions Deployment

With GitHub Actions, you can deploy from **any folder**:

```
repository/
├── src/
├── build/              # Can deploy from here
├── dist/               # Or from here
├── public/             # Or from here
└── my-custom-folder/   # Or any custom folder
```

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
   - GitHub will suggest workflow templates

2. **Create Workflow File**
   ```yaml
   # .github/workflows/deploy.yml
   name: Deploy to GitHub Pages
   on:
     push:
       branches: [ main ]
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Setup Node.js
           uses: actions/setup-node@v4
           with:
             node-version: '18'
         - name: Install dependencies
           run: npm install
         - name: Build
           run: npm run build
         - name: Deploy
           uses: peaceiris/actions-gh-pages@v3
           with:
             github_token: ${{ secrets.GITHUB_TOKEN }}
             publish_dir: ./dist  # Your build folder
   ```

## Common Use Cases

### Static Site Generators

| Generator | Recommended Approach | Folder |
|-----------|---------------------|---------|
| **Quartz** | Manual: Copy `public/` to root | `/` |
| **Jekyll** | Traditional: Built-in support | `/` or `/docs` |
| **Hugo** | GitHub Actions | `./public` |
| **Gatsby** | GitHub Actions | `./public` |
| **Next.js** | GitHub Actions | `./out` |
| **React** | GitHub Actions | `./build` |

### Manual Deployment Workflow

For static site generators like Quartz:

1. **Build Locally**
   ```bash
   npx quartz build
   ```

2. **Copy to Deployable Location**
   ```bash
   # Option A: Copy to root
   cp -r public/* .

   # Option B: Copy to docs
   cp -r public/* docs/
   ```

3. **Commit and Push**
   ```bash
   git add .
   git commit -m "Deploy: Update site"
   git push origin main
   ```

## Troubleshooting

### Common Issues

#### 404 Errors
- **Cause**: Files not in correct folder or path issues
- **Solution**: Verify source folder configuration matches your file structure

#### Build Stuck "Building"
- **Cause**: Large files, configuration issues, or GitHub service issues
- **Solution**: Check build logs, verify file sizes, wait or restart deployment

#### Base URL Issues
- **Cause**: Incorrect `baseUrl` in site configuration
- **Solution**: Set `baseUrl` to `username.github.io/repository-name`

### Verification Checklist

- [ ] Repository is public (or GitHub Pro/Team for private)
- [ ] Source branch exists and contains files
- [ ] `index.html` exists in configured source folder
- [ ] No files exceed GitHub's size limits
- [ ] Base URL configured correctly in site settings

## Best Practices

1. **Use descriptive commit messages** for deployment commits
2. **Test locally** before deploying
3. **Keep build artifacts separate** from source code when possible
4. **Use GitHub Actions** for complex build processes
5. **Monitor build status** in repository Actions tab
6. **Set up custom domain** if needed via CNAME file

## Resources

- [Official GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions for Pages](https://github.com/marketplace/actions/github-pages-action)
- [Troubleshooting GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/troubleshooting-jekyll-build-errors-for-github-pages-sites)

---

*This guide was created during Phase 4.1 of the microsite deployment process as a reference for GitHub Pages configuration options.*
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [Hexo](https://hexo.io/) static site blog using the Icarus theme. Posts are written in Markdown and deployed to GitHub Pages.

## Common Commands

```bash
# Install dependencies
npm install

# Start local development server (default: http://localhost:4000)
npm run server

# Generate static files
npm run build

# Clean generated files and cache
npm run clean

# Deploy to GitHub Pages
npm run deploy
```

## Project Structure

```
blog/
├── _config.yml          # Main Hexo configuration (site settings, deployment)
├── package.json         # NPM scripts and dependencies
├── source/              # Source files for the blog
│   ├── _posts/          # Blog posts in Markdown
│   └── about/           # Static pages
│       └── index.md
├── scaffolds/           # Post templates (draft.md, post.md, page.md)
└── themes/              # Themes directory
    └── icarus/          # Icarus theme (git submodule)
```

## Key Configuration Files

- `_config.yml` - Main Hexo configuration: site title, author, permalink structure, syntax highlighting, pagination, deployment settings
- `package.json` - Dependencies include hexo core, renderers (marked, ejs, stylus), generators, and the Icarus theme

## Writing New Posts

1. Create a new post using the default scaffold:
   ```bash
   hexo new "post-title"
   ```
2. Edit the Markdown file in `source/_posts/`
3. Front matter should include at least `title` and optionally `date`, `categories`, `tags`

## Deployment

The blog deploys to `https://Solwarda.github.io` via SSH to `git@github.com:Solwarda/Solwarda.githubio.git` on the `main` branch.

## Theme

Uses the [Icarus](https://github.com/MoleBox/hexo-theme-icarus) theme configured in `_config.yml`. The theme itself is stored as a git repository within `themes/icarus/`.

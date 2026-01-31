# CLAUDE.md

## Project Overview

Personal blog for https://rupakganguly.com — a Hugo static site deployed to GitHub Pages.

## Tech Stack

- **Hugo** static site generator with the **hyde-hyde** theme (Git submodule)
- **Node.js** for cross-posting scripts (Medium, Steem)
- Output is published via a Git submodule at `public/` pointing to `rupakg.github.io`

## Docker

All commands must be run inside the Docker container. Build the image first:

```
docker build -t blog .
```

## Commands

Prefer using the `/hugo-blog` Claude skill for all executions. The skill wraps each command in Docker automatically.

### Via `/hugo-blog` skill

- `/hugo-blog dev` — Start Hugo dev server at localhost:1313 (includes drafts)
- `/hugo-blog build` — Build the site for production
- `/hugo-blog deploy` — Deploy the built site to GitHub Pages (run `build` first)
- `/hugo-blog new-post <slug>` — Create a new blog post from archetype
- `/hugo-blog new-glossary <slug>` — Create a new glossary entry
- `/hugo-blog crosspost <path>` — Cross-post to Medium (e.g. `/hugo-blog crosspost posts/my-post.md`)
- `/hugo-blog stop` — Stop the running blog container

### Via Docker directly

- `docker run -p 1313:1313 blog` — Start Hugo dev server at localhost:1313 (includes drafts)
- `docker run --rm -v $(pwd)/public:/site/public blog hugo -t hyde-hyde` — Build the site for production
- `bash scripts/deploy.sh` — Deploy the built site to GitHub Pages (run build first)
- `docker run --rm blog hugo new posts/my-post.md` — Create a new blog post from archetype
- `docker run --rm blog hugo new glossary/my-glossary.md` — Create a new glossary entry
- `docker run --rm blog npm run crosspost -- medium --path="posts/my-post.md"` — Cross-post to Medium (add `dry` before `--path` for dry run)
- `docker stop $(docker ps -q --filter ancestor=blog)` — Stop the running blog container

## Content Structure

- `content/posts/` — Blog articles
- `content/glossary/` — Technical glossary entries
- `content/talks/` — Talk pages (metadata in `data/lists/talks.json`)
- `content/webinars/` — Webinar pages (metadata in `data/lists/webinars.json`)
- `content/about/` — About page

## Content Conventions

- Frontmatter is **YAML** with fields: title, description, date, lastmod, keywords, tags, categories, layout, type
- Use `<!--more-->` to mark the summary/read-more cutoff point
- Images go in `static/img/`
- Custom shortcodes: `{{<note>}}`, `{{<warning>}}`, `{{<fig src="" caption="" alt="">}}`, `{{<kbd>}}`, `{{<menu>}}`
- See `archetypes/default.md` and `archetypes/glossary.md` for post templates

## Layout & Templates

- `layouts/_default/baseof.html` — Base page template
- `layouts/partials/` — Reusable components (sidebar, footer, comments, etc.)
- `layouts/shortcodes/` — Custom Hugo shortcodes

## Configuration

- `config.toml` — Hugo site configuration (theme, menus, social links, analytics)
- `.env` — Required for cross-posting (Medium/Steem credentials); see `.env.example`
- `.gitmodules` — Submodules for `public/` (GitHub Pages output) and `themes/hyde-hyde`

## Deployment

The deploy script (`scripts/deploy.sh`) builds the site, commits the `public/` submodule, and pushes to the GitHub Pages repo. No CI/CD pipeline — deployment is manual via `npm run deploy`.

## Testing

No automated tests are configured.

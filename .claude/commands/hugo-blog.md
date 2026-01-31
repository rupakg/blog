---
name: hugo-blog
description: Run blog commands inside the Docker container
allowed-tools: Bash
argument-hint: <dev|build|deploy|new-post|new-glossary|crosspost|stop> [args]
---

Run the requested blog command inside the Docker container. The Docker image must be named `blog`. If unsure whether the image exists, build it first with `docker build -t blog .`.

Based on the first argument in `$ARGUMENTS`, run the appropriate command:

- **dev**: `docker run -p 1313:1313 blog` — Start the Hugo dev server
- **build**: `docker run --rm -v $(pwd)/public:/site/public blog hugo -t hyde-hyde` — Build the site for production
- **deploy**: `bash scripts/deploy.sh` — Deploy the built site to GitHub Pages (run `/hugo-blog build` first)
- **new-post**: `docker run --rm blog hugo new posts/$1.md` — Create a new blog post (second argument is the post slug)
- **new-glossary**: `docker run --rm blog hugo new glossary/$1.md` — Create a new glossary entry (second argument is the glossary slug)
- **crosspost**: `docker run --rm blog npm run crosspost -- medium --path="$1"` — Cross-post to Medium (second argument is the content path, e.g. `posts/my-post.md`)
- **stop**: `docker stop $(docker ps -q --filter ancestor=blog)` — Stop the running blog container

If no arguments are provided, list the available subcommands.

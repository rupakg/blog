# rupakganguly.com

Source for site and blog, based on Hugo.

## Get Latest

```
git pull --recurse-submodules
```

This will get the latest code for this repo and all its submodules, i.e. our [public](https://github.com/rupakg/rupakg.github.io) folder.

Note: After moving to a new machine, and to update the submodules run the following:

```
git submodule update --init --recursive --remote
```

This command initializes any uninitialized submodules (--init), updates any nested submodules (--recursive), and fetches the latest from the remote branch of the submodule (--remote).

## Create Posts

```
$ hugo new posts/hello-word.md
```

**Note**: Add any static files i.e. html, css, js, images etc. to the static folder. These files will be copied 'as-is' to the destination folder.

## Create Glossary Posts

```
$ hugo new glossary/my-glossary.md
```

## Test

```
$ npm run dev
```

## Commit

Commit the post(s).

## Build & Deploy

```
$ npm run build
$ npm run deploy
```

This will generate the static pages, copy them to the `public` folder and deploy it to `rupakg.github.io` repo. It will then add the changes in the `public` folder into a commit, and then push to the master branch.

## Run with Docker

Build the Docker image:

```
$ docker build -t blog .
```

Run the container:

```
$ docker run -p 1313:1313 blog
```

The site will be available at `http://localhost:1313/`.

To build the site for production inside the container:

```
$ docker run --rm -v $(pwd)/public:/site/public blog hugo -t hyde-hyde
```

## Run with Blog Skill Commands

The `/hugo-blog` Claude skill wraps all common operations in Docker automatically. Use it inside Claude Code instead of running Docker commands manually.

### Start the dev server

```
/hugo-blog dev
```

The site will be available at `http://localhost:1313/`. Local `content/` and `static/` directories are mounted so edits live-reload without rebuilding the image.

### Stop the dev server

```
/hugo-blog stop
```

### Create a new post

```
/hugo-blog new-post my-post-slug
```

Creates `content/posts/my-post-slug.md` from the default archetype.

### Create a new glossary entry

```
/hugo-blog new-glossary my-glossary-slug
```

### Build for production

```
/hugo-blog build
```

Runs `hugo -t hyde-hyde` inside Docker and writes output to `public/`.

### Deploy to GitHub Pages

```
/hugo-blog build
/hugo-blog deploy
```

The deploy script commits and pushes the `public/` submodule to `rupakg.github.io`. Because `public/` uses a detached HEAD, the push targets `HEAD:master` explicitly:

```
cd public
git add -A
git commit -m "Rebuilding the site $(date)"
git push origin HEAD:master
```

### Cross-post to Medium

```
/hugo-blog crosspost posts/my-post.md
```

### Notes

- **Image files**: Always verify that image files saved as `.png` are actually PNG data (`file image.png`). JPEG data with a `.png` extension will appear broken in the browser. Rename to `.jpg` and update the markdown reference if needed.
- **public/ submodule**: The `public/` directory is a Git submodule pointing to `rupakg.github.io`. After building, any untracked or modified files there must be committed and pushed separately from the main blog repo.

## Resources

- [Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
- [Custom domain for your GitHub Pages site](https://help.github.com/en/articles/adding-or-removing-a-custom-domain-for-your-github-pages-site)
- [Securing your GitHub Pages site with HTTPS](https://help.github.com/en/articles/securing-your-github-pages-site-with-https)

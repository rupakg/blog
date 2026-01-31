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

## Resources

- [Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
- [Custom domain for your GitHub Pages site](https://help.github.com/en/articles/adding-or-removing-a-custom-domain-for-your-github-pages-site)
- [Securing your GitHub Pages site with HTTPS](https://help.github.com/en/articles/securing-your-github-pages-site-with-https)

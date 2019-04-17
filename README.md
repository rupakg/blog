# rupakganguly.com
Source for site and blog, based on Hugo.

## Get Latest

```
git pull --recurse-submodules
```
This will get the latest code for this repo and all its submodules, i.e. our [public](https://github.com/rupakg/rupakg.github.io) folder.

## Create Posts

```
$ hugo new posts/hello-word.md
```
**Note**: Add any static files i.e. html, css, js, images etc. to the static folder. These files will be copied 'as-is' to the destination folder.

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
This will generate the static pages. copy them to the `public` folder and deploy it to `rupakg.github.io` repo. It will then add the changes in the `public` folder into a commit, and then push to the master branch.

## Resources

[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
# rupakganguly.com
Source for site and blog, based on Hugo.

## Create Posts

```
$ hugo new posts/hello-word.md
```
**Note**: Add any static files i.e. html, css, js, images etc. to the static folder. These files will be copied 'as-is' to the destination folder.

## Test

```
$ hugo server -D
```

## Deploy

```
$ ./deploy.sh "Your optional commit message"
```
This will generated the static pages to the `public` folder and deploy it to `rupakg.github.io` repo.

## Resources

[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
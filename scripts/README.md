# Cross-posting scripts
courtsey of Christoph Michel (cmichel.io)

This [post](https://cmichel.io/how-to-crosspost-to-medium/) describes the whole process.

## Setup

1. Copy `scripts` folder from Michel's [github repo](https://github.com/MrToph/cmichelio/tree/master/scripts).
2. `npm init` to start a npm project
3. Install the following development dependencies:
    * `npm i --save-dev medium-sdk remark-frontmatter js-yaml to-vfile dotenv`
    * `npm i --save-dev steem` - only if you need to cross-post to Steem.
4. Create a copy of the `.env.example` as `.env` file. Add needed env. vars to this file. Make sure to add `.env` file to the `.gitignore` file.

## Cross post to Medium

Dry Run:

```
npm run crosspost -- medium dry --path="posts/welcome.md"
```

Post:

```
npm run crosspost -- medium --path="posts/welcome.md"
```

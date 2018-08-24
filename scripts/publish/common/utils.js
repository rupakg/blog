const path = require('path')
const fs = require('fs')

const REL_POST_PATH = 'content' // 'src/pages'

module.exports = {
  postExistsLocally: filePath => {
    return fs.existsSync(filePath)
  },
  prefixLocalRelativePaths: relativePath => {
    return path.posix.normalize(path.posix.join(REL_POST_PATH, relativePath))
  },
  slugFromPath: filePath => {
    // should be the same logic as in gatsby-node.js
    const pathRelativeToPages = path.posix.relative(REL_POST_PATH, filePath)
    // RG: remove the extension
    const slug = pathRelativeToPages.slice(0, -path.extname(pathRelativeToPages).length)
    console.log('Slug:', slug)
    
    return slug

    // RG: my posts are under /posts folder and I want the slug name to be my md file name
    // RG: so the following code is not required
    
    // return only the first folder/file, up to first slash (including)
    // const matches = /^[\s\S]+?\//.exec(pathRelativeToPages)
    // console.log('matches:', matches)
    // if(!matches) throw new Error(`Could not get slug from path for path "${filePath}" ("${pathRelativeToPages}")`)
    // return matches[0]
  },
}

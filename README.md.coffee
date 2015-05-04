# raconteur-express

It's [raconteur][] in express!

[raconteur]: https://www.npmjs.com/package/raconteur "raconteur module"

## Installation:

    npm install raconteur-express

## Usage:

With a post file that has YAML content in it (post.md):

    ---
    title: The Title
    tags: [foo, bar, test]
    preview: This is a summary of the content within.
    date: 05-01-2015
    ---
    # Hello
    Lorem ipsum dolor sit amet. 

And a template file, written in "sugar", which is a combination of `jade` and `dust` (index.sugar):

    article.post
        .written
            header
                h1.title(role="title")|{attributes.title}
                ul.tags|{#attributes.tags}
                    li.tag|{.}
                    {/attributes.tags}
            .data(role="written-content")|{content|s}
        footer
            .meta(data-timestamp="0")
                .time(role="timestamp")|{attributes.date}

You can invoke it like this:

    express = require 'express'
    app = express()
    cwd = process.cwd()
    _ = require 'lodash'
    raconteurExpress = require 'raconteur-express'

    app.set 'views', cwd + '/templates'
    app.engine 'sugar', raconteurExpress
    app.set 'view engine', 'sugar'

    app.get '/', (req, res)->
        options = _.extend {
            post: cwd + '/posts/' + post
            sugar: true
            yaml: true
        }, opts
        res.render 'index', options, (e, html)->
            if e?
                throw e
            res.send html
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

    var express = require('express');
    var app = express();
    var cwd = process.cwd();
    var _ = require('lodash');
    var raconteurExpress = require('raconteur-express');

    app.set('views', cwd + '/templates');
    app.engine('sugar', raconteurExpress);
    app.set('view engine', 'sugar');

    app.get('/', function(req, res) {
        var options = _.extend({
            post: cwd + '/posts/' + post,
            sugar: true,
            yaml: true
        }, opts);
        res.render('index', options, function(e, html) {
            if (e != null) {
                throw e;
            }
            return res.send(html);
        });
    });
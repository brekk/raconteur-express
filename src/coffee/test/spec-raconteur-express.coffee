'use strict'

request = require 'supertest'
mocha = require 'mocha'
should = require 'should'
assert = require 'assert'
express = require 'express'
_ = require 'lodash'
cwd = process.cwd()

raconteurExpress = require cwd + '/index'

harness = require cwd + '/test/fixtures/raconteur-express.json'

app = express()

app.set 'views', cwd + '/views'
app.engine 'sugar', raconteurExpress

renderPathWithTemplateAndPost = (path, template, post, opts)->
    app.get path, (req, res)->
      options = _.extend {
        post: post
        sugar: true
        yaml: true
      }, opts
      res.render template, options, (e, html)->
        if e?
          throw e
        res.send html

_.each harness.endpoints, (args)->
    renderPathWithTemplateAndPost.apply null, args
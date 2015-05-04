(->
    'use strict'
    try
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

        app.set 'views', cwd + '/test/fixtures/templates'
        app.engine 'sugar', raconteurExpress
        app.set 'view engine', 'sugar'

        postLocation = (loc)->
            return cwd + '/test/fixtures/posts/' + loc

        renderPathWithTemplateAndPost = (path, template, post, opts)->
            app.get path, (req, res)->
                options = _.extend {
                    post: postLocation post
                    sugar: true
                    yaml: true
                }, opts
                res.render template, options, (e, html)->
                    if e?
                        throw e
                    res.send html

        _.each harness.endpoints, (args)->
            renderPathWithTemplateAndPost.apply null, args

        describe "raconteur-express", ()->
            it "should take a post and a template location and return an html string", (done)->
                request(app).get('/yaml')
                            .expect('Content-Type', /html/)
                            .expect(200)
                            .end (err, res)->
                                if err
                                    done err
                                    return
                                res.should.be.ok
                                done()
            it "should take a post with json-front-matter and a template location and return an html string", (done)->
                request(app).get('/json')
                            .expect('Content-Type', /html/)
                            .expect(200)
                            .end (err, res)->
                                if err
                                    done err
                                    return
                                res.should.be.ok
                                done()
    catch e
        console.log "ERROR DURING TEST", e
        if e.stack?
            console.log e.stack
)()
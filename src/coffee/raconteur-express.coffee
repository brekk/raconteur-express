'use strict'
raconteur = require 'raconteur'
telepath = raconteur.telepath
telegraph = raconteur.telegraph
_ = require 'lodash'
debug = require('debug')('raconteur:express')

chain = telepath.chain()
                .file()

module.exports = (filePath, content={}, callback)->
    issue = null
    unless _.isString filePath
        issue = new TypeError "Expected filePath to be a string."
    unless _.isFunction callback # we won't rethrow because there's nothing to throw to
        throw new TypeError 'Expected callback to be a function'
    if !content.post?
        issue = new Error "Expected content.post to be set."
    if issue?
        callback issue
        return
    if content.sugar? and content.sugar
        chain = chain.sugar()
    chain.template filePath, content
         .post content.post, content
         .ready (e, out)->
            if e?
                callback e
                return
            callback null, out[0]
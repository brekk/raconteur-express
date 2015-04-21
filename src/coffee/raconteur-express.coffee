'use strict'
raconteur = require 'raconteur'
telepath = raconteur.telepath
telegraph = raconteur.telegraph
_ = require 'lodash'

chain = telepath.chain()
                .promise()
                .file()

# handleTemplateCache = (options, str)->
#     key = options.filename
#     if options.cache? and exports.cache[key]
#         return exports.cache[key]
#     else
#         # if !str?
#         #     # str = fs.readFileSync options.filename, 'utf8'
#         #     chain = chain.template options.filename, options
#         # tpl = exports.compile str, options
#         # chain.post(options)
#         tpl = exports.compile str, options
#         if options.cache? and options.cache
#             exports.cache[key] = tpl
#         return tpl

# exports.compile = (str, options={})->
#     filename = undefined
#     str = String str
#     templateFunction = chain.template str, options
#     return templateFunction

# exports.renderFile = (path, options={}, callback)->
#     if _.isFunction options
#         callback = options
#         options = undefined
#     if _.isFunction callback
#         try
#             res = exports.renderFile path, options
#         catch e
#             return callback e
#         return callback null, res
#     options.filename = path
#     return handleTemplateCache(options)(options)


module.exports = exports.__express = (templateName, content={}, callback)->
    issue = null
    unless _.isString templateName
        issue = new TypeError "Expected templateName to be a string."
    unless _.isFunction callback # we won't rethrow because there's nothing to throw to
        throw new TypeError 'Expected callback to be a function'
    if issue?
        callback issue
        return
    chain = chain.template templateName, content
    return (post)->
        chain.post post
             .ready callback
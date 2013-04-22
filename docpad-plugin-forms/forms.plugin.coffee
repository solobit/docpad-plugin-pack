

module.exports = (BasePlugin) ->

    class FormsPlugin extends BasePlugin

        name: 'forms'

        config:
            dependencies: ['docpad', 'URIjs']

        renderAfter: (opts, next) ->

            docpad = @docpad
            config = @config

            try
                coffeecup = require 'coffeecup'
                urijs = require 'URIjs'

                #global[opt] = require opt for opt in config.dependencies

            catch err
                console.log global
                docpad.log 'debug', err
                docpad.log 'debug', 'Cannot find module'

            #docpad.log 'debug', 'setting thuis and that'

        rander: (opts) ->

            {inExtension, templateData} = opts

            #if inExtension is 'md'

            docpad = @docpad
            config = @config

            docpad.debug 'done'

            opts.content = eco.render(opts.content,templateData)

            class X extends docpad.queryEngine.Backbone

                constructor: () ->
                    console.log "fooo"





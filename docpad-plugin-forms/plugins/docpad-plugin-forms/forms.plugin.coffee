

module.exports = (BasePlugin) ->

    class FormsPlugin extends BasePlugin

        name: 'forms'

        config:
            option1: 'something'

        renderAfter: (opts, next) ->

            docpad = @docpad
            config = @config

            x = require 'docpad'

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





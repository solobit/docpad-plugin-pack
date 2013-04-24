
# Expose this file to the outside
module.exports = (BasePlugin) ->

    # Wraps obfuscate-please in docpad plugin
    class MailMunge extends BasePlugin

        name: 'munge'

        #
        # Hook for docpad events
        #
        renderAfter: (opts, next) ->

            # Local scope defines
            docpad      = @docpad
            config      = @config

            # Simple package (todo extended)
            munge = require 'munge'

            # Collection from QueryEngine < Backbone
            database = docpad.getCollection('html')

            # Loop documents in database
            database.forEach (document) ->

                content    = document.get('contentRendered')

                pattern    = /([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})/gi

                result     = pattern.exec(content)

                # Set `$` to a cheerio instance which loads
                # the current document content in memory
                $ = require('cheerio').load(content)

                # Cheerio selectors

                # FORM element, set `action` attribute to munged string
                $('form').attr(
                    'action'
                    , munge($('form').attr('action'))
                    )

                mailSyn = ".email, .mail, .emailaddress, .mailadres, .e-mail"
                elGroup = "a, div, span, p, img"

                if $(mailSyn).text() or $(elGroup).attr('itemprop')

                    console.log $('.email,.mail,.emailadres').html()

                # Persist changes by changing the document object and
                # feeding it the cheerio modified html tree
                document.set('contentRendered', $.html())


                next()?


            @ # Chain





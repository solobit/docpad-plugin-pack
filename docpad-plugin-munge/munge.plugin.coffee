
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

            # Get HTML collection from QueryEngine
            database = docpad.getCollection('html')

            # Loop documents in database
            database.forEach (document) ->

                content = document.get('contentRendered')

                # Mail addresses
                # We are not selective, email can appear anywhere in the
                # HTML such as anchors, paragraphs, propitem attribute,
                # and so on. We want *everything*.

                regex = /// #--------------------------------

                    #\b                     # word boundry
                        [A-Z0-9._%+-]       # alphanumeric +
                            +@              # at `@`
                                [A-Z0-9.-]  # alphanumeric
                            +\.             # dot
                        [A-Z]{2,4}          # extension
                    #\b                     # close boundry

                    # --------------------------------------
                    ///gi # Regex using global and ignore case (both required)

                results = content.match(regex)
                for result in results when results?
                    mresult = munge(result)
                    docpad.log 'debug', "Found email #{result} munging to output #{mresult}"
                    content = content.replace(result, mresult)
                    document.set('contentRendered',content)



                next()?


            @ # Chain





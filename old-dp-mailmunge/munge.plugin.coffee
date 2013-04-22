
# Expose this file to the outside
module.exports = (BasePlugin) ->

    # Wraps obfuscate-please in docpad plugin
    class MailMunge extends BasePlugin

        # Easily locate plugin
        name: 'mailmunge'

        # Settings
        config:

            debug:      false

            # Encode characters (rewrite each character to HTML entity)
            encode:     true

            # Inserts spans with random data, then hides spans using CSS
            spans:      true

            # Decreases effectiveness spans (!) inserting friendlier `mailto:`
            mailto:     true

            # Enables obfuscated form action URL strings to 'post' server
            forms:      true

            # Requires client JavaScript enabled. Parses URI obfuscated.
            javascript: true

            # Enables helper for URI string splitting and parsing
            uritool:    true

        #
        # Hook for the docpad events
        #
        renderAfter: (opts, next) ->

            # Local scope defines
            docpad      = @docpad
            config      = @config

            munge = require 'munge'

            # Get HTML collection from QueryEngine
            database = docpad.getCollection('html')

            # Loop documents in database
            database.forEach (document) ->

                content = document.get('contentRendered')

                # Regex using global and ignore case (both required)
                # although I could have added the a-z to skip i
                regex = /// #--------------------------todo??

                    #\b                      # word boundry
                        [A-Z0-9._%+-]       # alphanumeric +
                            +@              # at `@`
                                [A-Z0-9.-]  # alphanumeric
                            +\.             # dot
                        [A-Z]{2,4}          # extension
                    #\b                      # close boundry

                    # --------------------------------------
                    ///gi

                # Extract data using global regex with no word bounds
                #onliner = /([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})/ig
                results = content.match(regex)

                console.log results... if results isnt null
                #obfuscate(result) for result in results
                for result in results
                    console.log result
                    console.log munge(result)
                    #console.log obfuscate(result)
                    emailObj = {text: result, cleanEmail: result}



                # Test
                # console.log 'email found'

                #    content = content.replace(/href="\//g, href)
                #if /href="\//.test(content)
                #    content = content.replace(/src="\//g, src)
                #document.set('contentRendered',content)

                next()?


            @ # Chain





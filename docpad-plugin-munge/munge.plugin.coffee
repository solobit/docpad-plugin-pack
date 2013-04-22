
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

                emailPattern = ///
                       ([\w.-]+)         # john.smith-junior
                       @                 # @
                       ([\w.-]+)         # gmail-mail.com
                       \.                # .
                       ([a-zA-Z.]{2,6})  # com
                    ///gi #end of line and ignore case

                results = content.match(emailPattern)
                for result in results when results?
                    docpad.log 'debug', " 📨 Munge ⓜ found e-mail address #{result}"
                    mresult = munge(result)
                    docpad.log 'debug', " ␦ Munge ⓜ email to obfuscated string output #{mresult}"
                    content = content.replace(result, mresult)
                    document.set('contentRendered',content)
                    docpad.log 'debug', "Munge: email '#{result}' has content rendered"

                urlPattern = ///
                        (\<form)
                        (.*)
                        (action\=)
                        (\"|\'|)
                            (http[s]?:\/\/){0,1}
                            (www\.){0,1}
                            [a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}
                            [\.]{0,1}
                        (\"|\')
                    ///gi

                results = content.match(regexMail)
                for result in results when results?
                    docpad.log 'debug', " 🌍 Munge ⓜ found form action URL #{result}"
                    mresult = munge(result)
                    docpad.log 'debug', " ␦ Munge ⓜ form action to obfuscated string output  #{mresult}"
                    content = content.replace(result, mresult)
                    document.set('contentRendered',content)
                    docpad.log 'debug', "Munge: form actio
                     '#{result}' has content rendered"

                next()?


            @ # Chain






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
            debug       = (msg) -> docpad.log msg if config.debug is true
            obfuscate   = (txt) ->

                for option of @config
                    obfuscator[option] mailObj if option is true
                    console.log option
                    emailObj.text


            docpad.log 'debug', 'Set obfuscator for MailMunge'

            #
            # Obfuscator
            # ----------
            # Hash object with keys mapped to config options
            #
            obfuscator  = {

                randomNumber:    (max) ->

                    Math.floor (Math.random() * max) + 1

                # Encode characters: Rewrites each character in the
                # address in its HTML Entity form. This is easily
                # parsed by browsers, but evades most basic email
                # harvesters.
                encode:     (emailObj) ->

                    newText             = ""
                    text                = emailObj.cleanEmail

                    (newText += "&#" + text.charCodeAt(index) + ";") for char, index in text

                    emailObj.text       = newText
                    emailObj.cleanEmail = newText

                # Insert invisible spans: Inserts random span
                # elements in random locations in the mail address.
                # These spans are hidden using CSS, leaving them
                # completely invisible to the end user, but not to
                # harvesters.
                spans:      (emailObj) ->

                    newText = undefined
                    text = emailObj.cleanEmail

                    spansInserted = 0

                    while spansInserted < 1 or spansInserted > 3

                        newText         = ""
                        spansInserted   = 0

                        for char, index in text

                            newText += char

                            if (not @config.encode isnt true or char is ";") and @randomNumber(10) is 1

                                spansInserted++

                                newText += "<span style=\"display:none\">"

                                r = 0

                                while r < @randomNumber(3) + 3
                                    newText += String.fromCharCode(@randomNumber(26) + 96)
                                    r++

                                newText += "</span>"

                    emailObj.text = newText

                # Include mailto link: Wraps the address inside of a
                # mailto link, allowing end users to send an email
                # to the address simply by clicking on it. Note:
                # Invisible spans can't be inserted in the 'href'
                # portion of the link.
                mailto:     (emailObj) ->

                    emailObj.text = "<a href=\"mailto:" +
                    emailObj.cleanEmail + "\">" +
                    emailObj.text + "</a>"

                # Write using Javascript: Creates a small Javascript
                # snippet that will write the email address directly
                # to the page. This prevents harvesters that can't
                # parse Javascript from acquiring the address, but
                # also requires that end users have Javascript
                # enabled.
                javascript: (emailObj) ->

                    text = emailObj.text
                    newText = "<script type=\"text/javascript\">document.write(\""

                    for char, index in text
                        if char isnt "\"" then newText += char else newText += "\\\""
                        newText += "\"+\""  if @randomNumber(10) is 1

                    newText += "\");</script>"
                    emailObj.text = newText

                }

            #if 'static' in docpad.getEnvironments()
            debug 'MailMunge started [ok]'

            # Get HTML collection from QueryEngine
            database = docpad.getCollection('html')

            debug 'MailMunge has \"html\" in database'

            # Loop documents in database
            database.forEach (document) ->

                content = document.get('contentRendered')

                debug 'MailMunge loads ' + document.id

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





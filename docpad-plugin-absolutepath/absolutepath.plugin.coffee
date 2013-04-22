# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class absolutepath extends BasePlugin
    # Plugin Name
    name: 'absolutepath'
    config:
      url: "/"

    renderAfter: (opts,next) ->
      docpad = @docpad
      if 'static' in docpad.getEnvironments()
        docpad.log 'debug', 'Writing absolute urls'
        href = 'href="' + @config.url
        src = 'src="' + @config.url
        database = docpad.getCollection('html')
        database.forEach (document) ->
          content = document.get('contentRendered')
          if /href="\//.test(content)
            content = content.replace(/href="\//g, href)
          if /src="\//.test(content)
            content = content.replace(/src="\//g, src)
          document.set('contentRendered',content)
        next()?
      else
        next()?

      # Chain
      @
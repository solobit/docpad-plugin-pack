
function _docpad_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
        subcommand)
          subcommands=(
      'action:does everyting: skeleton, generate, watch, server'
      'run:does everyting: skeleton, generate, watch, server'
      'server:creates a server for your generated project'
      'skeleton:will create a new project in your cwd based off an existing skeleton'
      'render:render the file at <path> and output its results to stdout'
      'generate:(re)generates your project'
      'watch:watches your project for changes, and (re)generates whenever a change is made'
      'install:ensure everything is installed correctly'
      'clean:ensure everything is cleaned correctly (will remove your out directory)'
      'info:display the information about your docpad instance'
      'help:output the help'
    )
        _describe -t subcommands 'docpad subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _docpad_commands lein
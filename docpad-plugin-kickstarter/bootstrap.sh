#!/usr/bin/env bash

# Copyright 2013 (c) Rob Jentzema (Solobit.net)
# Published under MIT License

# This single file bridges some gaps between platforms, shell and Node.js as
# well as provides some sanity checks before kicking in the full Node.js
# spectrum so we may have it easier later on.

# Much of shell operations will, later, be covered by 'shelljs' and 'cson' does
# some translations from and to native package formats (JSON basically).

# Arrays / lists
declare -a REQ_CMDS=('json' 'cson2json' 'json2cson')
declare -a REQ_APPS=('cson' 'json' 'shelljs')

# Failed options?
E_FAIL_OPT=65

# Missing command from one of the apps below.
E_MISS_CMD=66

# We only require Node.js npm published apps.
E_MISS_APP=67


ks_init() {

  # Gentle and graceful project initialization
  npm init &&\ : If package.json already exists, will non-harmful requery
    \ : Immediately chain conditional execution of bare package installations
    npm i cson json shelljs --save-dev : Persist changes to package.json
}

ks_welcome() {

# Dragon by Marcin Glinsky and n4biS
echo -e "\033[31m

                                       _,,_,,,.._    <-.
                                     ,'   _____, \`.    \`\\
                                    /  .'       \`^,'.__//
                                   \"  /            '---'
                                   |  \"
                                   \"   \\
                                    \\   \".
                                     \`.,__\\,
                          _,,-~\`--..-~-'_,/\`--,,,____
                      \`\\,_\033[31m,/'\033[35m,_\033[34m.-~_.\033[32m.-~/\033[33m' ,/-\033[32m--~\033[34m~~\"\033[35m\"\033[31m\"\`\\
                 _,_,,,\\q\\q/'  \033[34m  \\,,\033[32m-~'_\033[33m,/\`\033[32m\`\033[34m\`\033[35m\`\033[31m\`-,7.                   ___,,-
                \`@v@\`\\,,,,__ \033[34m  \\,,\033[32m-~~\"__\033[33m/\`\033[34m \",\033[35m,\033[31m/   \\     ___.----~~~'\",,7
                 \`--''_..-~~\\  \033[34m \\,\033[32m-~~\033[33m\"\" \033[34m \`\033[31m\\_,/ \`^__.---~~   _,,---,\"\"\`
                  ,|\`\`-~~--./_,,_  _,,-~~'/  .-~'   ,,,--~\"\"_ __,\"
                ,/  \`\\,_,,/\`\\   \033[33m \`\\   \\,\033[31m,[ /' _,-\"/' /\\, _\`_ _)
                            ;   __\033[33m/-~~-|\033[31m ||\` | /\\__/\\__/\\, _\`__)
                             .\"\033[37m ,;,,,__7\033[31m ] \\  \\ __/\\__/\\,_\`___,\`
                          ,-' \033[37m,'      /\033[31m /   \\  \\_/\\__/\\ /  \`._)
                         / \033[37m ,\"-~~~~--/\033[31m /     \\  \\ /_ \\  ,-,_/\\ \033[33m\\ \033[31m
                         \\ \033[37m/        /\033[31m  I      )  I  /__(      \\ \033[37m\\ \033[31m
                          \033[37mY-,,,,,--I\033[31m   |    ,'  / \`-   /[      \\ \033[37m\\ \033[31m
                         \033[37m/        |\033[31m    \\_,-'   ,\`   >-' /       |\033[37m :  \033[31m
                        _\033[37mL_      _I\033[31m     (   _,\"      /-\"        ]\033[33m |   \033[31m
                       / \033[37m| \"\"\"\"\"\"  \\ \033[31m    '-\"___/^^~~'  ,__,,_, / \033[33m/\033[31m__
                      [  \033[37m|          \\ \033[31m             7  /           @ )
                       \\ \033[37m \\ _       _\\ \033[31m         \\,---~\\    __,     /
                        ] \033[37m \\ \"\"\"\"\"\"\"  \\ \033[31m               \\\\\"__,-.\"  _/
                   ____/  (\033[37m \`-          \`,\033[31m               ,___/  (_
               _,-'/,-/,_. \\ \033[37m \`\"\"----\"\"\"\" \`,\033[31m         ___/_/ 7\`,-._\\__
               \\[ {( {(   \`_}  \033[33m \`-..        \",\033[31m       \\[_\\({(/     \`~_}
                   \`  \`\`          \033[33m  \"\"--..--\"-\"----\"\"\033[31m \` \` \`


\033[0m"
# 31m red
# 32m green
# 33m yellow
# 34m blue
# 35m mangenta
# 36m cyan
# 37m white

}

ks_msg_path() {

printf "\n%s\n%s\n" "$(tput setaf 1)
NOTICE:$(tput sgr0)" "
-------
You should execute the following in this terminal: $(tput setaf 6)

  export PATH=\${PATH}:node_modules/.bin$(tput sgr0)

then add to your session startup file $(tput setaf 3)~/.profile$(tput sgr0)
for example, you could use this little bash-snippet:$(tput setaf 6)

  echo \"export PATH=\${PATH}:node_modules/.bin\" >> ~/.profile $(tput sgr0)

Adding this folder to your user-profile environment variable \$PATH, will
ensure you get automagical access to any Node.js project executable files (which
follow this convention of publishing / linking to 'node_modules/.bin'.

Once done, run this script again."

}

ks_readme() {

# Test to make sure again we don't override
[[ -f README.md ]] && exit 33

cat << 'EOF' > README.md

:warning: This software is **not** production ready :warning:

*This is a **work in progress** Please be patient as documentation is written as the project progresses. This software is under a `development`-branch for a reason. Use at your own risk.

Please fill in this file with some of the following information. This is in no way required but for your own comfort and those of your user-base and/or developers


### LEGAL DISCLAIMER

Without limitation of the foregoing, $(Solobit) expressly does not warrant that:

1. the software will meet your requirements or expectations;
1. the software or the software content will be free of bugs, errors, viruses or other defects;
1. any results, output, or data provided through or generated by the software will be accurate, up-to-date, complete or reliable;
1. the software will be compatible with third party software;
1. any errors in the software will be corrected.

EOF

}

ks_main() {

  # Test for local Node.js modules installation under regular (convention) path.
  # If neither are found, initialize this project from square 1.
  [[ ! -d node_modules/cson || ! -f package.json ]] && ks_init

  # Add a blanco (templated TODO) readme file to stop npm from whining about it.
  [[ ! -f README.md ]] && ks_readme

  err=0

  # Test every dependency
  for cmd in "${REQ_CMDS[@]}"; do
    $(: Most reliable test method we have available, pipe to sink)
    hash $cmd 2>/dev/null || {
      echo >&2 "$(tput setaf 4)ERROR: $(tput sgr0)Command `cmd` not found."\
      "Please ensure the application to which '`cmd`' belongs is properly installed."\
      "Exiting now...";
      printf "\n%s %s\n" "[$(tput setaf 1)FAIL$(tput sgr0)] Some commands required are not found.";
      err=1;
    }
  done; [[ $err != 0 ]] && ks_msg_path && exit 66
  printf "\n%s %s" "[$(tput setaf 2)GOOD$(tput sgr0)] All commands required are found."

  # FIXME refactor
  # Friendly advice that won't kill you (non-fatal, optional dependencies)
  hash git-flow 2>/dev/null || {
    echo >&2 "I couldn't find 'git-flow', either it's not installed or you do not have this executable or alias anywhere in your PATH. If you don't know what this is, you should really, really start using this for your projects. Read more: http://nvie.com/posts/a-successful-git-branching-model/";
    echo
    exit 65;
  }


  # All is good!
  ks_welcome
}

ks_meta() {

# Meta-programming small shell scripts...
[[ -d bin ]] || mkdir bin/

[[ -f bin/pkg.sh ]] || cat << 'EOF' > bin/pkg.sh
#!/usr/bin/env bash
# This script was generated by a tool. Run ../bootstrap.sh to regenerate


EOF
}

# TODO Find a clean way to ensure synced package.json and package.cson files
ks_annotate() { echo; }

# Chainstrap
ks_main

#vim: ft=sh:fdm=manual:fmr={{{,}}}:et:nospell:sw=2:ts=2:sts=2:foldlevel=1

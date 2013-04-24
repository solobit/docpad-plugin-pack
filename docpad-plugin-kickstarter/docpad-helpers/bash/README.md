


## Prerequisites

I assume you run a functioning `bash` shell, most often found in any Unix,
Linux or Mac OS operating systems or, using e.g. Cygwin, on Windows with little
effort. You have [Node.js][njs] installed and working (preferably without the
need for `root` access to install global modules - if any. But that's a
different story for another time. Finally, you will need to have [docpad][dp]
installed.

## General introduction

Original source(s): <http://www.debian-administration.org/articles/316>

One of the nicest facilities of the modern shell is the built in "completion"
support. These facilities allow you to complete commands and their arguments
easily from the shell terminal prompt - also known as the command line
interface and dozens of other, often incorrectly used names.

If any of this jargon still seems alien to you, you might want to check out
this [tuxfiles command line terminology][tux] help file to get started.

Most shells allow **command completion**, typically bound to the `TAB` key, which
allow you to complete the names of commands stored upon your `$PATH`, file names,
or directory names.

## Extremely fast setup (simple one-liner)

Use the following in your bash shell terminal of choice, for the shortest
possible implementation of autocompletion for the docpad command-line executable:

``` sh
bind 'TAB:menu-complete'
```

You now have not only the command `docpad` completed by the readline but also,
on consecutive TABs, iterates over the list of matching menu commands like
`docpad-compile` and `docpad-server`. Without this command, you will only find
`docpad` to be autocompleted.

## Beginners to the command line (long version)

The autocomplete functionality is typically used in the following manner, from
a bash shell in any terminal emulator such as `gnome-terminal` for example:

```
ls /bo[TAB]
```

When you press the `TAB` key, the argument `/bo` is automatically replaced with
the value `/boot`.

Go ahead, try it for yourself. Unfortunately, there are few things uniform in
how someone accesses their shell, so it's impossible to give exact instructions
that work for everyone in those cases, so you'll have to know at least how to
run start a terminal application. This most probably is the case since Node's
`npm` and Bevry's `docpad` tools come in the form of terminal apps.

### Not the expected result?

If this isn't working for you, first make sure you are running the bash shell
by typing `echo $0` and if correct, it should return a string to standard
output which says `bash`. If not, fire up a bash shell with the command `bash`
and try to autocomplete the `alias` command by typing `ali[TAB]`.

### Autocompletion not installed?

Autocomplete is nothing but a collection of various hacks that specify how
arguments are to be completed by Readline using complete built-in. By default,
this feature is turned on many Linux distributions such as Debian Linux, Ubuntu
Linux and more. However, this feature is not installed on RHEL based Linux
distributions.

You will need to have this little piece of software/script installed,
typically, if not present already, via the package manager that goes with your
Unice or Mac machine, which is conviniently named as **bash-completion** but
this may slightly differ depending on the platform or distribution you use.
Some of the most common used are:

``` sh
# Debian derived operating systems like Ubuntu
# use whichever you normally use (but not both!)
apt-get install bash-completion
aptitude install bash-completion

# RHEL/CentOS/Fedora
yum install bash-completion

# ArchLinux
# (you need to have 'extra' repo enabled)
pacman -S bash-completion
```

If you're not using it right now you can load it by typing into your shell 
`. /etc/bash_completion` as shown here (the period `.` is a short-hand command
alias for `source`):

``` sh
source /etc/bash_completion
```

Once this is done you'll be able to TAB-complete many common arguments to
programs. Autocomplete should now be working but you may need to reload your shell
Now you should have a *working* bash-completion mechanism in place.

### Define customized autocompletion

But how do you extend the support yourself? Well the completion routines
supplied make use of several internal bash commands such as complete. These can
be used by your own shell startup files, or more easily by creating a small
file and dropping it into the directory /etc/bash_completion.d/.

When the bash_completion file is sourced (or loaded) everything inside the
/etc/bash_completion.d directory is also loaded. This makes it a simple matter
to add your own hooks.

One of the things which bash allows you to complete is hostnames, this can be
very useful for some commands.

### Our end result

The orginal writing I stole this from, had a xvncviewer example included but for
this purpose we'll use a hand-rolled `docpad` fragment. Lets say we want to
complete on the environments defined in docpad, a feature currently not present
anywhere in docpad.

To allow bash to complete the environment names, we'll use the `complete`
command to tell it that docpad requires a environment name in conjunction with
the `--env` argument:

``` sh
user:~$ complete -F _dpad_envs docpad
```

Once I've done this I can type [TAB] to complete environment names:

``` sh
user@host:~$ docpad --env=[TAB]
static                      development
dynamic                     production
testing                     playground
integration

user@host:~$ docpad --env=st[TAB]
```

This has now completed the environment name `static` for me. Not a big gain in
reducing keystrokes, but there will be more to come and this serves as a nice
exploration of capabilities.

The function **_dpad_envs** is defined in the file `/etc/bash_completion`.
How did I know I could use it? By using the command `complete -p` to display
all of the bindings in use.

**If we wish to add custom completion to a command we will instead write our own
function, and bind that to the command.**

### How did we get there? The custom function

As a basic example we'll first look at adding some simple completions to the
binary `foo`. This *hypothetical* command takes three arguments:

* --help Shows the help options for foo, and exits.
* --version Shows the version of the foo command, and exits.
* --verbose Runs foo with extra verbosity

To handle these arguments we'll create a new file /etc/bash_completion.d/foo. This file will be automatically sourced (or loaded) when the bash completion code is loaded.

Inside that file save the following text:

``` sh
_foo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--help --verbose --version"

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}
complete -F _foo foo
```

To test it you can now source the file:

``` sh
user@host:~$ . /etc/bash_completion.d/foo
user@host:~$ foo --[TAB]
--help     --verbose  --version  
```

If you experiment you'll see that it successfully completes the arguments as
expected. Type `foo --h[TAB]` and the --help argument is completed. Press [TAB]
a few times and you'll see all the options. (In this case it doesn't actually
matter if you very probably don't have a binary called `foo` installed upon
your system.)

So now that we have something working we should look at how it actually works!

### How Completion Works

The previous example showed a simple bash function which was invoked to handle
completion for a command.

This function starts out by defining some variables cur being the current word
being typed, prev being the previous word typed, and opts which is our list of
options to complete.

The option completing is then handled by use of the compgen command via this line:

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

What this does is set the value of `$COMPREPLY` to the output of running the command:

    compgen -W "${opts}" -- ${cur}

If you replace these variables with their contents you'll see how that works:

    compgen -W "--help --verbose --version" -- "userinput"

This command attempts to return the match of the current word `${cur}` against
the list `--help --verbose --version`. If you run this command in a shell
you'll be able to experiment with it and see how it works:

``` sh
user@host:~$ compgen -W "--help --verbose --version" -- --
--help
--verbose
--version
user@host:~$ compgen -W "--help --verbose --version" -- --h 
--help
```

Here you first see what happens if the user enters just `--` - all three
options match so they are returned. In the second attempt the user enters `--h`
and this is enough to specify --help unambiguously, so that is returned.

In our function we simply set "COMPREPLY" to this result, and return. This
allows bash to replace our current word with the output. COMPREPLY is a special
variable which has a particular meaning within bash. Inside completion routines
it is used to denote the output of the completion attempt.

From the [bash reference manual][abs] we can read the description of COMPREPLY:

COMPREPLY

An array variable from which Bash reads the possible completions generated by a
shell function invoked by the programmable completion facility

We can also see how we found the current word using the array COMP_WORDS to
find both the current and the previous word by looking them up:

    COMP_WORDS

An array variable consisting of the individual words in the current command
line. This variable is available only in shell functions invoked by the
programmable completion facilities.

    COMP_CWORD

An index into ${COMP_WORDS} of the word containing the current cursor position.
This variable is available only in shell functions invoked by the programmable
completion facilities

## The next step

'Recently' some shells have started allowing you to do even more: completing
arguments to commands. Two notable shells which allow this are `zsh`, and
`bash`.




### Option )

The bash offers control over the behavior of autocompletion.

The most primitive example is this (just run it in your bash; if you want it
available everywhere, put the complete ... line into your .bashrc):

``` sh
> complete -W "list of all words for an automatic completion" command_to_be_completed
> command_to_be_completed a<TAB>
all an automatic
```

With complete you define how the specified command shall be completed. For
basic needs, -W (as in "word list") should be enough, but you may also specify
a function, a glob pattern and many more. complete -p gives you a list of
currently defined autocompletions. Behold, thou might not define multiple
completions for one command.

I recently built a script that takes a project name and then boots a
development environment. The project name is taken from a directory holding all
projects, so I created the following completion to save tedious
project-spelling:

``` sh
complete -W "$(ls ~/dev/projects )" devenv
```



[abs]: <http://www.gnu.org/software/bash/manual/bash.html>

# simple erlang release management: erlenv

erlenv lets you easily switch between multiple erlang releases. it's
simple, unobtrusive, and follows the UNIX tradition of single-purpose
tools that do one thing well

erlenv is not just based on [rbenv][rbenv], it is rbenv. in fact, rbenv can be used unmodified to switch between erlang releases, doing so 'turns off' your ruby release, however, so modifications have been made to allow both to run simultaneously

erlenv is released under the terms of the [mit license][mit]


## index ##

* [introduction](#intro)
* [quickstart](#quickstart)
* [usage](#usage)
  - [global](#global)
  - [local](#local)
  - [shell](#shell)
  - [release](#release)
  - [releases](#releases)
  - [rehash](#rehash)
  - [which](#which)
  - [whence](#whenc)
* [acknowledgments](#thanks)


## <a name="introduction">introduction</a> ##

erlenv allows multiple erlang releases to coexist peacefully, and makes it easy to switch between them on a systemwide, per user or per directory basis

each directory under the directory `~/.erlenv/releases` is considered a release. you might have `~/.erlenv/releases/r14b04`, `~/.erlenv/releases/r15b01` and `~/.erlenv/releases/github_head` for example

each release is it's own working tree with it's own binaries and applications. erlenv creates _shim_ binaries - simple wrapper scripts - that redirect execution to the currently active release

because of this shim approach, all you need to use erlenv is `~/.erlenv/shims` in your `$PATH`


## <a name="quickstart">quickstart</a> ##


check out erlenv into `~/.erlenv`:

    $ cd
    $ git clone git://github.com/talentdeficit/erlenv.git .erlenv

add `~/.erlenv/bin` to your `$PATH` for access to the `erlenv` command-line utility

    $ echo 'export PATH="$HOME/.erlenv/bin:$PATH"' >> ~/.bash_profile
    **zsh note**: modify your `~/.zshenv` file instead of `~/.bash_profile`

add erlenv init to your shell to enable shims and autocompletion

    $ echo 'eval "$(erlenv init -)"' >> ~/.bash_profile
    **Zsh note**: modify your `~/.zshenv` file instead of `~/.bash_profile`

restart your shell so the path changes take effect. you can now begin using erlenv

    $ exec $SHELL

install releases into `~/.erlenv/releases`. for example, to install OTP R15B01, download and unpack the source, then run:

    $ ./configure --prefix=$HOME/.erlenv/releases/r15b01
    $ make
    $ make install

rebuild the shim binaries. you should do this any time you install a new release

    $ erlenv rehash

start using erlenv


## <a name="usage">usage</a> ##

like `git`, the `erlenv` command delegates to subcommands based on its first argument. the most common subcommands are:

### <a name="global">global</a> ###

sets the global release to be used in all shells by writing the version name to the `~/.erlenv/release` file. this version can be overridden by a per-project `.erlang-release` file, or by setting the `ERLENV_RELEASE` environment variable

    $ erlenv global r15b01

the special version name `system` tells erlenv to use the system erlang (detected by searching your `$PATH`)

when run without a release name, `erlenv global` reports the currently configured global version

### <a name="local">local</a> ###

sets a local per-project release by writing the version name to an `.erlang-release` file in the current directory. this version overrides the global, and can be overridden itself by setting the `ERLENV_RELEASE` environment variable or with the `erlenv shell` command.

    $ erlenv local r15b01

when run without a release name, `erlenv local` reports the currently
configured local release. you can also unset the local version:

    $ erlenv local --unset

### <a name="shell">shell</a> ###

sets a shell-specific release by setting the `ERLENV_RELEASE` environment variable in your shell. this release overrides both project-specific releases and the global release

    $ erlenv shell riak-1.1.1

when run without a release name, `erlenv shell` reports the current value of `ERLENV_RELEASE`. you can also unset the shell version:

    $ erlenv shell --unset

note that you'll need erlenv's shell integration enabled (step 3 of the installation instructions) in order to use this command. if you prefer not to use shell integration, you may simply set the `ERLENV_RELEASE` variable yourself:

    $ export ERLENV_RELEASE=riak-1.1.1

### <a name="release">release</a> ###

displays the currently active release, along with information on how it was set

    $ erlenv release
    riak-1.1.1 (set by /Users/alisdair/riak/.erlang-release)

### <a name="releases">releases</a> ###

lists all releases known to erlenv, and shows an asterisk next to the currently active release

    $ erlenv versions
      r14b04
      r14b04-minimal
      r15b01
    * r15b01-minimal (set by /Users/alisdair/.erlenv/global)
      riak-1.1.1

### <a name="rehash">rehash</a> ###

installs shims for all release binaries known to erlenv (i.e., `~/.rbenv/releases/*/bin/*`). run this command after you install a new release

    $ erlenv rehash

### <a name="which">which</a> ###

displays the full path to the binary that erlenv will execute when you run the given command

    $ erlenv which erl
    /Users/alisdair/.erlenv/releases/r15b01/bin/erl

### <a name="whence">whenc</a> ###

lists all releases with the given command installed

    $ erlenv whence typer
    r14b04
    r15b01
    riak-1.1.1


## <a name="thanks">acknowledgements</a> ##

erlenv is entirely the product of [sam stephenson][sstephenson] and all credit should go to him. i've just modified it slightly to make it nicer to work with erlang releases

[sstephenson]: https://github.com/sstephenson
[rbenv]: https://github.com/sstephenson/rbenv
[MIT]: http://www.opensource.org/licenses/mit-license.html

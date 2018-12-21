# erlenv (v0.4) #

## do you like rbenv? you'll love erlenv ##

used to [rbenv][rbenv]? erlenv is
*almost* exactly the same thing. use erlenv to setup and switch between
multiple erlang releases effortlessly. ok maybe some tiny amount of
effort required

erlenv is a fork of [rbenv][rbenv] and all credit belongs to
[sam stephenson][sstephenson] and the other contributors to [rbenv][rbenv]


## index ##

* [introduction](#introduction)
* [quickstart](#quickstart)
* [usage](#usage)
  - [global](#global)
  - [local](#local)
  - [shell](#shell)
  - [release](#release)
  - [releases](#releases)
  - [rehash](#rehash)
  - [which](#which)
  - [whence](#whence)
* [license](#license)


## introduction ##

erlenv allows multiple erlang releases to coexist peacefully, and makes it easy
to switch between them on a systemwide, per user or per directory basis

each directory under the directory `~/.erlenv/releases` is considered a release.
you might have `~/.erlenv/releases/r14b04`, `~/.erlenv/releases/r15b01` and
`~/.erlenv/releases/github_head` for example

each release is it's own working tree with it's own binaries and applications.
erlenv creates _shim_ binaries - simple wrapper scripts - that redirect execution
to the currently active release

because of this shim approach, all you need to use erlenv is `~/.erlenv/shims`
in your `$PATH`


## quickstart ##


1. Check out erlenv into `~/.erlenv`.

```bash
$ cd
$ git clone https://github.com/talentdeficit/erlenv.git .erlenv
```

2. Add `~/.erlenv/bin` to your `$PATH` for access to the `erlenv` command-line
utility.

**For bash**

```bash
$ echo 'export PATH="$HOME/.erlenv/bin:$PATH"' >> ~/.bash_profile
```

**For zsh**

```zsh
$ echo 'export PATH="$HOME/.erlenv/bin:$PATH"' >> ~/.zshenv
```

**For fish shell**

```fish
$ echo 'set PATH ~/.erlenv/bin $PATH' >> ~/.config/fish/config.fish
```

3. Run `~/.erlenv/bin/erlenv init` for shell-specific instructions on how to initialize erlenv to enable shims and autocompletion.

4. Restart your shell so the path changes take effect. you can now begin using erlenv.

**For bash and zsh**

```bash
$ exec $SHELL
```

**For fish shell**

```fish
$ eval $SHELL
```

5. Install releases into `~/.erlenv/releases`. for example, to install OTP R15B01,
download and unpack the source, then run:

```bash
$ ./configure --prefix=$HOME/.erlenv/releases/r15b01
$ make
$ make install
```

```bash
$ erlenv rehash
```

6. Start using `erlenv`.

```bash
$ erlenv
```


## usage ##

like `git`, the `erlenv` command delegates to subcommands based on its first
argument. the most common subcommands are:

### global ###

sets the global release to be used in all shells by writing the version name to
the `~/.erlenv/release` file. this version can be overridden by a per-project
`.erlang-release` file, or by setting the `ERLENV_RELEASE` environment variable

```bash
$ erlenv global r15b01
```

the special version name `system` tells erlenv to use the system erlang (detected
by searching your `$PATH`)

when run without a release name, `erlenv global` reports the currently configured
global version

### local ###

sets a local per-project release by writing the version name to an `.erlang-release`
file in the current directory. this version overrides the global, and can be
overridden itself by setting the `ERLENV_RELEASE` environment variable or with the
`erlenv shell` command.

```bash
$ erlenv local r15b01
```

when run without a release name, `erlenv local` reports the currently
configured local release. you can also unset the local version:

```bash
$ erlenv local --unset
```

### shell ###

sets a shell-specific release by setting the `ERLENV_RELEASE` environment variable
in your shell. this release overrides both project-specific releases and the global
release

```bash
$ erlenv shell riak-1.1.1
```

when run without a release name, `erlenv shell` reports the current value of
`ERLENV_RELEASE`. you can also unset the shell version

```bash
$ erlenv shell --unset
```

note that you'll need erlenv's shell integration enabled (step 3 of the installation
instructions) in order to use this command. if you prefer not to use shell integration,
you may simply set the `ERLENV_RELEASE` variable yourself

```bash
$ export ERLENV_RELEASE=riak-1.1.1
```

### release ###

displays the currently active release, along with information on how it was set

```bash
$ erlenv release
riak-1.1.1 (set by /Users/alisdair/riak/.erlang-release)
```

### releases ###

lists all releases known to erlenv, and shows an asterisk next to the currently active
release

```bash
$ erlenv versions
  r14b04
  r14b04-minimal
  r15b01
* r15b01-minimal (set by /Users/alisdair/.erlenv/global)
  riak-1.1.1
```

### rehash ###

installs shims for all release binaries known to erlenv (i.e., `~/.rbenv/releases/*/bin/*`).
run this command after you install a new release

```bash
$ erlenv rehash
```

### which ###

displays the full path to the binary that erlenv will execute when you run the given
command

```bash
$ erlenv which erl
/Users/alisdair/.erlenv/releases/r15b01/bin/erl
```

### whence ###

lists all releases with the given command installed

```bash
$ erlenv whence typer
r14b04
r15b01
riak-1.1.1
```


[sstephenson]: https://github.com/sstephenson
[rbenv]: https://github.com/sstephenson/rbenv
[MIT]: http://www.opensource.org/licenses/mit-license.html

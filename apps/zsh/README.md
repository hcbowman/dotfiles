# Zsh Startup/Shutdown Files

## Order of Operations

It reads first from the system-wide file `(i.e. /etc/zshenv)` then from the file in your home directory `(~/.zshenv)` as it goes through the following order.

`.zshenv` → `.zprofile (if login)` → `.zshrc (if interactive)` → `.zlogin (if login)` → `.zlogout (sometimes)`

## What should be used in ZSH on a Mac

I posted a more narrowly scoped question on [Unix & Linux][1] and got some clarification on how these files "work."  Here's the summary of that answer and what I've learned in my research as to what, *in my opinion* should be used in a ZSH environment on a Mac.

### .zshenv (Optional)

<sup>[Read every time]</sup>

**This is where you set environment variables.**  I say this is optional because is geared more toward advanced users where having your $PATH, $PAGER, or $EDITOR variables may be important for things like scripts that get called by `launchd`.  Those run under a non-interactive shell so anything in `.zprofile` or `.zshrc` won't get loaded.  Personally, I don't use this one because I set the PATH variable in my script itself to ensure portability.

*further reading*

This file is always sourced, so it should set environment variables which need to be **updated frequently**. `PATH` (or its associated counterpart `path`) is a good example because you probably don't want to restart your whole session to make it update. By setting it in that file, reopening a terminal emulator will start a new Zsh instance with the `PATH` value updated.

But be aware that this file is **read even when Zsh is launched to run a single command** (with the `-c` option), even by another tool like `make`. You should **be very careful to not modify the default behavior of standard commands** because it may break some tools (by setting aliases for example).

### .zprofile

<sup>[Read at login]</sup>

`.zlogin` and `.zprofile` are basically the same thing - **they set the environment for login shells**; they just get loaded at different times (see below).  `.zprofile` is based on the Bash's `.bash_profile` while `.zlogin` is a derivative of CSH's `.login`.  Since Bash was the default shell for everything up to Mojave, stick with `.zprofile`.

*further reading*

I personally treat that file like `.zshenv` but for commands and variables which should be set once or which **don't need to be updated frequently**:

* environment variables to configure tools (flags for compilation, data folder location, etc.)
* configuration which execute commands (like `SCONSFLAGS="--jobs=$(( $(nproc) - 1 ))"`) as it may take some time to execute.
  
If you modify this file, you can apply the configuration updates by running a login shell:

`exec zsh --login`

### .zshrc

<sup>[Read when interactive]</sup>

**This sets the environment for interactive shells**.  This gets loaded *after* `.zprofile`.  It's typically a place where you "set it and forget it" type of parameters like `$PATH`, `$PROMPT`, aliases, and functions you would like to have in both login *and* interactive shells.

I put here everything needed only for **interactive usage**:

* prompt,
* command completion,
* command correction,
* command suggestion,
* command highlighting,
* output coloring,
* aliases,
* key bindings,
* commands history management,
* other miscellaneous interactive tools (auto_cd, manydots-magic)...

### .zlogin

<sup>[Read at login]</sup>

This file is like .zprofile, but is read after .zshrc. You can consider the shell to be fully set up at .zlogin execution time. So, I use it to launch external commands which do not modify shell behaviors (e.g. a login manager).

### .zlogout (Optional)

<sup>[Read at logout][Within login shell]</sup>

Optional but very useful!  **This is read when you log out of a session** and is very good for cleaning things up when you leave (like resetting the Terminal Window Title), or any other resource which was setup at login.

For an excellent, in-depth explanation of what these files do, see [What should/shouldn't go in .zshenv, .zshrc, .zlogin, .zprofile,][2] on Unix/Linux.

## How I choose where to put a setting

* if it is needed by a **command run non-interactively**: `.zshenv`
* if it should be **updated on each new shell**: `.zshenv`
* if it runs a command which **may take some time to complete**: `.zprofile`
* if it is related to **interactive usage**: `.zshrc`
* if it is a **command to be run when the shell is fully setup**: `.zlogin`
* if it **releases a resource** acquired at login: `.zlogout`

## Some Caveats

Apple does things a little differently so it's best to be aware of this. Specifically, Terminal initially opens both a login and interactive shell even though you don't authenticate (enter login credentials). However, any subsequent shells that are opened are only interactive.

You can test this out by putting an alias or setting a variable in .zprofile, then opening Terminal and seeing if that variable/alias exists. Then open another shell (type zsh); that variable won't be accessible anymore.

SSH sessions are login and interactive so they'll behave just like your initial Terminal session and read both .zprofile and .zshrc

## Notes

* *If `ZDOTDIR` is unset, `HOME` is used instead.*
* *Files listed above as being in `/etc` may be in another directory, depending on the installation.*
* *As `/etc/zshenv` is run for all instances of zsh, it is important that it be kept as small as possible. In particular, it is a good idea to put code that does not need to be run for every single shell behind a test of the form `if [[ -o rcs ]]; then ...` so that it will not be executed when zsh is invoked with the `-f` option.*
* *setting $PATH in .zshenv - macOS, as of Big Sur and at least a few versions prior - overwrites any changes to $PATH when /etc/zprofile is executed (after .zshenv).*

## Files

```zsh
$ZDOTDIR/.zshenv
$ZDOTDIR/.zprofile
$ZDOTDIR/.zshrc
$ZDOTDIR/.zlogin
$ZDOTDIR/.zlogout
${TMPPREFIX}* (default is /tmp/zsh*)
/etc/zshenv
/etc/zprofile
/etc/zshrc
/etc/zlogin
/etc/zlogout (installation-specific - /etc is the default)
```

### Links

[ZSH: .zprofile, .zshrc, .zlogin - What goes where?](https://apple.stackexchange.com/questions/388622/zsh-zprofile-zshrc-zlogin-what-goes-where)

[What should/shouldn't go in .zshenv, .zshrc, .zlogin, .zprofile, .zlogout?](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout)

[zsh.sourceforge.io](https://zsh.sourceforge.io/Doc/Release/Files.html#Files)

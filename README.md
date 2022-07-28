# dotfiles

My standard configuration.

Usage:
```
cd ~
git clone git@github.com:RafDevX/dotfiles.git
cd dotfiles
stow NAME # repeat for compose, tmux, vim, etc.
```

## Packages

### Suckless
Suckless programs should not be installed through the package manager, but rather run:
```
$ git clone git://git.suckless.org/PACKAGE_NAME_HERE
$ cd dwm
$ make
# make install
```
for `dwm`, `slstatus` and `slock`.

### Commonly Installed Packages
Note these should be installed on a need-to-have basis.

```
paru -S ttf-font-awesome otf-font-awesome
```

<!-- TODO: table -->

## Git Configuration

Due to it differing from machine to machine, a git configuration file is not included. However, it should vaguely look like the following:

**In `~/.gitconfig`:**

```ini
[user]
	email = user@example.com
	name = John Doe
	signingkey = Dxxxxxxxxxxxxxx6

[core]
	whitespace = indent-with-non-tab,tabwidth=4,cr-at-eol

[credential]
	helper = cache --timeout=86400

[commit]
	gpgsign = true

[color]
	ui = auto

[url "git@github.com:"]
	pushInsteadOf = "https://github.com/"
```

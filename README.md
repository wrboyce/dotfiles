# dotfiles

## Requirements

Okay, so maybe not _pure_ `bash`… There are some caveats:

* If your `bash` version is less than 4.0, you need to have `zsh` installed (this should cover all based debian-esque and macOS machines).
* The following commands are expected to exist:
	* `tput`
	* `realpath`
	* `basename`
	* `dirname`
	* `ln`
	* `cp`
* And if you wish to use the `git` functionality:
	* `git`

## Strategies

#### Files

The default strategy for flat files is to symlink as per the naming convention for packages.

If the filename matches `*.git`, then the contents of the file will be treated as a git repository to be cloned to `~/.{name}`.

### Packages

Unless a directive file (`${path}/.dotfiles`) is specified the default action is `link` in which case a symlink will be created to the directory from `~/.{name}`.

If a directive file is specified, but no actions match due to filters, the fallback action is `skip`.

#### Symlink

Directive: `link`

The default action _if no dirctive file is defined_, will link the to the package directory from `~/.${name}`, overwriting any existing symlinks.

#### Skip

Directive: `skip`

The default action if a directive file is defined but no matching directive is found, will perform no action.

#### Copy Files

Directive: `copyfiles`

Copies all children (recursively) following the `link` naming convention. If the directive is specified as `copyfiles=${dest}` then the custom destination will be used when copying files.

#### Scripts

Directive: `exec`

Executes a set of files given the current command being processed, possible commands are `install` and `update`.

In order, the files processed are:

* `exec`
* `${command}`
* `post${command}`

#### Modules

Directive: `mod`

Modules are the most complex form of package, allowing for multiple forms of exec-type actions, and complete control over the `status` output. Additionally, git repository suport is baked in.

If `repo` file exists it must contain the git remote to be cloned into `$HOME` following the standard `link` naming procedure.

After cloning the following files will be executed (during `install`/`update`):

* `exec`
* `${command}`
* `post${command}`

### Filters

In addition to actions, a directive file may also specify filters. This allows a package to behave differently depending on the current `hostname` or `os`.

Filters are defined on the lines preceeding an action, and apply only to the action immediately following them. Filters are chained, meaning all filters are joined with an `AND` before deciding if the following action will be accepted.

Filters are evaluated top-to-bottom and only the last matching action will be honoured.

#### Hostname

`hostname` matches are performed against the fully qualified domain as a glob.

```
hostname=web*.example.com
link
```

#### OS

When filtering by `os` valid values are `freebsd`, `linux`, and `macos`.

```
os=linux
link
```

#### Filter Chaining

Filters are chained with an `AND` operator, meaning that multiple filters may be applied to a single action.

#### Filter Examples

Perform the `link` action only on macOS machines:

```
os=macos
link
```

Perform the `exec` action only on `host1` and `host2`:

```
hostname=host1.*
exec
hostname=host2.*
exec
```

Perform the `copy` action on `example.com` machines running `linux` and perform the `link` action on all other machines:

```
link
os=linux
hostname=*.example.com
copy
```

Perform `mod` actions on all machines except `freebsd`:

```
mod
os=freebsd
skip
```

## Bootstrapping

`dotfiles` can also handle initial bootstrap of machines. These commands are opt-in using the `DOTFILES_BOOTSTRAP` env var, which should be `true` if bootstrapping is desired.

If the `BOOTSTRAP_HOSTNAME` variable is provided, it should be a fqdn describing the machine's desired network identification and the machine will be configured appropritely (**NB**: currently macOS only).

Installation can be additionally customised using the following env vars:

* `DOTFILES_HOME` -- dictates where this repo is stored, default: ~/.dotfiles
* `GITHUB_USERNAME` -- used in cloning the dotfiles repo, default: $(whoami)
* `DOTFILES_REPO` -- defaults to `git@github.com:${GITHUB_USERNAME}/dotfiles`

```
$ BOOTSTRAP_HOSTNAME=foo.example.com curl https://raw.githubusercontent.com/wrboyce/dotfiles/master/bin/dotfiles | bash
```

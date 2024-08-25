# ZPack

<p align="center">

<img src="https://www.svgrepo.com/download/236716/package-box.svg" height="130">

A simple Zsh manager for all your needs.

<img src="https://img.shields.io/github/v/release/rneacsu5/zpack?style=flat">
<img src="https://img.shields.io/github/stars/rneacsu5/zpack?style=flat">
<img src="https://img.shields.io/github/downloads/rneacsu5/zpack/total?style=flat">
<img src="https://img.shields.io/github/contributors/rneacsu5/zpack?style=flat">
<img src="https://img.shields.io/github/license/rneacsu5/zpack?style=flat">


</p>

## Table of Contents

* [Background](#background)
* [Getting started](#getting-started)
* [Commands](#commands)
  * [`zpack load`](#zpack-load)
  * [`zpack snippet`](#zpack-snippet)
  * [`zpack release`](#zpack-release)
  * [`zpack bin`](#zpack-bin)
  * [`zpack omz`](#zpack-omz)
  * [`zpack bundle`](#zpack-bundle)
  * [`zpack apply`](#zpack-apply)
  * [`zpack update`](#zpack-update)
  * [`zpack reset`](#zpack-reset)
  * [`zpack prune`](#zpack-prune)
  * [`zpack help`](#zpack-help)
  * [`zpack list`](#zpack-list)
  * [`zpack stats`](#zpack-stats)
* [License](#license)

## Background

This project was created mainly because I needed a ZSH plugin manager that satisfies the following requirements:

* have the entire configuration in `.zshrc`
* the configuration is easy to read and understand
* can install binaries from GitHub Releases
* can load [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) plugins and libraries
* can load scripts from URLs
* is simple to maintain and extend

After testing a couple of existing managers I couldn't find one that satisfied all the requirements, was maintained and worked with the plugins I am using. Therefore, I decided to create my own. It was also a good opportunity to learn more about Zsh.

It is heavily inspired from [zgenom](https://github.com/jandamm/zgenom) which in turn is an extension of [zgen](https://github.com/tarjoilija/zgen) which was in turn inspired by [Antigen](https://github.com/zsh-users/antigen). I also took some bits from [zinit](https://github.com/zdharma-continuum/zinit). All credits go to the respective authors and contributors.

In terms of speed is as fast as it gets once the initial setup is done and all plugins are downloaded and cached. Changing the configuration invalidates the cache and takes longer to apply, but realistically you will only want to do this pretty rarely. Therefore, when not using the cache, the code is optimised for readability and maintainability. Otherwise, it is optimised for speed.

## Getting started

Add the following lines to `~/.zshrc`:

```shell
# Init zpack
[[ -d "${HOME}/.zpack" ]] || git clone https://github.com/rneacsu5/zpack.git "${HOME}/.zpack"
source "${HOME}/.zpack/zpack.zsh"
```

Load plugins, releases, snippets and predefined bundles:

```shell
# ohmyzsh libraries, required by most plugins
zpack omz lib/history.zsh
zpack omz lib/directories.zsh
zpack omz lib/completion.zsh
zpack omz lib/theme-and-appearance.zsh

# ohmyzsh plugins
zpack omz plugins/git
zpack omz plugins/sudo
zpack omz plugins/docker
zpack omz plugins/docker-compose
zpack omz plugins/kubectl

# Download binary from GitHub Releases and add to path
zpack release junegunn/fzf

# Load script from url
zpack snippet https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh

# Install binary and also generate completions
zpack release dandavison/delta --completion 'delta --generate-completion zsh > _delta'

# Add script from url as binary an make it available in path
zpack snippet --bin https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell

# Load regular plugins
zpack load zsh-users/zsh-autosuggestions
zpack load zsh-users/zsh-completions
zpack load zsh-users/zsh-syntax-highlighting

# Also execute script after plugin load
zpack load zsh-users/zsh-history-substring-search --after-load '
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
'

# Or you can install all of the above zsh-users plugins using a predefined bundle
# zpack bundle zsh-users

# Load theme
zpack load romkatv/powerlevel10k::powerlevel10k --after-load '
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
'
```

At the end make sure you apply the configuration using the following:

```shell
# Finally, apply all changes and initialise completion system
zpack apply
```

You can also check out my [dotfiles](https://github.com/rneacsu5/dotfiles) for a working configuration.

In order to avoid a warning about completions already initialised, please make sure you have the following in `~/.zshenv`:

```shell
# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1
```

## Commands

For all available commands, please run `zpack help`. Also check out the completions for command flags. The main ones are described below:

### `zpack load`

Loads a plugin. It takes one argument which is the repository or location of the plugin to load. Accepted formats are:

```shell
zpack load <author>/<repo> # Loads https://github.com/<author>/<repo>
zpack load <author>/<repo>@<branch> # Loads https://github.com/<author>/<repo> at branch/tag <branch>
zpack load <author>/<repo>::<location> # Loads https://github.com/<author>/<repo> at location <location>
zpack load <author>/<repo>@<branch>::<location> # Loads https://github.com/<author>/<repo> at branch/tag <branch> and location <location>
zpack load ./path/to/plugin # Loads plugin from local path
zpack load /absolute/path/to/plugin # Loads plugin from absolute path
```

It does the following:

1. download the plugin if it's not already downloaded
1. add the `functions` directory to `fpath` if it exists, otherwise the plugin's directory is added
1. find and load the plugin's entry point using common patterns.
1. add the `bin` directory to `PATH` if it exists

The following flags can be used:

* `--completion` - only add to `fpath` and do not load the plugin. Useful when you only want to load completions.
* `--before-load` - a command to execute before the plugin is loaded
* `--after-load` - a command to execute after the plugin is loaded

### `zpack snippet`

Loads a script from a URL. It takes one argument which is the URL of the script to load.

The following flags can be used:

* `--bin` - treat downloaded file as a binary and make available in `PATH`
* `--completion` - only add to `fpath` and do not load the script

### `zpack release`

Downloads a binary from GitHub Releases and adds it to `PATH`. It takes one argument which is the repository in the format `<author>/<repo>`. The following flags can be used:

* `--completion` - generate completions for the binary. The argument is the command to run to generate completions. You can use the binary itself to generate completions. The script should generate the `_command` file in the current directory.
* `-p, --pattern` - assets are automatically filtered by the current OS and platform and the first one is downloaded. Use this flag to specify a pattern to further filter the assets.
* `-f, --filter` - when downloading an archive with multiple files the command tries to automatically find the correct binary. Use this flag to specify a filter to find the correct file to use.
* `-n, --name` - specify the name of the binary to use. By default, the name is the same as the repository name, but it can be different in some cases (e.g. `flux` for `fluxcd/flux2`). Use this flag to specify the name of the final binary.
* `-l, --list` - list all available assets for the repository. Useful for finding the correct asset to download.

### `zpack bin`

Loads binaries to `PATH`. Generally is usually used internally by the other commands, but can also be used to make certain scripts from repositories available in `PATH`. It takes one argument which is the repository in the same format as `zpack load`.

The following flags are available:

* `-n, --name` - specify the name of the final binary added to `PATH`.

### `zpack omz`

Loads Oh My Zsh plugins and libraries. It is a wrapper around `zpack load` which also creates the necessary directories and environment variables for Oh My Zsh plugins to work. The accepted formats are:

```shell
zpack omz plugins/<plugin>
zpack omz lib/<library>.zsh
```

The same flags as `zpack load` can be used.

### `zpack bundle`

Loads a predefined bundle of one or more plugins, along with their configuration. Used to set up popular configurations without cluttering the `.zshrc` file. It takes one argument (the name of the bundle) and zero or more flags, depending on the bundle. Some of the available bundles are:

* `omz-lib` - load a predefined list of useful Oh My Zsh libraries
* `zsh-users` - loads [`zsh-users/zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions), [`zsh-users/zsh-completions`](https://github.com/zsh-users/zsh-completions), [`zsh-users/zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) and [`zsh-users/zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search) (with up/down arrows key bindings)
* `powerlevel10k` - loads [`romkatv/powerlevel10k`](https://github.com/romkatv/powerlevel10k) theme
* `zoxide` - installs and loads [`ajeetdsouza/zoxide`](https://github.com/ajeetdsouza/zoxide) binary and completions. Use the `--cmd` flag to specify the command for running `zoxide`, defaults to `z`
* `fzf` - installs [`junegunn/fzf`](https://github.com/junegunn/fzf) and configures `Ctrl+R`, `Ctrl+T` and `Alt+C` key bindings with files and directories previews. Set the `--tab` flag to also install the [`Aloxaf/fzf-tab`](https://github.com/Aloxaf/fzf-tab) plugin.

To see all the available bundles, run `zpack bundle`.

### `zpack apply`

Applies all changes made by the previous commands. This should be the last `zpack` related command in the `.zshrc` file. This initialises the completion system and caches the resulting configuration for future use.

### `zpack update`

Updates the manager and all plugins, snippets and releases to the latest version. It takes one optional argument which controls what to update:

```shell
zpack update # updates everything
zpack update all # same as above
zpack update self # updates only the manager
zpack update plugins # updates only the plugins, snippets and releases
```

### `zpack reset`

Clears the cache entirely and restarts the shell. Usually this should not be needed, but on certain occasions it might be helpful in order to fix some completions or previous errors.

### `zpack prune`

Completely delete everything and start from scratch. This also deletes any downloaded plugins, binaries etc and stars fresh. Useful when you have a lot of previously downloaded plugins that you no longer need.

### `zpack help`

Shows available commands.

### `zpack list`

List all plugins, snippets, binaries and bundles that are currently loaded.

### `zpack stats`

Display current shell statistics, like number of plugins, load time, cache and completion system status. Useful for discovering plugins which slow down the shell startup.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

# zpack

A simple Zsh framework for all your needs.

It is heavily inspired from [zgenom](https://github.com/jandamm/zgenom) which in turn is an extension of [zgen](https://github.com/tarjoilija/zgen) which was in turn inspired by [Antigen](https://github.com/zsh-users/antigen). All credits go to the respective authors and contributors.

The goal was to have a simple to use manager for Zsh plugins, [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) libraries and plugins, but also GitHub Releases and snippets without manual installation or a complicated `.zshrc`.

Note that despite it being simple, it is not necessarily fast. In my testing, having different configurations and plugins loaded affects the final performance significantly. Also, this was my first interaction with Zsh and Zsh frameworks in general, and testing was limited to my configuration, so use it on your own risk.

## Getting started

Add the following lines to `~/.zshrc`:

```shell
# Init zpack
[[ -d "${HOME}/.zpack" ]] || git clone https://github.com/originalnexus/zpack.git "${HOME}/.zpack"
source "${HOME}/.zpack/zpack.zsh"
```

Load plugins, releases, snippets and predefined bundles:

```shell
# ohmyzsh libraries, required by most plugins
zpack omz lib/git.zsh
zpack omz lib/history.zsh
zpack omz lib/directories.zsh
zpack omz lib/completion.zsh
zpack omz lib/vcs_info.zsh
zpack omz lib/prompt_info_functions.zsh
zpack omz lib/key-bindings.zsh
zpack omz lib/theme-and-appearance.zsh

# Or install all of the above using a predefined bundle
# zpack bundle omz-lib

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
zpack release fluxcd/flux2  --completion 'flux completion zsh > _flux'

# Add script from url as binary an make it available in path
zpack snippet --bin https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell

# Load regular plugins
zpack load zsh-users/zsh-autosuggestions
zpack load zsh-users/zsh-completions
zpack load zsh-users/zsh-syntax-highlighting

# Also execute script after plugin load
zpack load zsh-users/zsh-history-substring-search --after-load '
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
'

# Or you can install all of the above zsh-users plugins using a predefined bundle
# zpack bundle zsh-users

# Load theme
zpack load romkatv/powerlevel10k powerlevel10k --after-load '
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
'

# Finally, apply all changes and initialise completion system
zpack apply

```

You can also check out my [dotfiles](https://github.com/OriginalNexus/dotfiles) for a working configuration.

In order to avoid a warning about completions already initialised, please make sure you have the following in `~/.zshenv`:

```shell
# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1
```

## Commands

For available commands, please run `zpack help`. Also check out the completions for command flags.

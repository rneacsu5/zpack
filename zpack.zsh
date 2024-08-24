# ZPack variables
ZPACK_DIR="$0:A:h"
ZPACK_PLUGINS_DIR="$ZPACK_DIR/plugins"
ZPACK_RELEASES_DIR="$ZPACK_DIR/releases"
ZPACK_SNIPPETS_DIR="$ZPACK_DIR/snippets"
ZPACK_FUNCTIONS_DIR="$ZPACK_DIR/functions"
ZPACK_BIN_DIR="$ZPACK_DIR/bin"
ZPACK_CACHE_DIR="$ZPACK_DIR/cache"
ZPACK_CACHE_FILE="$ZPACK_CACHE_DIR/zpack"
ZPACK_COMPDUMP_PATH="$ZPACK_CACHE_DIR/zcompdump_$ZSH_VERSION"

# Init ZPack
fpath=($ZPACK_FUNCTIONS_DIR $fpath)
autoload -Uz __zpack_init && __zpack_init

function zpack() {
    local cmd=$1

    if [[ -n $ZPACK_CACHE ]]; then
        [[ $cmd == apply ]] && __zpack_apply
        return 0
    fi

    # Load all ZPack functions
    if [[ ${+functions[zpack-help]} == 0 ]]; then
        setopt localoptions extendedglob
        autoload -Uz $ZPACK_FUNCTIONS_DIR/zpack-*~*.zwc $ZPACK_FUNCTIONS_DIR/__zpack_*~*.zwc
    fi

    if [[ -z $cmd || $cmd = '--help' || $cmd = '-h' ]]; then
        zpack-help
    elif [[ ${+functions[zpack-$cmd]} == 1 ]] ; then
        shift
        zpack-$cmd $@
    else
        __zpack_err "Command not found: '$cmd'"
        __zpack_err "Run 'zpack help' to list avaiable command"
        return 1
    fi
}

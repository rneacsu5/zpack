# ZPack variables
ZPACK_DIR="$0:A:h"
ZPACK_PLUGINS_DIR="$ZPACK_DIR/plugins"
ZPACK_RELEASES_DIR="$ZPACK_DIR/releases"
ZPACK_SNIPPETS_DIR="$ZPACK_DIR/snippets"
ZPACK_BIN_DIR="$ZPACK_DIR/bin"
ZPACK_CACHE_DIR="$ZPACK_DIR/cache"
ZPACK_COMPDUMP_PATH="$ZPACK_CACHE_DIR/zcompdump_$ZSH_VERSION"

# Load zpack functions
fpath=($ZPACK_DIR/functions $fpath)
(){
    setopt localoptions extendedglob
    for func in $ZPACK_DIR/functions/zpack-*~*.zwc $ZPACK_DIR/functions/__zpack_*~*.zwc; do
        autoload -Uz ${func:t}
    done
}
__zpack_init

function zpack() {
    local cmd=$1

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

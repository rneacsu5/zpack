# ZPack variables
typeset -gA ZPACK
ZPACK[dir]="$0:A:h"
ZPACK[plugins_dir]="${ZPACK[dir]}/plugins"
ZPACK[releases_dir]="${ZPACK[dir]}/releases"
ZPACK[snippets_dir]="${ZPACK[dir]}/snippets"
ZPACK[functions_dir]="${ZPACK[dir]}/functions"
ZPACK[bin_dir]="${ZPACK[dir]}/bin"
ZPACK[cache_dir]="${ZPACK[dir]}/cache"
ZPACK[cache_file]="${ZPACK[cache_dir]}/zpack"
ZPACK[compdump_path]="${ZPACK[cache_dir]}/zcompdump_$ZSH_VERSION"

# Init ZPack
fpath=(${ZPACK[functions_dir]} $fpath)
autoload -Uz __zpack_init && __zpack_init

function zpack() {
    local cmd=$1

    if [[ -n ${ZPACK[cache]} ]]; then
        [[ $cmd == apply ]] && __zpack_apply
        return 0
    fi

    # Load all ZPack functions
    if [[ ${+functions[zpack-help]} == 0 ]]; then
        setopt localoptions extendedglob
        autoload -Uz ${ZPACK[functions_dir]}/zpack-*~*.zwc ${ZPACK[functions_dir]}/__zpack_*~*.zwc
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

#!/usr/bin/echo Source this file.
_THIS=$(basename "$0")
_HOSTNAME=$(hostname)
_STDBASH_VERSION="0.0.1"

##
## Print params as error, then exit -1
##
function stdbash::error
{
    [ $# -gt 0 ] && printf "$(date -Isec -u) ${_HOSTNAME} ${_THIS}:\tERROR: ${@:1}\n"
    exit -1
}

function stdbash::warn
{
    [ $# -gt 0 ] && printf "$(date -Isec -u) ${_HOSTNAME} ${_THIS}\tWARNING: ${@:1}\n"
}

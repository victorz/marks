#!/usr/bin/zsh

export MARKSPATH=${MARKSPATH:-$HOME/.marks}

# Jump *to* a mark.
# No argument is the same as `cd`.
# If the argument is a valid directory, cd to it. (If "-", cd to prev. dir.)
# If the argument is a mark, cd to that. Otherwise bail.
function to {
    [[ -z "$1" ]] && cd && return
    [[ -d "$1" || "$1" == "-" ]] && cd "$1" && return
    cd -P "$MARKSPATH/$1" 2> /dev/null || \
        echo "$0: no such mark or directory: $1" 1>&2
}

# Save a mark.
# Zero arguments marks the current directory.
# One argument gives it a name (perhaps different from the mark's basename).
# With two arguments, the first argument explicitly specifies the directory.
function mark {
    local src_dir=${2:+$(realpath $1)}
    src_dir=${src_dir:-$PWD}
    local mark_name=${2:-${1:-$(basename "$src_dir")}}

    if [[ -e "$MARKSPATH/$mark_name" ]]
    then
        echo "$0: mark exists: $mark_name" 1>&2
    elif [[ -d "$src_dir" ]]
    then
        echo "new mark: $mark_name -> $src_dir"

        \mkdir -p "$MARKSPATH"
        \ln -s "$src_dir" "$MARKSPATH/$mark_name"
    else
        echo "$0: not a directory: $src_dir" 1>&2
    fi
}

# Remove one or more marks.
function rmmark {
    [[ $# -eq 0 ]] && echo "usage: $0 MARK..." 1>&2 && return

    for mark in "$@"
    do
        if [[ ! -e $MARKSPATH/$mark ]]
        then
            echo "$0: no such mark: $mark" 1>&2
        else
            \rm $MARKSPATH/$mark && echo "removed mark: $mark"
        fi
    done
}

# List all marks and which directory they each reference.
function marks {
    setopt localoptions nullglob

    local marks=("$MARKSPATH"/*)
    [[ ${#marks} -eq 0 ]] && echo "No bookmarks." && return

    for mark in "${marks[@]}"
    do
        echo $(basename "$mark") '->' $(readlink "$mark")
    done
}

# Completion function for the `to` and `rmmark` commands.
# TODO: complete second argument as subdirectory of mark.
# TODO: complete regular expressions?
function complete_marks {
    setopt localoptions nullglob

    for m in "$MARKSPATH"/*
    do
        reply+=($(basename "$m"))
    done
}

# Add marks completion to commands `to` and `rmmark`.
# TODO: use new completion system instead of old one.
# TODO: use directory completion for second argument of `mark` command.
compctl -K complete_marks to
compctl -K complete_marks rmmark

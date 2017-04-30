#!/usr/bin/zsh

export MARKPATH=$HOME/.marks

# Jump *to* a mark.
# No argument is the same as `cd`.
# If the argument is a valid directory, cd to it. (If "-", cd to prev. dir.)
# If the argument is a mark, cd to that. Otherwise bail.
function to {
    [[ -z "$1" ]] && cd && return
    [[ -d "$1" || "$1" == "-" ]] && cd "$1" && return
    cd -P "$MARKPATH/$1" 2> /dev/null || echo "$0: no such mark or directory: $1" 1>&2
}

# Save a mark.
# Zero arguments marks the current directory.
# One argument gives it a name (perhaps different from the mark's basename).
# With two arguments, the second argument explicitly specifies the directory.
function mark {
    local mark_name="$1"
    local src_dir="${2:-$PWD}"

    if [[ -d "$src_dir" ]]
    then
        \mkdir -p "$MARKPATH"
        \ln -s "$src_dir" "$MARKPATH/$mark_name"
    else
        echo "Not a directory: $1" 1>&2
    fi
}

# Remove one or more marks.
function rmmark {
    [[ $# -eq 0 ]] && echo "usage: $0 MARK..." 1>&2 && return

    for mark in "$@"
    do
        if [[ ! -e $MARKPATH/$mark ]]
        then
            echo "$0: no such mark: $mark" 1>&2
        else
            \rm $MARKPATH/$mark && echo "removed mark: $mark"
        fi
    done
}

# List all marks and which directory they each reference.
function marks {
    setopt localoptions nullglob

    local marks=("$MARKPATH"/*)
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

    for m in "$MARKPATH"/*
    do
        reply+=($(basename "$m"))
    done
}

# Add marks completion to commands `to` and `rmmark`.
# TODO: use new completion system instead of old one.
# TODO: use directory completion for second argument of `mark` command.
compctl -K complete_marks to
compctl -K complete_marks rmmark

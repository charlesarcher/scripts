#!/usr/bin/env bash
#
#   Show a side-by-side diff of a particular file how it currently exists between:
#       * the file system
#       * in HEAD (latest committed changes)

function usage() {
        cat <<EOF
-HERE
    USAGE

    $(basename $1) <file>

    Show a side-by-side diff of a particular file between the current versions:

        * on the file system (latest edited changes)
        * in HEAD (latest committed changes)

HERE
}

if [[ $# = 0 ]]; then
    usage $0
    exit
fi

file=$1
diff -y =(git show HEAD:$file) $file | pygmentize -g | less -R
EOF

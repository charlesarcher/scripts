#!/bin/sh

git grep $1 | cut -d: -f1 | sort | uniq | xargs perl -p -i -e "s/$1/$2/g"

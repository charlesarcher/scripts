#!/bin/sh
for x in y; do
    fixws =!"\
    if (! git diff-index --quiet --cached HEAD); then \
    \
    git diff-files --quiet `git rev-parse --show-toplevel` ; \
    export NEED_TO_STASH=$? ; \
    \
    git commit -m FIXWS_SAVE_INDEX && \
    if [ 1 = $NEED_TO_STASH ] ; then git stash save FIXWS_SAVE_TREE; fi && \
    git rebase --whitespace=fix HEAD~ && \
    git reset --soft HEAD~ && \
    if [ 1 = $NEED_TO_STASH ] ; then git stash pop; fi ; \
  fi"
done

#!/bin/sh

export UUIDGEN=$(echo -n $UUIDGEN);
export GCOV_PREFIX=/home/cjarcher/gcov/$UUIDGEN/$PMI_RANK
export GCOV_PREFIX_STRIP=0

#echo "$GCOV_PREFIX"

$*

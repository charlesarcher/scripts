#!/bin/sh

set +bm

if [ -z "${PMI_RANK}" ]; then
    PMI_RANK=${OMPI_COMM_WORLD_RANK}
fi


TOOL="xterm -sl 50000 -T ${PMI_RANK} -e gdb"
#TOOL="xterm -sl 50000 -T ${PMI_RANK} -e valgrind --tool=memcheck --malloc-fill=0xFF --free-fill=0xFF --leak-check=full  --leak-resolution=high --num-callers=40 --show-leak-kinds=all --track-origins=yes --fair-sched=yes"
#TOOL="PYTHONPATH=/home/cjarcher/tools/x86/lib/python2.7/site-packages xterm -T ${PMI_RANK} -e lldb"
cmd="${TOOL} $*"

eval $cmd

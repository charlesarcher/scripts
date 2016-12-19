#!/bin/sh

NSOCKETS=2
NCPUS_PER_SOCKET=10
NTHREADS_PER_CPU=2
SOCKETS_TO_USE=1

let num_hwthreads="${NSOCKETS} * ${NCPUS_PER_SOCKET} * ${NTHREADS_PER_CPU}"
let num_cpus="${NCPUS_PER_SOCKET} * ${NTHREADS_PER_CPU}"
let skip_by="${NTHREADS_PER_CPU}"

#let core_id="${PMI_RANK} % 

AFFINITY="$affinity,$affinity2"

echo $AFFINITY

taskset -c ${AFFINITY} $*


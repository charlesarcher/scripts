#!/bin/sh
#. /opt/intel/bin/compilervars.sh intel64
. /opt/intel/bin/compilervars.sh intel64

#export TEMP=/home/cjarcher/temp
export TEMP=/scratch/cjarcher/temp
SOURCE=osu_put_latency_mark.c
MPIBASE=/home/cjarcher/code/mpich/../install/intel/optimized-adi-inline-ts
MPIBASE=/home/cjarcher/code/mpich/../install/intel/optimized-ofi-ts-inline-ep-dynamic-ctree-ctspmpich
OTHERBASE=/home/cjarcher/code/install/intel/ofi
#GOOD!
#LIMITS=10000
#INSTANCES_ROUTINE=200000
#INSTANCES_COMPILE=1000000
LIMITS=15000
INSTANCES_ROUTINE=200000
INSTANCES_COMPILE=1000000
icc -I${MPIBASE}/include                 \
    -L${MPIBASE}/lib64                   \
    -L${MPIBASE}/lib                     \
    -L${OTHERBASE}/lib64                 \
    -L${OTHERBASE}/lib                   \
    -O3                                  \
    -DNDEBUG                             \
    -ipo -z muldefs                      \
    -no-inline-factor                    \
    -inline-forceinline                  \
    -inline-max-size=${LIMITS}           \
    -inline-min-size=0                   \
    -inline-max-total-size=${LIMITS}     \
    -inline-max-per-routine=${INSTANCES_ROUTINE} \
    -inline-max-per-compile=${INSTANCES_COMPILE} \
    -qopt-report-routine=main            \
    -qopt-report-file=out.out            \
    -qopt-report-phase=ipo               \
    -qopt-report=5                       \
    ${SOURCE} -o osu_put_latency_mark    \
    -Wl,-rpath -Wl,${MPIBASE}/lib        \
    -Bstatic -Wl,--whole-archive -lmpi  -Wl,--no-whole-archive -Bdynamic -lfabric  -lpsm_infinipath -linfinipath -lrt -lpthread 2>&1 | tee file.out

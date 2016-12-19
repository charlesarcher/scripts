#!/bin/sh
#. /opt/intel/bin/compilervars.sh intel64
. /opt/intel/composer_xe_2015.3.187/bin/compilervars.sh intel64

#export TEMP=/home/cjarcher/temp
export TEMP=/work/cjarcher/temp
SOURCE=flood.c
COMPILER=intel

#MPI=optimized-am_ofi-ts-noinline-ep-direct-dynamic-dynamic
#MPI=optimized-shm-ts-noinline-ep-direct-dynamic-dynamic
#MPI=optimized-ofi-ts-noinline-ep-direct-dynamic-dynamic
MPI=optimized-ofi-ts-inline-ep-dynamic-map-disabled
MPI=optimized-ofi-ts-inline-ep-dynamic-static-map-disabled
MPIBASE=/home/cjarcher/code/install/${COMPILER}/${MPI}
OTHERBASE=/home/cjarcher/code/install/${COMPILER}/ofi

icc -I${MPIBASE}/include                 \
    -L${MPIBASE}/lib64                   \
    -L${MPIBASE}/lib                     \
    -L${OTHERBASE}/lib64                 \
    -L${OTHERBASE}/lib                   \
    -O3                                  \
    -xCORE-AVX2 -fma                     \
    -DNDEBUG                             \
    -ipo-separate                        \
    -inline-factor=10000                 \
    -inline-min-size=0                   \
    -qopt-report-routine=main            \
    -qopt-report-file=out.out            \
    -qopt-report-phase=ipo               \
    -qopt-report=5                       \
    ${SOURCE} -o flood                   \
    -Wl,-rpath -Wl,${MPIBASE}/lib        \
    -Bstatic -Wl,--whole-archive -lmpi -lfabric -Wl,--no-whole-archive -Bdynamic -lpsm_infinipath -linfinipath -lrt -lpthread -luuid 2>&1 | tee file.out
#    -Bstatic -Wl,--whole-archive -lmpi -lfabric -Wl,--no-whole-archive -Bdynamic -lportals -lev -libverbs -lrdmacm -lrt -lpthread 2>&1 | tee file.out

#    -inline-forceinline                  \


#LIMITS=15000
#INSTANCES_ROUTINE=200000
#INSTANCES_COMPILE=10000000
#    -inline-level=2                  \
#    -no-inline-factor                \
#    -inline-max-size=${LIMITS}              \
#    -inline-min-size=${LIMITS}              \
#    -inline-max-total-size=${LIMITS}        \
#objs/*.ilo objs/*.ilo
#objdump -DS ./flood | grep MPI_Put
#objdump -DS ./flood | grep MPI_Send
#    -inline-max-per-routine=10000000 \
#    -inline-max-per-compile=10000000 \
#    -no-inline-max-size        \
#    -no-inline-min-size        \
#    -no-inline-max-total-size  \
#    -no-inline-max-per-routine \
#    -no-inline-max-per-compile \

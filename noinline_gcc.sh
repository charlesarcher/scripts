#!/bin/sh
. /opt/intel/bin/compilervars.sh intel64

if [ -e /opt/rh/devtoolset-3/enable ]; then
    . /opt/rh/devtoolset-3/enable
fi

export TEMP=/home/cjarcher/temp
SOURCE=flood.c
COMPILER=gnu

MPI=optimized-ofi-ts-inline-ep-dynamic-map-disabled
MPI=optimized-ofi-ts-inline-ep-dynamic-static-map-enabled
MPI=optimized-ofi-ts-inline-ep-dynamic-dynamic-map-enabled
MPIBASE=/home/cjarcher/code/install/${COMPILER}/${MPI}
OTHERBASE=/home/cjarcher/code/install/${COMPILER}/ofi


gcc -I${MPIBASE}/include                 \
    -L${MPIBASE}/lib64                   \
    -L${MPIBASE}/lib                     \
    -L${OTHERBASE}/lib64                 \
    -L${OTHERBASE}/lib                   \
    -O3                                  \
    -march=haswell                       \
    -DNDEBUG                             \
    -flto                                \
    -fuse-linker-plugin                  \
    ${SOURCE} -o flood                   \
    -Wl,-rpath -Wl,${MPIBASE}/lib        \
    -Wl,-rpath -Wl,${OTHERBASE}/lib      \
    -Wl,-Bstatic -lmpi -lstdc++ -Wl,-Bdynamic -lfabric -lrt -lpthread 2>&1 | tee file.out

    #    -Wl,-Bstatic -lmpi -lstdc++ -lfabric -Wl,-Bdynamic -lrt -lpthread -ldl -luuid 2>&1 | tee file.out
    #    -Wl,-Bstatic -lmpi -lstdc++ -Wl,-Bdynamic -lfabric -lrt -lpthread 2>&1 | tee file.out
    #    -Wl,-Bstatic -lmpi -lstdc++ -Wl,-Bdynamic -lrt -lpthread -ldl -luuid 2>&1 | tee file.out


#    -Wl,-Bstatic -lmpi -lstdc++ -Wl,-Bdynamic -lfabric -lpsm_infinipath -linfinipath -lrt -lpthread 2>&1 | tee file.out
#    -flto-report                         \

#!/bin/sh
. /opt/intel/bin/compilervars.sh intel64
#. /opt/intel/composer_xe_2013_sp1.2.144/bin/compilervars.sh intel64
#. /opt/intel/composer_xe_2013.5.192/bin/compilervars.sh intel64
#SOURCE=osu_put_latency_mark.c
SOURCE=simple_get.c
#    -Winline                                             \

icc -I/home/cjarcher/code/mpich/../install/intel/include \
    -I/home/cjarcher/code/mpich/../install/intel/include \
    -L/home/cjarcher/code/mpich/../install/intel/lib64   \
    -L/home/cjarcher/code/mpich/../install/intel/lib     \
    -L/home/cjarcher/code/mpich/../install/intel/lib64   \
    -L/home/cjarcher/code/mpich/../install/intel/lib     \
    -L/home/cjarcher/code/mpich/../install/intel/lib     \
    -O3                                                  \
    -ipo -z muldefs                                      \
    -DNDEBUG                                             \
    -finline-limit=2097152                               \
    -no-inline-factor                                    \
    -inline-max-per-routine=10000000                     \
    -inline-max-per-compile=10000000                     \
    -opt-report-file=out.out                             \
    -opt-report-phase=ipo                                \
    -opt-report-routine=main                             \
    ${SOURCE} -o simple_get                                   \
    -Wl,-rpath -Wl,/home/cjarcher/code/mpich/../install/intel/lib \
    -Bstatic -lsma  -lfabric -lportals -lev -Bdynamic -libverbs -lrdmacm -lrt -lpthread -lportals_runtime 2>&1 | tee file.out

#objdump -DS ./flood | grep MPI_Put
#objdump -DS ./flood | grep MPI_Send

#    -no-inline-max-size        \
#    -no-inline-min-size        \
#    -no-inline-max-total-size  \
#    -no-inline-max-per-routine \
#    -no-inline-max-per-compile \

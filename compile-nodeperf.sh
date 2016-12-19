#!/bin/sh
. /opt/intel/bin/compilervars.sh intel64

icc -O3 -DNOMPI nodeperf.c \
    -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_lp64.a \
    $MKLROOT/lib/intel64/libmkl_core.a \
    $MKLROOT/lib/intel64/libmkl_intel_thread.a \
    /opt/intel/composer_xe_2015.0.090/compiler/lib/intel64/libiomp5.a \
    -Wl,--end-group -lpthread -lm  -o nodeperf-static


icc -O3 -DNOMPI nodeperf.c -L${MKLROOT}/lib/intel64 \
   -lmkl_intel_lp64 -lmkl_core -lmkl_intel_thread \
   -lpthread -lm  -DMKL_LP64 -openmp -o nodeperf-dynamic

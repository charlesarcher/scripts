#!/bin/sh

rank=${PMI_RANK}
if [ ${rank} -eq 0 ] ; then
echo "Tracing on rank ${rank}"
/opt/intel/sde/sde64 \
    -pinlit2                  \
    -debugtrace               \
    -start_ssc_mark 200:1     \
    -stop_ssc_mark  210:1     \
    -log:mt                   \
    -log:focus_thread 1       \
    -dt_lines                 \
    -dt_flush                 \
    -dt_symbols 1             \
    -length 2000000000        \
    -- ./osu_put_latency_mark
else
echo "Not Tracing on rank ${rank}"
./osu_put_latency_mark
fi

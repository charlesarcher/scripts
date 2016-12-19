#!/bin/sh

set -m


# Ir: I cache reads (instructions executed)
# I1mr: I1 cache read misses (instruction wasn't in I1 cache but was in L2)
# I2mr: L2 cache instruction read misses (instruction wasn't in I1 or L2 cache, had to be fetched from memory)
# Dr: D cache reads (memory reads)
# D1mr: D1 cache read misses (data location not in D1 cache, but in L2)
# D2mr: L2 cache data read misses (location not in D1 or L2)
# Dw: D cache writes (memory writes)
# D1mw: D1 cache write misses (location not in D1 cache, but in L2)
# D2mw: L2 cache data write misses (location not in D1 or L2)

if [ -z "${PMI_RANK}" ]; then
    PMI_RANK=${OMPI_COMM_WORLD_RANK}
    echo "Hello from ${PMI_RANK}"
fi

export GCOV_PREFIX=/home/cjarcher/profile/${PMI_RANK}
mkdir -p ${GCOV_PREFIX}
# perf report --sort=cpu,symbol,pid --call-graph -i 0.perf ./mt-bench-pingpong
#EVENT=L1-dcache-load-misses
#EVENT=cache-misses
EVENT=LLC-store-misses,LLC-prefetch-misses
PERF="perf record -g -s -a -F 1000 -e ${EVENT} -o ${PMI_RANK}.perf"
CACHEGRIND="valgrind --tool=callgrind --branch-sim=yes --instr-atstart=yes --collect-atstart=yes --dump-instr=yes --cacheuse=yes --simulate-wb=yes --simulate-hwpref=yes --callgrind-out-file=${PMI_RANK}.cg"
TOOL=${CACHEGRIND}
TOOL=${PERF}

${TOOL} $*
rc=$!
exit $rc

$* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
rc=$!
exit $rc

if [ ${PMI_RANK} -gt 9 ]; then
    ${TOOL} $* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
    rc=$!
else
    $* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
    rc=$!
fi

exit $rc

#./IMB-MPI1 -msglen msglen -iter 1 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
#./IMB-MPI1 -iter 1 -msglen msglen 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out

#xterm -sb -sl 100000 -geometry 120x40 -T ${PMI_RANK} -e gdb ./IMB-MPI1 --eval-command="set breakpoint pending on" --eval-command="break exit" --eval-command="run -iter 10000 -msglen msglen"

#valgrind ./IMB-MPI1 -iter 10000 -msglen msglen


#cat 0.vg | ./parse_valgrind_supp.sh  > sup1
#export LIBEV_FLAGS=1
#valgrind --suppressions=SFI.supp --show-reachable=yes --leak-check=full --error-limit=no --gen-suppressions=all --log-file=${PMI_RANK}.vg $*
#valgrind --tool=helgrind  --log-file=${PMI_RANK}.vg $*

#MPICH_NEMESIS_NETMOD=of2 mpiexec  -machinefile hosts -n 4 /home/cjarcher/xterm -e gdb ./IMB-MPI1 --eval-command="set breakpoint pending on" --eval-command="break exit" --eval-command="run -iter 1 -msglen msglen"

#MPICH_NEMESIS_NETMOD=of2 mpiexec  -machinefile hosts -n 3 /home/cjarcher/xterm -sb -sl 100000 -geometry 120x80 -e gdb ./IMB-MPI1 --eval-command="set breakpoint pending on" --eval-command="break exit" --eval-command="run -iter 1 -msglen msglen"

#valgrind  --malloc-fill=0xFF --free-fill=0xFF --leak-check=full --vgdb-poll=2147483647 ./a.out 2>&1 | tee ${PMI_RANK}.out

#valgrind -v --tool=memcheck --trace-syscalls=no --trace-signals=no  --leak-check=full --log-file=${PMI_RANK}.vg ./a.out

#--malloc-fill=0xFF --free-fill=0xFF

#2>&1 | tee ${PMI_RANK}.out
#MPIDI_CH3U_Dbg_print_recvq

#!/bin/sh

valgrind --tool=memcheck --malloc-fill=0xFF --free-fill=0xFF --leak-check=full  --leak-resolution=high --num-callers=40 --show-leak-kinds=all --track-origins=yes --fair-sched=yes $* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
#valgrind --leak-check=full $* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out
rc=$?

wait

cat  ${PMI_RANK}.err ${PMI_RANK}.out

killall -9 $1 > /dev/null 2>&1

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

#!/bin/sh

killtree() {
    local pid=$1 child
    for child in $(pgrep -P $pid); do
        killtree $child
    done
    if [ $pid -ne $$ ];then
        kill -kill $pid 2> /dev/null
    fi
}

if [ -z "${PMI_RANK}" ]; then
    PMI_RANK=${OMPI_COMM_WORLD_RANK}
fi


set +bm

TIMEOUT=1075
HOSTNAME=$(/bin/hostname)
PID=$$
LOGFILE=${PMI_RANK}.${PID}.${HOSTNAME}.out
LOGFILEERR=${PMI_RANK}.${PID}.${HOSTNAME}.err

TOOL="valgrind --malloc-fill=0xFF --free-fill=0xFF --leak-check=full  --leak-resolution=high --num-callers=40 --show-leak-kinds=all --track-origins=yes --fair-sched=yes --log-file=vg.${LOGFILE}"
TOOL="strace -e '!select'"
#cmd="${TOOL} $*"
cmd="$*"

sync;sync;sync
ls -altrh . > /dev/null  2>&1

(eval stdbuf -oL $cmd 2>&1 1> ${LOGFILE} 2> ${LOGFILEERR}) &
pid1=$!

(sleep ${TIMEOUT}; killtree ${pid1}; echo "KILLED pid ${pid1}")  &
pid2=$!

wait ${pid1} 2>/dev/null
rc=$?
sync;sync;sync
killtree ${pid1} 2>/dev/null
killtree ${pid2} 2>/dev/null
wait ${pid2} 2>/dev/null
cat ${LOGFILE} ${LOGFILEERR}
#rm -f ${LOGFILE} ${LOGFILEERR}
rm -f /dev/shm/psm*
exit $rc

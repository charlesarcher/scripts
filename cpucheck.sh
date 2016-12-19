#!/bin/bash
function filter {
    cat /proc/cpuinfo | grep -E "$1.*: [0-9]*" | sed -e 's/^.*: //g'
}

CPU_ID=`filter processor`
SOCKET_ID=(`filter 'physical id'`)
CORE_ID=(`filter 'core id'`)

for cpu_id in $CPU_ID; do
    echo "cpu $cpu_id: socket${SOCKET_ID[$cpu_id]}_core${CORE_ID[$cpu_id]}"
done


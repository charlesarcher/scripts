#!/bin/sh -x
sync
#hosts='f017 f018 f029 f030'
hosts='f055 f056 f057 f058'
files=$(find /home/cjarcher/code/install -name "*.so")
#files=$(find /home/cjarcher/code/install/gnu/debug-ofi-tpo-noinline-ep-indirect-embedded-map-disabled-tagged-base/lib/ -name "*.so")

refreshdirs=$((for file in $files; do
#      echo $file
    dirname $file
done) | sort | uniq)

for dir in $refreshdirs; do
    finaldir=$(echo $finaldir $dir)
done

for host in $hosts; do
    echo $host
    ssh $host "ls -altrh ${finaldir}; rm -f /dev/shm/*; sync" > /dev/null 2>&1 &
done
wait


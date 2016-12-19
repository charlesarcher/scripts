#!/bin/sh

x=$(echo -n "${PMI_RANK} "; /bin/hostname)
y=$(grep Cpus_allowed_list /proc/$$/status)

echo $x: $y

$*

#taskset -c 1 $* grep Cpus_allowed_list /proc/$$/status
#taskset -p $$
#/bin/hostname


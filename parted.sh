#!/bin/bash

set -e

if [ ! -x "/sbin/parted" ]; then
    echo "This script requires /sbin/parted to run!" >&2
    exit 1
fi

:<<EOF
while true; do
    read -p "Warning! This will partition and format any unformatted storage volumes! Are you sure? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
EOF

DISKS="c d e f g h i j k l m n o p q r s t u v w x y z aa ab ac ad ae af ag ah ai aj ak al"
DISKS="a"

for i in ${DISKS}; do
    echo "Creating partitions on /dev/sd${i} ..."
    parted -a optimal --script /dev/sd${i} -- mktable gpt
    parted -a optimal --script /dev/sd${i} -- mkpart ext4 1 208GB
    parted -a optimal --script /dev/sd${i} -- mkpart linux-swap 208GB 100%
    sleep 1
    echo "Formatting /dev/sd${i}1 ..."
    mkfs.ext4 /dev/sd${i}1 &
    mkswap /dev/sd${i}2 &
done
echo "waiting for completion"
wait
echo "done"
exit 0

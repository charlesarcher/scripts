#!/bin/sh

while true; do
    uptime | cut -d "," -f 2
    sleep 5
done

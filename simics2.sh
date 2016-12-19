#!/bin/sh
# this file will be overwritten by the project setup script
SIMICS_BASE_PACKAGE="/opt/simics/simics-4.8/simics-4.8.99"
export SIMICS_BASE_PACKAGE
if [ -f "/home/cjarcher/.package-list" ]; then
    exec "/opt/simics/simics-4.8/simics-4.8.99/bin/simics" -package-list "/home/cjarcher/.package-list" -project "/home/cjarcher" "$@"
else
    exec "/opt/simics/simics-4.8/simics-4.8.99/bin/simics" -project "/home/cjarcher" "$@"
fi

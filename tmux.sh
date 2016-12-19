#!/bin/sh

tmux attach -t ${PMI_RANK} send-keys $*



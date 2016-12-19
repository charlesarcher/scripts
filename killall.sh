#!/bin/sh

/bin/hostname
kill -9 `ps -o pid= -u cjarcher`

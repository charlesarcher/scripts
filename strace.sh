#!/bin/sh

strace $* 2> ${PMI_RANK}.err 1> ${PMI_RANK}.out

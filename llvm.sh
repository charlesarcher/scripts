#!/bin/sh

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/home/cjarcher/tools/x86 -DLLVM_BINUTILS_INCDIR=/home/cjarcher/tools/x86/include ../llvm
PYTHONPATH=/home/cjarcher/tools/x86/lib/python2.7/site-packages

#!/bin/sh

gcc -fPIC file1.c -c -o file1.o
gcc -fPIC file2.c -c -o file2.o
gcc -shared -Wl,--version-script=test.ver file1.o file2.o -o shared_script.so

#gcc -fPIC -fvisibility=hidden file1.c -c -o file1.o
#gcc -fPIC -fvisibility=hidden file2.c -c -o file2.o
#gcc -shared -fvisibility=hidden file1.o file2.o -o shared_hidden.so


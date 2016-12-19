#!/bin/sh

if [ $# -lt 1 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 <gnu|intel|pgi>"
    exit
fi

#MPICH2DIR=$(pwd)/ssg_sfi-libfabric
HOME=/home-nfs/cjarcher/
HOME=/home/cjarcher/
COMPILER=$1
MPICH2DIR=$(pwd)/ssg_sfi-mpich
INSTALL_DIR=$(pwd)/../install/${COMPILER}
THREAD_LEVEL=default
STAGEDIR=$(pwd)/stage/${COMPILER}
export AUTOCONFTOOLS=${HOME}/tools/x86/bin
export PATH=${AUTOCONFTOOLS}:${COMPILERPATH}:/bin:/usr/bin



case $COMPILER in
    pgi )
        COMPILERPATH=/path/to/pgi
        export LD=ld
        export CC=pgc
        export CXX=pgc++
        export F77=pgf77
        export FC=pgfortran
        ;;
    intel )
        . /opt/intel/bin/compilervars.sh intel64
        export AR=xiar
        export LD=ld
        export CC=icc
        export CXX=icpc
        export F77=ifort
        export FC=ifort
        export EXTRA_OPT=
        ;;
    gnu )
        export LD=ld
        export CC=gcc
        export CXX=g++
        export F77=gfortran
        export FC=gfortran
        ;;
    * )
        echo "Unknown compiler type"
        exit
esac

export PM=hydra

# BUILD
mkdir -p ${STAGEDIR} && cd ${STAGEDIR}

#Cross
BUILD_HOST=i386-pc-linux-gnu
BUILD_TARGET=i686-pc-linux-gnu
BUILD_BUILD=i686-pc-linux-gnu

# <optimization>-<adi-type>-<thread model>
# example:  optimized-adi-tpo = optimized, adi, thread per object

export OF2=${INSTALL_DIR}
#LIBRARY=debug-adi-ts
#LIBRARY=debug-adi-inline-tpo
LIBRARY=$2
LIBRARIES="optimized-adi-tpo       optimized-adi-inline-tpo debug-adi-tpo           \
           debug-adi-inline-tpo    optimized-adi-tg         optimized-adi-inline-tg \
           debug-adi-tg            debug-adi-inline-tg      optimized-adi-ts        \
           optimized-adi-inline-ts debug-adi-ts             debug-adi-inline-ts"

#echo "LIBRARY_FLAVORS"
#for x in ${LIBRARIES}; do
#    echo $x
#done
#echo "BUILDING LIBRARY:  ${LIBRARY}"

OPTFLAGS_COMMON="-O3 -DNDEBUG -finline-functions -fno-strict-aliasing -fomit-frame-pointer -finline-limit=524288 ${EXTRA_OPT}"
DEBUGFLAGS_COMMON="-O0"

case ${LIBRARY} in
    optimized-adi-tpo)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=per-object
        export BUILD_ALLOCATION=tls
        ;;
    optimized-adi-inline-tpo)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=per-object
        export BUILD_ALLOCATION=tls
        ;;
    debug-adi-tpo)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=per-object
        export BUILD_ALLOCATION=tls
        ;;
    debug-adi-inline-tpo)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=per-object
        export BUILD_ALLOCATION=tls
        ;;
    optimized-adi-tg)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi
        export OF2=${INSTALL_DIR}
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=global
        export BUILD_ALLOCATION=default
        ;;
    optimized-adi-inline-tg)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=global
        export BUILD_ALLOCATION=default
        ;;
    debug-adi-tg)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=global
        export BUILD_ALLOCATION=default
        ;;
    debug-adi-inline-tg)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=multiple
        export BUILD_LOCKLEVEL=global
        export BUILD_ALLOCATION=default
        ;;
    optimized-adi-ts)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi
        export OF2=${INSTALL_DIR}
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=single
        export BUILD_LOCKLEVEL=lock-free
        export BUILD_ALLOCATION=default
        ;;
    optimized-adi-inline-ts)
        export CFLAGS=${OPTFLAGS_COMMON}
        export CXXFLAGS=${OPTFLAGS_COMMON}
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=optimized
        export BUILD_THREADLEVEL=single
        export BUILD_LOCKLEVEL=lock-free
        export BUILD_ALLOCATION=default
        ;;
    *) #DEFAULT BUILD is this
        ;&
    debug-adi-ts)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=single
        export BUILD_LOCKLEVEL=lock-free
        export BUILD_ALLOCATION=default
        ;;
    debug-adi-inline-ts)
        export CFLAGS=${DEBUGFLAGS_COMMON}
        export CXXFLAGS=${DEBUGFLAGS_COMMON}
        export LDFLAGS=""
        export DEVICES=adi:inline-of2
        export BUILD_TYPE=debug
        export BUILD_THREADLEVEL=single
        export BUILD_LOCKLEVEL=lock-free
        export BUILD_ALLOCATION=default
        ;;
esac


#BUILD_TYPE=debug
#BUILD_THREADLEVEL=multiple
#BUILD_LOCKLEVEL=global
#BUILD_ALLOCATION=mutex

#BUILD_TYPE=debug
#BUILD_THREADLEVEL=single
#BUILD_LOCKLEVEL=lock-free
#BUILD_ALLOCATION=default


case ${BUILD_TYPE} in
    optimized)
    if [ ! -f ./Makefile ] ; then                                     \
        echo " ====== BUILDING MPICH2 Optimized Library =======";     \
        MPILIBNAME="mpi"                                              \
        MPICXXLIBNAME="mpigc4"                                        \
        ${MPICH2DIR}/configure                                        \
        --host=${BUILD_HOST}                                          \
        --target=${BUILD_TARGET}                                      \
        --build=${BUILD_BUILD}                                        \
        --with-cross=${MPICH2DIR}/src/mpid/pamid/cross/pe8            \
        --enable-cache                                                \
        --disable-rpath                                               \
        --disable-versioning                                          \
        --prefix=${INSTALL_DIR}                                       \
        --mandir=${INSTALL_DIR}/man                                   \
        --htmldir=${INSTALL_DIR}/www                                  \
        --enable-dependencies                                         \
        --enable-g=none                                               \
        --with-pm=${PM}                                               \
        --with-device=${DEVICES}                                      \
        --with-fabric=${OF2}                                          \
        --enable-romio=yes                                            \
        --enable-f77=yes                                              \
        --enable-fc=yes                                               \
        --with-file-system=ufs+nfs                                    \
        --enable-timer-type=linux86_cycle                             \
        --enable-threads=${BUILD_THREADLEVEL}                         \
        --enable-thread-cs=${BUILD_LOCKLEVEL}                         \
        --enable-handle-allocation=${BUILD_ALLOCATION}                \
        --with-fwrapname=mpigf                                        \
        --with-mpe=no                                                 \
        --with-smpcoll=yes                                            \
        --without-valgrind                                            \
        --enable-timing=none                                          \
        --with-aint-size=8                                            \
        --with-assert-level=0                                         \
        --enable-shared                                               \
        --enable-sharedlibs=gcc                                       \
        --enable-dynamiclibs                                          \
        --disable-debuginfo                                           \
        --enable-fast=all,O3                                          \
        --enable-nemesis-dbg-nolocal                                  \
        --disable-nemesis-shm-collectives                             \
        ; fi
    ;;
    debug)
    if [ ! -f Makefile ] ; then                                     \
        echo " ====== BUILDING MPICH2 Debug Library =======";       \
        MPILIBNAME="mpi"                                            \
        MPICXXLIBNAME="mpigc4"                                      \
        MPICH2LIB_CFLAGS="${CFLAGS} -DMPIDI_TRACE"                  \
        ${MPICH2DIR}/configure                                      \
        --host=${BUILD_HOST}                                        \
        --target=${BUILD_TARGET}                                    \
        --build=${BUILD_BUILD}                                      \
        --with-cross=${MPICH2DIR}/src/mpid/pamid/cross/pe8          \
        --enable-cache                                              \
        --disable-rpath                                             \
        --disable-versioning                                        \
        --prefix=${INSTALL_DIR}                                     \
        --mandir=${INSTALL_DIR}/man                                 \
        --htmldir=${INSTALL_DIR}/www                                \
        --enable-dependencies                                       \
        --enable-g=all                                              \
        --with-pm=${PM}                                             \
        --with-device=${DEVICES}                                    \
        --with-fabric=${OF2}                                        \
        --enable-romio=yes                                          \
        --enable-f77=yes                                            \
        --enable-fc=yes                                             \
        --with-file-system=ufs+nfs                                  \
        --enable-timer-type=linux86_cycle                           \
        --enable-threads=${BUILD_THREADLEVEL}                       \
        --enable-thread-cs=${BUILD_LOCKLEVEL}                       \
        --enable-handle-allocation=${BUILD_ALLOCATION}              \
        --with-fwrapname=mpigf                                      \
        --with-mpe=no                                               \
        --with-smpcoll=yes                                          \
        --without-valgrind                                          \
        --enable-timing=runtime                                     \
        --with-aint-size=8                                          \
        --with-assert-level=2                                       \
        --enable-shared                                             \
        --enable-sharedlibs=gcc                                     \
        --enable-dynamiclibs                                        \
        --disable-debuginfo                                         \
        --enable-fast=none                                          \
        --enable-nemesis-dbg-nolocal                                \
        --disable-nemesis-shm-collectives                           \
        ; fi
    ;;
    *)
        echo " ======= ERROR, Invalid build type ============="
        exit 1;
esac

make V=0 -j32 &&
cd ${STAGEDIR} && ${CC} ${CFLAGS} ${LDFLAGS}                  \
    -shared src/binding/f77/.libs/*.o                         \
    src/binding/f90/.libs/*.o                                 \
    -o      lib/.libs/libmpigf.so && \
make V=0 install -j32

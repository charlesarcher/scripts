#!/bin/sh

if [ $# -lt 1 ];then
    echo "Need system|home"
    exit
fi

if [ "$1" == "system" ]; then
    OMPI_DIR=/usr/mpi/intel/openmpi-1.10.4-hfi
    PAL_VERSION=13
    RTE_VERSION=12
    MPI_VERSION=12
else
    OMPI_DIR=/home/cjarcher/code/install/intel/openmpi-optimized-base
    PAL_VERSION=0
    RTE_VERSION=0
    MPI_VERSION=0
fi

#INTEL_DIR=/opt/intel/compilers_and_libraries_2016/linux
#INTEL_DIR=/opt/intel/composer_xe_2015.3.187/compiler/
INTEL_DIR=/opt/intel/compilers_and_libraries_2016.2.181/linux/compiler
FABRIC_DIR=/home/cjarcher/code/install/intel/ofi-optimized-base

OMPI_BINDIR=${OMPI_DIR}/bin/


if [ -d "${OMPI_DIR}/lib" ]; then
    OMPI_LIBDIR=${OMPI_DIR}/lib
elif [ -d "${OMPI_DIR}/lib64" ]; then
    OMPI_LIBDIR=${OMPI_DIR}/lib64
else
    echo "Error OMPI"
    exit 1
fi

if [ -d "${FABRIC_DIR}/lib" ]; then
    FABRIC_LIBDIR=${FABRIC_DIR}/lib
elif [ -d "${FABRIC_DIR}/lib64" ]; then
    FABRIC_LIBDIR=${FABRIC_DIR}/lib64
else
    echo "Error FABRIC"
    exit 1

fi

/home/cjarcher/tools/x86/bin/patchelf --set-rpath "${FABRIC_LIBDIR}:${OMPI_LIBDIR}:${INTEL_DIR}/lib/intel64:/home/cjarcher/code/install/intel/ofi-optimized-base/lib" ${OMPI_BINDIR}/orted
/home/cjarcher/tools/x86/bin/patchelf --set-rpath "${FABRIC_LIBDIR}:${OMPI_LIBDIR}:${INTEL_DIR}/lib/intel64:/home/cjarcher/code/install/intel/ofi-optimized-base/lib" ${OMPI_LIBDIR}/libopen-pal.so.${PAL_VERSION}
/home/cjarcher/tools/x86/bin/patchelf --set-rpath "${FABRIC_LIBDIR}:${OMPI_LIBDIR}:${INTEL_DIR}/lib/intel64:/home/cjarcher/code/install/intel/ofi-optimized-base/lib" ${OMPI_LIBDIR}/libopen-rte.so.${RTE_VERSION}
/home/cjarcher/tools/x86/bin/patchelf --set-rpath "${FABRIC_LIBDIR}:${OMPI_LIBDIR}:${INTEL_DIR}/lib/intel64:/home/cjarcher/code/install/intel/ofi-optimized-base/lib" ${OMPI_LIBDIR}/libmpi.so.${MPI_VERSION}

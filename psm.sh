

MPIR_CVAR_OFI_USE_PROVIDER=sockets MPICH_NEMESIS_NETMOD=ofi FI_LOG_LEVEL=error
 patchelf --set-rpath /home/cjarcher/code/install/gnu/ofi-debug-base /home/cjarcher/code/install/gnu/netmod-debug-base/lib/libmpi.so
$ENV{"FI_PSM_UUID"} = `/home/cjarcher/psm_rnd_uuid`;

# ps aux | awk '$8 ~ /D/  { print $0 }'
#  IPATH_DISABLE_MMAP_MALLOC Disable mmap for malloc()                => NO
#  IPATH_NO_CPUAFFINITY      Prevent PSM from setting affinity        => NO
#  IPATH_PORT                IB Port number (<= 0 autodetects)        => 0
#  IPATH_SL                  IB outging ServiceLevel number (default 0) => 0
#  IPATH_UNIT                Device Unit number (-1 autodetects)      => -1
# *MPI_LOCALRANKID           Shared context rankid                    => 1 (default was -1)
#  PSM_CLOSE_TIMEOUT         End-point close timeout over-ride.       => 0
#  PSM_CONNECT_TIMEOUT       End-point connection timeout over-ride. 0 for no time-out. => 0
#  PSM_DEVICES               Ordered list of PSM-level devices        => self,shm (default was self,shm,ipath)
#  PSM_IB_SERVICE_ID         IB Service ID for path resolution        => 1152940698815692800
#  PSM_KASSIST_MODE          PSM Shared memory kernel assist mode (knem-put, knem-get, kcopy-put, kcopy-get, none) => knem-put
#  PSM_MEMORY                Memory usage mode (normal or large)      => normal
#  PSM_MQ_RECVREQS_MAX       Max num of irecv requests in flight      => 1024 (default was 1048576)
#  PSM_MQ_RNDV_IPATH_THRESH  ipath eager-to-rendezvous switchover     => 64000
#  PSM_MQ_RNDV_SHM_THRESH    shm eager-to-rendezvous switchover       => 16000
#  PSM_MQ_SENDREQS_MAX       Max num of isend requests in flight      => 1024 (default was 1048576)
#  PSM_NUM_SEND_BUFFERS      Number of send buffers to allocate [1024] => 1024
#  PSM_NUM_SEND_DESCRIPTORS  Number of send descriptors to allocate [4096] => 4096
#  PSM_PATH_REC              Mechanism to query IB path record (default is no path query) => none
#  PSM_PKEY                  Infiniband PKey to use for endpoint      => 65535
#  PSM_SEND_IMMEDIATE_SIZE   Immediate data send size not requiring a buffer [128] => 128
#  PSM_SHM_KCOPY             PSM Shared Memory use kcopy (put,get,none) => put

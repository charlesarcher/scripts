MPIEXEC = "/home/cjarcher/code/mpich/../install/gnu/bin/mpiexec --mca mtl sfi -host cstnh-5,cstnh-6,cstnh-7"
#MPIEXEC = "/home/cjarcher/code/mpich/../install/gnu/bin/mpiexec --mca btl tcp,self -host cstnh-5,cstnh-6,cstnh-7"                                                
#mpirun --mca mtl sfi --mca pml cm -host cstnh-1,cstnh-2 -np 2 /path/to/exec


--mca mtl sfi --mca pml cm --bind-to none -host cstnh-5,cstnh-6,cstnh-7
--mca mtl_base_verbose 100
--mca pls_rsh_agent "ssh -X -n"

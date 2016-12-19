#!/bin/sh

/home/cjarcher/code/install/gnu/openmpi-debug-base/bin/mpiexec -n 2 --mca mtl ofi --mca pml cm --mca pml_base_verbose max  --mca pml_v_verbose all --mca mtl_base_verbose max --mca mtl:ofi:provider_include opa  --hostfq^Ce host.list ./flood

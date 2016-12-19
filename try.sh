#!/bin/sh

do_coll_dynamic=false
did_inline_template=0
did_inline_tsp=0

did_inline_template=`expr $did_inline_template + 1`

did_inline_tsp=`expr $did_inline_tsp + 1`

echo "HERE3333 $did_inline_tsp $did_inline_template $do_coll_dynamic"
if [test "$do_coll_dynamic" = "false" ]; then
   echo "HERE00000"
   if [$did_inline_tsp -ne 1 -o $did_inline_template -ne 1 ]; then
       echo "HERE111111"
#      AC_ERROR([To inline collectives, pick one transport and one template])
   fi
fi

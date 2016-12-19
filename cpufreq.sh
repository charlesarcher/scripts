#echo 1 > /sys/module/processor/parameters/ignore_ppc
#CLK=2300000
#CLK=1200000
#for x in /sys/devices/system/cpu/cpu[0-36]/cpufreq/;do
#    echo ${CLK} > $x/scaling_max_freq
#    echo ${CLK} > $x/scaling_min_freq
#    echo MAX:$(cat $x/scaling_max_freq) MIN:$(cat $x/scaling_min_freq)
#done


echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo

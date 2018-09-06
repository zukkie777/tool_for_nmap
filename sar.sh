#!/bin/bash
export LANG=C
cd sar-dir/
sar -u 60 18 > cpu-data &
sar -q 60 18 > load-avelage-data &
sar -r 60 18 > memory-data &
sar -w 60 18 > context-data &
sar -S 60 18 > swap-data &
sar -n DEV 60 18 > device-data &

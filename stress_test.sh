#!/bin/bash

network=$1

container_names=$(docker ps --filter "name=$network" --format "{{.Names}}")

wget -N http://cdn.zifengkj.com/speedrun.sh

echo "$container_names" | /usr/local/bin/parallel 'docker cp speedrun.sh {}:/'

echo "$container_names" | /usr/local/bin/parallel 'docker exec {} bash /speedrun.sh > {}.log 2>/dev/null'

grep -l 'bandwidth' ./$network\_*.log |  xargs sed -i 's/ G$//'

grep -Eo '^[0-9]*(\.[0-9]+)?' ./$network\_*.log  | awk ' { print  $1 }' | sed 's/\(.*\)\.log:\(.*\)/\1 带宽: \2 G/'

grep -h -Eo '^[0-9]*(\.[0-9]+)?' ./$network\_*.log  | awk '{ sum += $1 } END { print "总带宽: " sum  " G"}'

rm $network\_*.log -rf

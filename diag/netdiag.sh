#!/bin/bash

#docker network ls
cnt=($(docker ps --format "{{lower .Names}}"|sort))
n=0
for i in ${cnt[@]};do
echo $n". "$i
n=$(($n+1))
done

read -p "container: ?" CNT
CNT=${cnt[$CNT]}
[ -z "$CNT" ] && exit
set -x
docker run --name diag -it --rm --net=container:$CNT diag


#!/bin/bash

#
# Usage: (in empty directory)
#        touch player1 ... playern
#        assassin_draw.sh *
#

players="$@"
count=$#
permutation=`shuf -i 1-$count`

victimn=`echo $permutation | cut -d " " -f $count`

for i in $permutation; do
	killer="${!i}"
	victim="${!victimn}"
	victimn=$i
	echo $victim > $killer
done

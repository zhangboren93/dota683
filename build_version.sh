#!/bin/bash
cp scripts/npc/npc_heroes_custom.txt.template scripts/npc/npc_heroes_custom.txt
while IFS= read -r line; do
	readarray -d = -t KVS <<< $line
	KEY=${KVS[0]}
	VAL=`echo ${KVS[1]} | tr -d '\n'`
	echo "s/%$KEY%/$VAL/g"
	sed -i "s/%$KEY%/$VAL/g" scripts/npc/npc_heroes_custom.txt
done < $1

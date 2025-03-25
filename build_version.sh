#!/bin/bash
cp scripts/npc/npc_heroes_custom.txt.template scripts/npc/npc_heroes_custom.txt
cp scripts/npc/npc_items_custom.txt.template scripts/npc/npc_items_custom.txt

str="_heroes.conf"
echo "HEROES : "
while IFS= read -r line; do
	readarray -d = -t KVS <<< $line
	KEY=${KVS[0]}
	VAL=`echo ${KVS[1]} | tr -d '\n'`
	echo "s/%$KEY%/$VAL/g"
	sed -i "s/%$KEY%/$VAL/g" scripts/npc/npc_heroes_custom.txt
done < $1$str

str="_version.conf"
echo "ITEMS : "
while IFS= read -r line; do
	readarray -d = -t KVS <<< $line
	KEY=${KVS[0]}
	VAL=`echo ${KVS[1]} | tr -d '\n'`
	echo "s/%$KEY%/$VAL/g"
	sed -i "s/%$KEY%/$VAL/g" scripts/npc/npc_items_custom.txt
done < $1$str

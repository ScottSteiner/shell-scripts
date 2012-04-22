#!/bin/bash
FGNAMES=('Black' 'Red' 'Green' 'Yellow' 'Blue' 'Magenta' 'Cyan' 'White')
BGNAMES=('Def.' 'Black' 'Red' 'Green' 'Yellow' 'Blue' 'Mag.' 'Cyan' 'White')

echo "	┌───────────────────────────────────────────────────────┐"
for x in {0..8}
do
	((x > 0)) && bg=$((x + 39))

	echo -en "\e[0m ${BGNAMES[x]}	│"

	for y in {0..7}
	do
		echo -en "\e[${bg}m\e[$((y + 30))m ${FGNAMES[y]} "
	done

	echo -en "\e[0m│"
	echo -en "\e[0m\n\e[0m	│"

	for y in {0..7}
	do
		echo -en "\e[${bg}m\e[1;$((y + 30))m ${FGNAMES[y]} "
	done

	echo -en "\e[0m│"
	echo -e "\e[0m"

	((x < 8)) && echo "	├───────────────────────────────────────────────────────┤"
done
echo "	└───────────────────────────────────────────────────────┘"

#!/bin/sh
# Copyright (c) 2012 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# https://github.com/ScottSteiner/shell-scripts

outputdir=~/media/Misc/

filename=$1
start=$2
duration=$3
size=$4
starttext=`echo $start|sed 's/:/./g'`
if [ -z $size ]; then
	size="25%"
fi
mkdir -p "/tmp/gif-$filename-$starttext"
avconv -ss $start -i "$filename" -vsync 1 -an -y -t $duration "/tmp/gif-$filename-$starttext/frame%05d.jpg"
convert -comment "https://github.com/ScottSteiner/shell-scripts" -resize $size -coalesce -layers optimizeplus -loop 0 -delay 1x24 "/tmp/gif-$filename-$starttext/frame*.jpg" "/$outputdir/$filename-$starttext.gif"
rm -rf "/tmp/gif-$filename-$starttext"

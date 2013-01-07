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

#Default settings
fps="videofps"		#Sets the default FPS to the FPS of the video. Change to a number or override with --fps or -f
size=25%		#Sets the default size of the output file. Override with --size or -s
output=~/media/Misc/	#Sets the default location of the output file. Override with --output or -o
comment="Made with gif.sh\nhttps://github.com/ScottSteiner/shell-scripts" #Sets the default comment on the GIF. Override with --comment or -c
command="avconv"	#Sets the default player to avconv (no subs).  Replace with mplayer to have subs or override with --mplayer

OPTS=`getopt -o mc:f:o:s: --long mplayer,comment:,fps:,output:,size: -n 'gif.sh' -- "$@"`
if [ $? != 0 ] ; then exit 1 ; fi
eval set -- "$OPTS"

while true ; do
	case "$1" in
		-m|--mplayer) command="mplayer" ; shift;;
		-c|--comment) comment=$2 ; shift 2 ;;
		-f|--fps) fps=$2 ; shift 2 ;;
		-o|--output) output=$2 ; shift 2 ;;
		-s|--size) size=$2 ; shift 2 ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
filename=$1
start=$2
duration=$3
starttext=`echo $start|sed 's/:/./g'`

if [ $fps = "videofps" ]; then
	fps=`avconv -i "$filename" 2>&1 | sed -n "s/.*, \(.*\) fp.*/\1/p"`
	if [ -z "$fps" ]; then
		fps=24
	fi
fi

mkdir -p "/tmp/gif-$filename-$starttext"
case $command in
	mplayer) mplayer -really-quiet -subfont-text-scale 10 -ao null -vo jpeg:outdir="/tmp/gif-$filename-$starttext/" -ss $start -endpos $duration "$filename";;
	*) avconv -v error -ss $start -i "$filename" -vsync 1 -an -y -t $duration "/tmp/gif-$filename-$starttext/frame%05d.jpg";;
esac
convert -comment "$comment" -resize $size -coalesce -layers optimizeplus -loop 0 -delay 1x$fps "/tmp/gif-$filename-$starttext/*.jpg" "/$output/$filename-$starttext.gif"
rm -rf "/tmp/gif-$filename-$starttext"

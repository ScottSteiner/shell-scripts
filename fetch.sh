#!/bin/sh
# Copyright (c) 2009-2015 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
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

board=$1
thread=$2
savepath=/www/threads/
case "$board" in
	a|b|c|d|e|f|g|gif|h|hr|k|m|o|p|r|s|t|u|v|vg|vr|w|wg|i|ic|r9k|s4s|cm|hm|lgbt|y|3|adv|an|asp|biz|cgl|ck|co|diy|fa|fit|gd|hc|int|jp|lit|mlp|mu|n|out|po|pol|sci|soc|sp|tg|toy|trv|tv|vp|wsg|x
		wget --execute robots=off --recursive --convert-links --page-requisites --no-directories --span-hosts --domains=s.4cdn.org,i.4cdn.org,t.4cdn.org --mirror \
			--quiet --directory-prefix=$savepath$board-$thread --include-directories=* https://boards.4chan.org/$board/res/$thread
		mv $savepath$board-$thread/$thread $savepath$board-$thread/index.html
	;;
        *)
	        echo -e "/$board/ doesn't exist yet."
        	exit 1
	;;
esac

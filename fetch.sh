#!/bin/sh
# Copyright (c) 2011-2012 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
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
	3|a|adv|an|b|c|cgl|ck|cm|co|d|diy|e|f|fa|fit|g|gif|h|hc|hm|hr|i|ic|int|jp|k|lit|m|mlp|mu|n|new|o|p|po|pol|r|r9k|s|sci|soc|sp|t|tg|toy|trv|tv|u|v|vg|vp|w|wg|x|y)
		wget --execute robots=off --recursive --convert-links --page-requisites --no-directories --span-hosts --domains=images.4chan.org,static.4chan.org,thumbs.4chan.org --mirror \
			--quiet --directory-prefix=$savepath$board-$thread --include-directories=*/src,image,*/thumb http://boards.4chan.org/$board/res/$thread
		mv $savepath$board-$thread/$thread $savepath$board-$thread/index.html
	;;
        *)
        echo -e "/$board/ doesn't exist yet."
        exit 1;;
esac

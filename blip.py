#!/usr/bin/python
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
import sys, simplejson, urllib, os
url = sys.argv[1] + "?skin=json"
downloadurl = simplejson.loads(urllib.urlopen(url).read().replace("]);","").replace("blip_ws_results([{","{"))["Post"]["media"]["url"]
filename = "~/media/Misc/TV/" + downloadurl.split('/')[-1].split('#')[0].split('?')[0]
urllib.urlretrieve(downloadurl, os.path.expandvars(os.path.expanduser(filename)))

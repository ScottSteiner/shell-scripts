#!/usr/bin/env python
# Copyright (c) 2015 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
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

import requests, sys
site = 'http://pomf.cat/upload.php'
prefix = 'http://a.pomf.cat/'

print('Uploading files: {}'.format(', '.join(sys.argv[1:])))
for file in sys.argv[1:]:
  with open(file, 'rb') as f:
    content = requests.post(url=site, files={'files[]':f})
  if not content.status_code // 100 == 2:
    raise Exception('Unexpected response {}'.format(content))
  print(content.json())
  url = '{}{}'.format(prefix, content.json()['files'][0]['url'])
  print('{}: {}'.format(file, url))

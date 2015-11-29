#!/usr/bin/env python
import requests, sys
site = 'http://pomf.io/upload.php'

print('Uploading files: {}'.format(', '.join(sys.argv[1:])))
for file in sys.argv[1:]:
  with open(file, 'rb') as f:
    content = requests.post(url=site, files={'files[]':f})
  if not content.status_code // 100 == 2:
    raise Exception('Unexpected response {}'.format(content))
  print('{}: {}'.format(file, content.json()['files'][0]['url']))

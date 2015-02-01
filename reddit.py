#!/usr/bin/env python

import json, re
import urllib2

filename = 'uguubot/plugins/data/nsfw.txt'
subreddits =	['nsfw_html5', 'nsfw_gif', 'fitgirls', 'nsfw', 'nsfw_gfys', 'ass', 'legs', 'boobies', 'nsfw_gfy', 'holdthemoan',\
		'gravure', 'bustypetite', 'blowjobs', 'porn', 'nsfw_gfys']

url = 'http://www.reddit.com/r/{}/top.json?limit=50'
domains = ['gfycat', 'imgur', 'a.pomf.se', 'mediacru.sh']
newlinks = []

for subreddit in subreddits:
	request = urllib2.Request(url.format(subreddit))
	request.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0')
	opener = urllib2.build_opener()
	try:
		content = json.loads(opener.open(request).read())
	except urllib2.HTTPError, e:
		print 'Error retrieving /r/{}: {}'.format(subreddit,e)
	else:
		for x in xrange (0,len(content['data']['children'])):
			data = content['data']['children'][x]['data']
			link = data['url']
			if re.match('.*(?:{}).*'.format('|'.join(domains)), link, re.I):
				newlinks.append('{} - http://redd.it/{}'.format(link,data['id']))

with open('uguubot/plugins/data/nsfw.txt', 'w+') as file:
	links = list(set(file.read().split('\n') + newlinks))
	file.write('\n'.join(links))
	print('\n'.join(links))

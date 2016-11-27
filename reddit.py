#!/usr/bin/env python

import json, re
import urllib2

filename = 'uguubot/plugins/data/nsfw.txt'
subreddits =	['nsfw_html5', 'nsfw_gif', 'nsfw_gfys', 'nsfw_gfy', 'XXX_Animated_Gifs', 'adultgifs',
				'nsfwhardcore', 'nsfw', 'nsfwcosplay', 'porn', 'blowjobs', 'cumsluts', 'onherknees', 'sweatermeat', 'awwporn', 'legwrap',
				'ass', 'legs', 'datgap', 'bustypetite', 'cleavage', 'epiccleavage', 'boobs', 'boobies', 'burstingout', 'stacked',
				'milf', 'bimbofetish', 'collegensfw', 'legalteens',
				'girlsinyogapants', 'HappyEmbarrassedGirls', 'twerking', 'booty_gifs', 
				'movie_nudes', 'celebnsfw',
				'asianhotties', 'AsianHottiesGIFS', 'AsianAmericanHotties', 'gravure', 'JapaneseHotties', 'KoreanHotties', 'ChineseHotties', 'juicyasians',
				'fitgirls', 'holdthemoan', 'bonermaterial', 'palegirls', 'shewantstofuck'
		]
debug = False

url = 'http://www.reddit.com/r/{}/top.json?limit=500'
domains = ['gfycat', 'imgur', 'a.pomf.se', 'mediacru.sh']
newlinks = []

with open(filename, 'r+') as file:
	links = file.read().split('\n')
	if debug: print('Started with {} links'.format(len(links)))


for subreddit in subreddits:
	request = urllib2.Request(url.format(subreddit))
	request.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0')
	opener = urllib2.build_opener()
	count = 0
	try:
		content = json.loads(opener.open(request).read())
	except e:
		print('Error retrieving /r/{}: {}'.format(subreddit,e))
	else:
		for x in xrange (0,len(content['data']['children'])):
			data = content['data']['children'][x]['data']
			link = data['url']
			if re.match('.*(?:{}).*'.format('|'.join(domains)), link, re.I) and '{} - http://redd.it/{}'.format(link,data['id']) not in links:
				if debug: print('Added {}'.format(link))
				newlinks.append('{} - http://redd.it/{}'.format(link,data['id']))
				count += 1
			elif '{} - http://redd.it/{}'.format(link,data['id']) in links and debug:
				print('{} already in links'.format(link))
			elif debug:
				print('{} does not match .*(?:{}).*'.format(link, '|'.join(domains)))
	print('Added {}/{} links from {}'.format(count, len(content['data']['children']), subreddit))

with open(filename, 'w+') as file:
	links += newlinks
	print('Total links added: {}'.format(len(newlinks)))
	file.write('\n'.join(links))
	file.write('\n')

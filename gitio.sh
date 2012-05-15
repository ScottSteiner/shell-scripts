#!/bin/sh

for f in $*
do
	url=`curl -sSi http://git.io -F "url=$f" | awk -F ' ' '/Location/ { print $2; }'`
	echo "$f has been shortened to $url"
done


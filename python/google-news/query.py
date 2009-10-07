# -*- coding: utf-8 -*-

import urllib
import urllib2

def create_params(keyword):
  return {
    "hl"    : "ja",
    "ned"   : "us",
    "ie"    : "UTF-8",
    "oe"    : "UTF-8",
    "output": "rss",
    "q"     : keyword,
  }

def create_url(keyword):
  params = create_params(keyword)
  url    = "http://news.google.com/news?"
  url   += urllib.urlencode(params)
  return url

url = create_url("鉄道")
#print url
req = urllib2.Request(url = url)
req.add_header("User-Agent", "ironnews google-news-crawler")

io = urllib2.urlopen(req)
src = io.read()
io.close()

#print src

f = open("out.txt", "wb")
f.write(src)
f.close()

import re
pattern = re.compile(r"url=(.+?)&")
urls = re.findall(pattern, src)
for x in urls:
  print urllib.unquote_plus(x)

print "---"

uniq_urls = sorted(set(urls), key = urls.index)
for x in uniq_urls:
  print urllib.unquote_plus(x)

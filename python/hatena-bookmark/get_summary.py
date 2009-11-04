# -*- coding: utf-8 -*-

import urllib
import urllib2
import re
from BeautifulSoup import BeautifulSoup

#base_url = 
url = "http://b.hatena.ne.jp/entry/www.asahi.com/national/update/1029/TKY200910290211.html"
url = "http://b.hatena.ne.jp/entry/www.asahi.com/national/update/1031/OSK200910310079.html"


#print src
if True:
  req = urllib2.Request(url = url)
  req.add_header("User-Agent", "ironnews")
  io = urllib2.urlopen(req)
  src = io.read()
  io.close()
  f = open("out.html", "wb")
  f.write(src)
  f.close()
else:
  f = open("out.html", "rb")
  src = f.read()
  f.close()

def trim_script_tag(html):
  pattern = re.compile(r"<script.+?>.*?</script>", re.IGNORECASE | re.DOTALL)
  return re.sub(pattern, "", html)

src = trim_script_tag(src)
doc = BeautifulSoup(src)
#print doc

summary = doc.find("blockquote", {"id": "entry-extract-content"})
summary.find("cite").extract()

print summary.decode("cp932")
print "---"
print "".join([elem.string.strip() for elem in summary.findAll(text = True)])

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

print create_url("鉄道")

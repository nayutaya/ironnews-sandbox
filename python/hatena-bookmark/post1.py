# -*- coding: utf-8 -*-

from base64 import b64encode
from time import time
from random import random
from datetime import datetime
import sha
import httplib

def get_id():
  file = open("id", "r")
  lines = [line.rstrip("\n") for line in file]
  file.close()
  return (lines[0], lines[1])

# http://d.hatena.ne.jp/Shinnya/20090828/1251406408
# http://d.hatena.ne.jp/ymotongpoo/20081201/1228115936
def create_wsse_auth(username, password):
  created = datetime.now().isoformat() + "Z"
  nonce   = b64encode(sha.sha(str(time() + random())).digest())
  digest  = b64encode(sha.sha(nonce + created + password).digest())
  wsse  = 'UsernameToken Username="%(u)s", PasswordDigest="%(p)s", Nonce="%(n)s", Created="%(c)s"'
  value = dict(u = username, p = digest, n = nonce, c = created)
  return wsse % value


username, password = get_id()
wsse = create_wsse_auth(username, password)

request = """<entry xmlns="http://purl.org/atom/ns#">
  <title>dummy</title>
  <link rel="related" type="text/html" href="http://www.asahi.com/national/update/1001/TKY200910010225.html" />
</entry>
"""

# Set header for HTTPConnection
headers = {'X-WSSE': wsse,
           'Content-Type': 'text/xml',
           'User-Agent': 'Python'
           }

# Connetct to HatenaBookmark
con = httplib.HTTPConnection('b.hatena.ne.jp')

# Post entry to the endpoint
con.request('POST', '/atom/post', request, headers)

# Get response from HatenaBookmark API
res = con.getresponse()
print res

response = dict(status=res.status, reason=res.reason, data=res.read())
print response

file = open("out.txt", "wb")
file.write(response["data"])
file.close()

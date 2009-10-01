# -*- coding: utf-8 -*-

from base64 import b64encode
from time import time
from random import random
from datetime import datetime
import sha

def get_id():
  file = open("id", "r")
  lines = [line.rstrip("\n") for line in file]
  file.close()
  return (lines[0], lines[1])

# http://d.hatena.ne.jp/ymotongpoo/20081201/1228115936
def create_wsse_auth(username, password):
  created  = datetime.now().isoformat() + "Z"
  nonce    = b64encode(sha.sha(str(time() + random())).digest())
  password = b64encode(sha.sha(nonce + created + password).digest())
  wsse  = 'UsernameToken Username="%(u)s", PasswordDigest="%(p)s", Nonce="%(n)s", created="%(c)s"'
  value = dict(u = username, p = password, n = nonce, c = created)
  return wsse % value


username, password = get_id()

print create_wsse_auth(username, password)

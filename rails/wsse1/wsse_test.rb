#! ruby -Ku

require "open-uri"
require "rubygems"
gem "nayutaya-wsse"
require "wsse"

username = "foo"
password = "bar"
wsse     = Wsse::UsernameToken.build(username, password).format
p wsse

open("http://localhost:3000/api/go", {"X-WSSE" => wsse}) { |io|
  p io.read
}

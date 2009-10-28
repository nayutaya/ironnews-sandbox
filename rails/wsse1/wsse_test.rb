#! ruby -Ku

require "open-uri"
require "rubygems"
gem "nayutaya-wsse"
require "wsse/username_token_builder"

username = "foo"
password = "bar"
wsse     = Wsse::UsernameTokenBuilder.create_token(username, password)
p wsse

open("http://10.161.227.115:3000/api/go", {"X-WSSE" => wsse}) { |io|
  p io.read
}

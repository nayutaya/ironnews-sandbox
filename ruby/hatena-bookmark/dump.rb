#! ruby -Ku

require "net/http"
require "uri"
require "rubygems"
require "wsse"

username, password = File.open("hatena.id") { |file| [file.gets.strip, file.gets.strip] }
wsse = Wsse::UsernameToken.build(username, password).format

uri = URI.parse("http://b.hatena.ne.jp/dump")

res = Net::HTTP.start(uri.host, uri.port) {|http|
  http.open_timeout = 5
  http.read_timeout = 60 * 10
  http.get(uri.path, {"X-WSSE" => wsse})
}

xml = res.body

File.open("dump.xml", "wb") { |file|
  file.write(xml)
}

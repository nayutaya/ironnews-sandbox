#! ruby -Ku

require "net/http"
require "rubygems"
require "nokogiri"
require "wsse"

Net::HTTP.version_1_2

create_wsse = proc {
  username, password = File.open("hatena.id") { |file| [file.gets.chomp, file.gets.chomp] }
  Wsse::UsernameToken.build(username, password).format
}

#url = "http://gigazine.net/index.php?/news/comments/20100112_break_unbreakable_phone/"

Net::HTTP.start('b.hatena.ne.jp') { |http|
  eid = 18477375
  p http.delete("/atom/edit/#{eid}", {'x-wsse' => create_wsse[]})
}

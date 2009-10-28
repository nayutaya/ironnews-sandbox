#! ruby -Ku

require "open-uri"

open("http://10.161.227.115:3000/api/go", {"X-WSSE" => "hoge"}) { |io|
  p io.read
}

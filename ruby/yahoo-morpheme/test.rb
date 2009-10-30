#! ruby -Ku

appkey = File.open("appkey", "rb") { |file| file.read }

base_url = "http://jlp.yahooapis.jp/MAService/V1/parse"

text = <<EOS.gsub(/\n/, "")
２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。
EOS

params = {
  "appid"    => "c.DPuTSxg65xMpIBbe3..dHOLZoRB9ZgthM8PwBTv_5Rr_CdfkDgtzgP2wtP4uYNKA--",
  "sentence" => text,
  "results"  => "ma", # 形態素解析
  "response" => "surface,reading,pos,baseform,feature",
  "filter"   => (1..13).map { |i| i.to_s }.join("|"),
}

require "cgi"
query_string = params.map { |key, value| "#{CGI.escape(key)}=#{CGI.escape(value)}" }.join("&")

require "open-uri"
url = base_url + "?" + query_string
src = open(url) { |io| io.read }

print(src)

#! ruby -Ku

require "date"
require "open-uri"
require "nkf"
require "rubygems"
require "nokogiri"

date = Date.new(2009, 5, 1)
url = "http://bulknews.net/?date=" + date.strftime("%Y%m%d")
#src = open(url) { |io| io.read }
#File.open("out.html", "wb") { |file| file.write(src) }
src = File.open("out.html", "rb") { |file| file.read }
src = NKF.nkf("-E -w80 -m0", src)
#p src

doc  = Nokogiri(src)
#body = doc.xpath("/html/body")

tables = doc.xpath("//table[@width='100%']")
p tables.size
tables.each { |elem|
  puts("===")
  title = elem.at("tr[1]/td[1]/b/a/font")
  if title && ["asahi.com", "NIKKEI NET"].include?(title.text)
    p title
    p title.text if title
    puts("---")
    puts(elem.to_html)
  end
}

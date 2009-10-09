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

tables = doc.search("//table[@width='100%']")
tables.each { |table|
  title = table.at("tr[1]/td/b/a/font")
  if title && ["asahi.com", "NIKKEI NET"].include?(title.text)
    body = table.at("tr[2]/td")
    puts("---")
    links = body.search("a[@target='_blank']")
    links.each { |link|
      title = link.next_sibling.text.strip
      puts(title) if title != ">>続き"
    }
  end
}

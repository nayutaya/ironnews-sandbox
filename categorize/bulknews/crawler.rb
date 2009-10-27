#! ruby -Ku

require "date"
require "open-uri"
require "nkf"
require "rubygems"
require "nokogiri"

start_date = Date.new(2008, 3, 1)
end_date   = (start_date >> 1) - 1

(start_date..end_date).each { |date|
  STDERR.puts(date.strftime("%Y/%m/%d"))

  url = "http://bulknews.net/?date=" + date.strftime("%Y%m%d")
  src = open(url) { |io| io.read }
  src = NKF.nkf("-E -w80 -m0", src)
  doc = Nokogiri(src)

  tables = doc.search("//table[@width='100%']")
  tables.each { |table|
    title = table.at("tr[1]/td/b/a/font")
    if title && ["asahi.com", "NIKKEI NET"].include?(title.text)
      body = table.at("tr[2]/td")
      links = body.search("a[@target='_blank']")
      links.each { |link|
        title = link.next_sibling.text.strip
        puts(title) if title != ">>続き"
      }
    end
  }

  sleep(1.0)
}

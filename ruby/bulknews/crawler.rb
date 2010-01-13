#! ruby -Ku

require "date"
require "open-uri"
require "nkf"
require "rubygems"
require "nokogiri"

start_date = Date.new(2008, 2, 1)
end_date   = Date.new(2009, 11, 1)

(start_date..end_date).each { |date|
  filename = date.strftime("%Y%m%d") + ".txt"
  STDERR.puts(filename)
  if File.exist?(filename)
    STDERR.puts("skip")
    next
  end

  url = "http://bulknews.net/?date=" + date.strftime("%Y%m%d")
  src = open(url) { |io| io.read }
  src = NKF.nkf("-E -w80 -m0", src)

  titles = []

  doc = Nokogiri(src)
  tables = doc.search("//table[@width='100%']")
  tables.each { |table|
    title = table.at("tr[1]/td/b/a/font")
    if title && ["asahi.com", "NIKKEI NET"].include?(title.text)
      body = table.at("tr[2]/td")
      links = body.search("a[@target='_blank']")
      links.each { |link|
        title = link.next_sibling.text.strip
        titles << title if title != ">>続き"
      }
    end
  }

  File.open(filename, "wb") { |file| file.puts(titles) }

  sleep(1.0)
}

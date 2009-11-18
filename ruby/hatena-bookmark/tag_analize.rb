#! ruby -Ku

require "rubygems"
require "nokogiri"

type_tags = %w[鉄道 非鉄]
area_tags = %w[北海道 東北 関東 中部 近畿 中国 四国 九州 沖縄 海外]
category_tags = %w[
イベント
経済
事件
事故
社会
車両
政治
]

line_tags = %w[
jr宇都宮線
jr横須賀線
jr横浜線
jr関西線
jr紀勢線
jr京浜東北線
jr京葉線
jr阪和線
jr埼京線
jr山陰線
jr山手線
jr山陽線
jr湘南新宿ライン
jr常磐線
jr神戸線
jr相模線
jr総武線
jr大阪環状線
jr中央線
jr東海道線
jr東西線
jr武蔵野線
jr宝塚線
近鉄大阪線
九州新幹線
阪急京都線
阪急神戸線
阪神本線
山形新幹線
山陽新幹線
秋田新幹線
大阪市営地下鉄
中央新幹線
東海道新幹線
東北新幹線
北海道新幹線
北陸新幹線
]

src = File.open("dump.xml", "rb") { |file| file.read }
doc = Nokogiri(src)
doc.xpath("//entry").each { |item|
  title = item.xpath("title").text
  url   = item.xpath("link[@rel='related']").attribute("href").text
  url2  = item.xpath("link[@rel='alternate']").attribute("href").text
  url3  = url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  tags  = item.xpath("subject").map { |tag| tag.text }

  if (tags & type_tags).empty?
    puts("種別タグが含まれていない #{url3}")
  end
  if (tags & area_tags).empty? && !tags.include?("非鉄")
    puts("地域タグが含まれていない #{url3}")
  end
  if (tags & category_tags).empty? && !tags.include?("非鉄")
    puts("カテゴリタグが含まれていない #{url3}")
  end
}

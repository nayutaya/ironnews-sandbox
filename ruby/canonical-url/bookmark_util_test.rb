#! ruby -Ku

require "test/unit"
require "bookmark_util"

class BookmarkUtilTest < Test::Unit::TestCase
  def setup
    @module = BookmarkUtil
  end

  def test_get_canonical_url
    [
      ["http://www.asahi.com/", "http://www.asahi.com/"],

      ["http://journal.mycom.co.jp/news/2009/11/09/027/?rt=na",   "http://journal.mycom.co.jp/news/2009/11/09/027/index.html"],
      ["http://journal.mycom.co.jp/series/photograph/031/?rt=na", "http://journal.mycom.co.jp/series/photograph/031/index.html"],
      ["http://mainichi.jp/select/today/news/20091109k0000e040037000c.html?link_id=RSH02", "http://mainichi.jp/select/today/news/20091109k0000e040037000c.html"],
      ["http://mainichi.jp/select/today/news/20091117k0000m040060000c.html?link_id=RTH05", "http://mainichi.jp/select/today/news/20091117k0000m040060000c.html"],
      ["http://news.searchina.ne.jp/disp.cgi?y=2009&d=1108&f=national_1108_006.shtml&pt=large", "http://news.searchina.ne.jp/disp.cgi?y=2009&d=1108&f=national_1108_006.shtml"],
      ["http://news.searchina.ne.jp/disp.cgi?y=2009&d=1112&f=national_1112_004.shtml&pt=large", "http://news.searchina.ne.jp/disp.cgi?y=2009&d=1112&f=national_1112_004.shtml"],
      ["http://osaka.yomiuri.co.jp/ekiben/eb91118a.htm?from=ichioshi", "http://osaka.yomiuri.co.jp/ekiben/eb91118a.htm"],
      ["http://osaka.yomiuri.co.jp/nara/news/20091105-OYO8T00343.htm?from=ichioshi", "http://osaka.yomiuri.co.jp/nara/news/20091105-OYO8T00343.htm"],
      ["http://osaka.yomiuri.co.jp/news/20091110-OYO1T00789.htm?from=top", "http://osaka.yomiuri.co.jp/news/20091110-OYO1T00789.htm"],
      ["http://osaka.yomiuri.co.jp/news/20091116-OYO1T00291.htm?from=main1", "http://osaka.yomiuri.co.jp/news/20091116-OYO1T00291.htm"],
      ["http://www.asahi.com/national/update/1120/SEB200911200005.html?ref=rss", "http://www.asahi.com/national/update/1120/SEB200911200005.html"],
      ["http://www.asahi.com/sports/update/1120/TKY200911200100.html?ref=rss",   "http://www.asahi.com/sports/update/1120/TKY200911200100.html"],
      ["http://www.tetsudo.com/news/466/%E6%97%A5%E5%90%91%E5%B8%82%E9%A7%85%E3%81%8C%E5%BB%BA%E7%AF%89%E6%A5%AD%E5%8D%94%E4%BC%9A%E8%B3%9E%E3%82%92%E5%8F%97%E8%B3%9E/?tag=as.rss", "http://www.tetsudo.com/news/466/%E6%97%A5%E5%90%91%E5%B8%82%E9%A7%85%E3%81%8C%E5%BB%BA%E7%AF%89%E6%A5%AD%E5%8D%94%E4%BC%9A%E8%B3%9E%E3%82%92%E5%8F%97%E8%B3%9E/"],
      ["http://www.tetsudo.com/news/467/%E6%9D%B1%E6%80%A5%E7%94%B0%E5%9C%92%E9%83%BD%E5%B8%82%E7%B7%9A%E3%81%A7%E6%97%A9%E8%B5%B7%E3%81%8D%E5%BF%9C%E6%8F%B4%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%9A%E3%83%BC%E3%83%B3/?tag=as.rss", "http://www.tetsudo.com/news/467/%E6%9D%B1%E6%80%A5%E7%94%B0%E5%9C%92%E9%83%BD%E5%B8%82%E7%B7%9A%E3%81%A7%E6%97%A9%E8%B5%B7%E3%81%8D%E5%BF%9C%E6%8F%B4%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%9A%E3%83%BC%E3%83%B3/"],
      ["http://www.chunichi.co.jp/article/economics/news/CK2009111302000153.html?ref=rank",  "http://www.chunichi.co.jp/article/economics/news/CK2009111302000153.html"],
      ["http://www.chunichi.co.jp/article/nagano/20091113/CK2009111302000018.html?ref=rank", "http://www.chunichi.co.jp/article/nagano/20091113/CK2009111302000018.html"],
      ["http://www.jiji.com/jc/c?g=eco_30&rel=j7&k=2009111800949", "http://www.jiji.com/jc/c?g=eco_30&k=2009111800949"],
      ["http://www.jiji.com/jc/c?g=int_30&rel=j7&k=2009111300536", "http://www.jiji.com/jc/c?g=int_30&k=2009111300536"],
      ["http://www.yomiuri.co.jp/e-japan/aichi/news/20091120-OYT8T00045.htm?from=dmst3", "http://www.yomiuri.co.jp/e-japan/aichi/news/20091120-OYT8T00045.htm"],
      ["http://www.yomiuri.co.jp/e-japan/tokyo23/news/20091117-OYT8T00108.htm?from=navr", "http://www.yomiuri.co.jp/e-japan/tokyo23/news/20091117-OYT8T00108.htm"],
    ].each { |value, expected|
      assert_equal(expected, @module.get_canonical_url(value), value)
    }
  end
end

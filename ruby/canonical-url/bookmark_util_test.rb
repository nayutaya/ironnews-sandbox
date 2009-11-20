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
    ].each { |value, expected|
      assert_equal(expected, @module.get_canonical_url(value), value)
    }
  end
end

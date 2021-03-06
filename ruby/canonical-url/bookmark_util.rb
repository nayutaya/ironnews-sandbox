
module BookmarkUtil
  CANONICAL_TABLE = [
    [/\A(http:\/\/[a-z]+\.yomiuri\.co\.jp\/.+)\?from=[a-z0-9]+\z/, '\1'],
    [/\A(http:\/\/journal\.mycom\.co\.jp\/.+)\?rt=na\z/, '\1index.html'],
    [/\A(http:\/\/mainichi\.jp\/.+)\?link_id=[A-Z0-9]+\z/, '\1'],
    [/\A(http:\/\/news\.searchina\.ne\.jp\/.+)&pt=large\z/, '\1'],
    [/\A(http:\/\/www\.asahi\.com\/.+)\?ref=rss\z/, '\1'],
    [/\A(http:\/\/www\.chunichi\.co\.jp\/.+)\?ref=rank\z/, '\1'],
    [/\A(http:\/\/www\.jiji\.com\/jc\/c\?g=.+?)&rel=j7(&k=\d+)\z/, '\1\2'],
    [/\A(http:\/\/www\.tetsudo\.com\/.+)\?tag=as\.rss/, '\1'],
  ].freeze.each { |a| a.freeze }

  def self.get_canonical_url(url)
    url = url.dup
    CANONICAL_TABLE.each { |pattern, replace|
      if url.sub!(pattern, replace)
        break
      end
    }
    return url
  end
end

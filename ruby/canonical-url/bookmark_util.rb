
module BookmarkUtil
  def self.get_canonical_url(url)
    url = url.sub(/\A(http:\/\/journal\.mycom\.co\.jp\/.+)\?rt=na\z/, '\1index.html')
    url = url.sub(/\A(http:\/\/mainichi\.jp\/.+)\?link_id=[A-Z0-9]+\z/, '\1')
    url = url.sub(/\A(http:\/\/news\.searchina\.ne\.jp\/.+)&pt=large\z/, '\1')
    url = url.sub(/\A(http:\/\/osaka\.yomiuri\.co\.jp\/.+)\?from=[a-z0-9]+\z/, '\1')
    url = url.sub(/\A(http:\/\/www\.asahi\.com\/.+)\?ref=rss\z/, '\1')
    url = url.sub(/\A(http:\/\/www\.tetsudo\.com\/.+)\?tag=as\.rss/, '\1')
    return url
  end
end

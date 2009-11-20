
module BookmarkUtil
  def self.get_canonical_url(url)
    url = url.sub(/\A(http:\/\/journal\.mycom\.co\.jp\/.+)\?rt=na\z/, '\1index.html')
    url = url.sub(/\A(http:\/\/mainichi\.jp\/.+)\?link_id=[A-Z0-9]+\z/, '\1')
    return url
  end
end

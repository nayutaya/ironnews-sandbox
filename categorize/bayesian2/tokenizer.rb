#! ruby -Ku

require "nkf"

class BigramTokenizer
  def initialize
  end

  def preprocess(doc)
    text = doc.dup
    text.gsub!(/[\r\n\t]/, " ")             # 改行/タブを空白に置換する
    text = NKF.nkf("-W -w80 -m0 -Z1", text) # 全角英数字を半角英数字に置換する（一部記号も含む）
    text.gsub!(/ {2,}/, " ")                # 連続した空白を単一の空白に置換する
    text.strip!                             # 行頭と行末の空白と削除する
    text.downcase!                          # 英字を小文字に置換する
    text.gsub!(/【/, "<")                   # 記号を置換する
    text.gsub!(/】/, ">")
    text.gsub!(/《/, "<")
    text.gsub!(/》/, ">")

    return text
  end

  def tokenize(doc)
    text = preprocess(doc)
    return text.scan(/\d+(?:\.\d+)?|./).
      enum_cons(2).
      map { |chars| chars.join("") }
  end
end

tokenizer = BigramTokenizer.new
p tokenizer.tokenize("１０、１１日 「鉄道の日」行事華やかに 長野")

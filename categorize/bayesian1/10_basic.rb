#! ruby -Ku

# 全角英数字を半角英数字に置換する
# 全角記号の一部を半角記号に置換する
# 行頭と行末の空白と削除する
# 連続した空白を単一の空白に置換する

require "nkf"

STDOUT.binmode

STDIN.each { |line|
  line = NKF.nkf("-W -w80 -m0 -Z1", line)
  line.strip!
  line.gsub!(/ +/, " ")
  STDOUT.puts(line)
}

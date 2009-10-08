#! ruby -Ku

# ソートする
# 重複を削除する

STDOUT.binmode

STDIN.map { |line|
  line.chomp
}.sort.uniq.each { |line|
  STDOUT.puts(line)
}

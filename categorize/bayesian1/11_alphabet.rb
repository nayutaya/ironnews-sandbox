#! ruby -Ku

# 英字を小文字に置換する

STDOUT.binmode

STDIN.each { |line|
  line.chomp!
  line.downcase!
  STDOUT.puts(line)
}

#! ruby -Ku

# 記号を置換する

STDOUT.binmode

STDIN.each { |line|
  line.chomp!
  line.gsub!(/【/, "<")
  line.gsub!(/】/, ">")
  line.gsub!(/《/, "<")
  line.gsub!(/》/, ">")
  STDOUT.puts(line)
}

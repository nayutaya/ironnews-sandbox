#! ruby -Ku

STDOUT.binmode

STDIN.each { |line|
  line.chomp!
  line.gsub!(/【/, "<")
  line.gsub!(/】/, ">")
  STDOUT.puts(line)
}

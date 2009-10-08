#! ruby -Ku

# 2-gramに変換する

STDOUT.binmode

STDIN.each { |line|
  line.chomp!
  line = " " + line + " "
  line.scan(/\d+(?:\.\d+)?|./).
    enum_cons(2).
    map { |chars| chars.join("") }.
    join("\t").
    each { |line| puts(line) }
}

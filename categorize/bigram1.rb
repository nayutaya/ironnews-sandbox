#! ruby -Ku

table = Hash.new(0)

STDIN.each { |line|
  line.chomp.scan(/./).enum_cons(2).map { |a, b| a + b }.each { |gram|
    table[gram] += 1
  }
}

table.to_a.sort_by { |key, value| -value }.each { |key, value|
  STDOUT.printf("%4i %s\n", value, key)
}

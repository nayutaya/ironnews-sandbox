#! ruby -Ku

# 出現頻度を計算する

STDOUT.binmode

table = Hash.new(0)

STDIN.each { |line|
  line.chomp.split(/\t/).each { |keyword|
    table[keyword] += 1
  }
}

table.sort_by { |key, value| key }.each { |key, value|
  puts("#{key}\t#{value}")
}

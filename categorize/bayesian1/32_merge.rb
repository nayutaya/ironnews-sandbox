#! ruby -Ku

# 出現頻度表を合成する

STDOUT.binmode

num = ARGV.size

table = Hash.new { |hash, key|
  hash[key] = [0] * num
}

ARGV.each_with_index { |filename, index|
  File.open(filename) { |file|
    file.each { |line|
      key, count = line.chomp.split(/\t/)
      table[key][index] = count.to_i
    }
  }
}

table.sort_by { |key, values| key }.each { |key, values|
  printf("%s\t%s\n", key, values.join("\t"))
}

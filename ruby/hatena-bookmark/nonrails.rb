#! ruby -Ku

STDIN.each { |line|
  url, tags = line.chomp.split(/\t/)
  tags = tags.split(/,/)
  next unless tags.include?("非鉄")
  puts(url)
}

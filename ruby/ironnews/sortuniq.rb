#! ruby -Ku

STDIN.map { |line|
  line.chomp.split(/\t/, 2)
}.sort_by { |url, title|
  url
}.each { |url, title|
  puts([url, title].join("\t"))
}

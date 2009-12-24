#! ruby -Ku

file1 = File.open(ARGV[0], "rb") { |file| file.to_a }.map { |line| line.strip }.sort.uniq
file2 = File.open(ARGV[1], "rb") { |file| file.to_a }.map { |line| line.strip }.sort.uniq

result = file1 - file2
File.open("out.txt", "wb") { |file|
  file.puts(result)
}

#! ruby -Ku

rail_titles = Dir.glob(File.dirname(__FILE__) + "/../../../ironnews-data/news_title/rail_*.txt").
  map { |path| File.foreach(path).map { |line| line.strip } }.flatten
rest_titles = Dir.glob(File.dirname(__FILE__) + "/../../../ironnews-data/news_title/rest_*.txt").
  map { |path| File.foreach(path).map { |line| line.strip } }.flatten

srand(0)
rail_titles = rail_titles.sort_by { rand }
rest_titles = rest_titles.sort_by { rand }

num = [rail_titles.size, rest_titles.size].min / 2

File.open("sample_rail_a.txt", "wb") { |file|
  file.puts(rail_titles.slice!(0, num))
}
File.open("sample_rail_b.txt", "wb") { |file|
  file.puts(rail_titles.slice!(0, num))
}

File.open("sample_rest_a.txt", "wb") { |file|
  file.puts(rest_titles.slice!(0, num))
}
File.open("sample_rest_b.txt", "wb") { |file|
  file.puts(rest_titles.slice!(0, num))
}

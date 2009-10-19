#! ruby -Ku

rail_titles = File.open("data/rail.txt") { |file| file.map { |line| line.chomp } }
rest_titles = File.open("data/rest.txt") { |file| file.map { |line| line.chomp } }

srand(0)
rail_titles = rail_titles.sort_by { rand }
rest_titles = rest_titles.sort_by { rand }

num = 500

File.open("sample_rail_#{num}_a.txt", "wb") { |file|
  file.puts(rail_titles.slice!(0, num))
}
File.open("sample_rail_#{num}_b.txt", "wb") { |file|
  file.puts(rail_titles.slice!(0, num))
}

File.open("sample_rest_#{num}_a.txt", "wb") { |file|
  file.puts(rest_titles.slice!(0, num))
}
File.open("sample_rest_#{num}_b.txt", "wb") { |file|
  file.puts(rest_titles.slice!(0, num))
}

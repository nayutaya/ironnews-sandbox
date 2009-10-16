#! ruby -Ku

rail_titles = File.open("../data/title_rail.txt")    { |file| file.map { |line| line.chomp } }
rest_titles = File.open("../data/title_nonrail.txt") { |file| file.map { |line| line.chomp } }

srand(0)
rail_titles = rail_titles.sort_by { rand }
rest_titles = rest_titles.sort_by { rand }

File.open("title_rail400a.txt", "wb") { |file|
  400.times {
    file.puts(rail_titles.shift)
  }
}
File.open("title_rail400b.txt", "wb") { |file|
  400.times {
    file.puts(rail_titles.shift)
  }
}

File.open("title_rest400a.txt", "wb") { |file|
  400.times {
    file.puts(rest_titles.shift)
  }
}
File.open("title_rest400b.txt", "wb") { |file|
  400.times {
    file.puts(rest_titles.shift)
  }
}

#! ruby -Ku

require "tokenizer"
require "classifier"

tokenizer  = BigramTokenizer.new
classifier = BayesianClassifier.new(tokenizer)

rail_titles = File.open("../data/title_rail.txt")    { |file| file.map { |line| line.chomp } }
rest_titles = File.open("../data/title_nonrail.txt") { |file| file.map { |line| line.chomp } }

rail_titles.each { |title| classifier.add("rail", title) }
rest_titles.each { |title| classifier.add("rest", title) }

thresholds = {"rail" => 1.0, "rest" => 3.0}

results = Hash.new { |hash, key|
  hash[key] = []
}

STDIN.each { |title|
  title.chomp!
  category = classifier.classifier(title, thresholds) || "unknown"
  results[category] << title
}

results.each { |category, titles|
  File.open("out.#{category}", "wb") { |file|
    titles.each { |title|
      file.puts(title)
    }
  }
}

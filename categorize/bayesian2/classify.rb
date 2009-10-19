#! ruby -Ku

$: << File.join(File.dirname(__FILE__), "..")

require "tokenizer"
require "classifier"

tokenizer  = BigramTokenizer.new
classifier = BayesianClassifier.new

rail_titles = File.open("../data/rail.txt") { |file| file.map { |line| line.chomp } }
rest_titles = File.open("../data/rest.txt") { |file| file.map { |line| line.chomp } }

rail_titles.each { |title| classifier.train("rail", tokenizer.tokenize(title)) }
rest_titles.each { |title| classifier.train("rest", tokenizer.tokenize(title)) }

thresholds = {"rail" => 1.0, "rest" => 3.5}

results = Hash.new { |hash, key|
  hash[key] = []
}

STDIN.each { |title|
  title.chomp!
  category = classifier.classify(tokenizer.tokenize(title), thresholds) || "unknown"
  results[category] << title
}

results.each { |category, titles|
  File.open("out.#{category}", "wb") { |file|
    titles.each { |title|
      file.puts(title)
    }
  }
}

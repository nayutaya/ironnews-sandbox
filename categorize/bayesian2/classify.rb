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

STDOUT.binmode

STDIN.each { |title|
  title.chomp!
  category =
    case classifier.classifier(title, thresholds)
    when "rail" then "鉄道"
    when "rest" then "非鉄"
    when nil    then "不明"
    else raise
    end
  printf("%s|%s\n", category, title)
}

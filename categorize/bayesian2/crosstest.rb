#! ruby -Ku

require "tokenizer"
require "classifier"

tokenizer  = BigramTokenizer.new
classifier = BayesianClassifier.new(tokenizer)

rail_titles = File.open("../data/title_rail.txt")    { |file| file.map { |line| line.chomp } }
rest_titles = File.open("../data/title_nonrail.txt") { |file| file.map { |line| line.chomp } }

rail_titles.each { |title| classifier.add("rail", title) }
rest_titles.each { |title| classifier.add("rest", title) }

thresholds = {"rail" => 1.0, "rest" => 3.5}

rail_table = Hash.new(0)
rail_titles.each { |title|
  category = classifier.classifier(title, thresholds)
  rail_table[category || "unknown"] += 1
}

rest_table = Hash.new(0)
rest_titles.each { |title|
  category = classifier.classifier(title, thresholds)
  rest_table[category || "unknown"] += 1
}

printf("鉄道 全%4i件\n", rail_titles.size)
printf("非鉄 全%4i件\n", rest_titles.size)
printf("鉄道 -> 鉄道 %5i件 %5.1f%\n", rail_table["rail"],    rail_table["rail"].to_f    / rail_titles.size * 100)
printf("鉄道 -> 非鉄 %5i件 %5.1f%\n", rail_table["rest"],    rail_table["rest"].to_f    / rail_titles.size * 100)
printf("鉄道 -> 不明 %5i件 %5.1f%\n", rail_table["unknown"], rail_table["unknown"].to_f / rail_titles.size * 100)
printf("非鉄 -> 鉄道 %5i件 %5.1f%\n", rest_table["rail"],    rest_table["rail"].to_f    / rest_titles.size * 100)
printf("非鉄 -> 非鉄 %5i件 %5.1f%\n", rest_table["rest"],    rest_table["rest"].to_f    / rest_titles.size * 100)
printf("非鉄 -> 不明 %5i件 %5.1f%\n", rest_table["unknown"], rest_table["unknown"].to_f / rest_titles.size * 100)

#! ruby -Ku

$: << File.join(File.dirname(__FILE__), "..")

require "tokenizer"
require "classifier"

unless ARGV.size == 3
  STDERR.puts("usage: train db category input")
  exit(1)
end

db_filename    = ARGV[0]
category_name  = ARGV[1]
input_filename = ARGV[2]

tokenizer  = BigramTokenizer.new
classifier = BayesianClassifier.new

File.open(input_filename) { |file|
  file.each { |line|
    tokens = tokenizer.tokenize(line.chomp)
    classifier.train(category_name, tokens)
  }
}

File.open(db_filename, "wb") { |file|
  file.write(classifier.to_hash.inspect)
}

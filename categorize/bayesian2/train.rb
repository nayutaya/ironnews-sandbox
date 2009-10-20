#! ruby -Ku

# 単純ベイズ分類器の学習を行う

$: << File.join(File.dirname(__FILE__), "..")

require "tokenizer"
require "classifier"

unless ARGV.size == 3
  STDERR.puts("Usage:")
  STDERR.puts("  ruby train.rb db category input")
  exit(1)
end

db_filename    = ARGV[0]
category_name  = ARGV[1]
input_filename = ARGV[2]

hash = {}
if File.exist?(db_filename)
  bin  = File.open(db_filename, "rb") { |file| file.read }
  hash = Marshal.load(bin)
end

tokenizer  = BigramTokenizer.new
classifier = BayesianClassifier.new(hash)

File.open(input_filename) { |file|
  file.each { |line|
    tokens = tokenizer.tokenize(line.chomp)
    classifier.train(category_name, tokens)
  }
}

hash = classifier.to_hash
bin  = Marshal.dump(hash)
File.open(db_filename, "wb") { |file| file.write(bin) }

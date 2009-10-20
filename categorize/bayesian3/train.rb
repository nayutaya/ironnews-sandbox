#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_categorizer"

unless ARGV.size == 3
  STDERR.puts("Usage:")
  STDERR.puts("  ruby train.rb db category input")
  exit(1)
end

db_filename    = ARGV[0]
category_name  = ARGV[1]
input_filename = ARGV[2]

tokenizer = BigramTokenizer.new

if File.exist?(db_filename)
  categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)
else
  categorizer = NaiveBayesCategorizer.new(tokenizer)
end

File.open(input_filename) { |file|
  file.each { |line|
    categorizer.train(category_name, line.chomp)
  }
}

categorizer.save(db_filename)

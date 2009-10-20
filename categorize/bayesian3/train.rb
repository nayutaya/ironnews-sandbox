#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_categorizer"

unless ARGV.size == 2
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} database category")
  exit(1)
end

db_filename   = ARGV[0]
category_name = ARGV[1]

STDERR.puts("loading...")
tokenizer = BigramTokenizer.new
if File.exist?(db_filename)
  categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)
else
  categorizer = NaiveBayesCategorizer.new(tokenizer)
end

STDERR.puts("training...")
STDIN.each { |line|
  categorizer.train(category_name, line.chomp)
}

STDERR.puts("saving...")
categorizer.save(db_filename)

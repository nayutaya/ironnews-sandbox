#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_categorizer"

tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.new(tokenizer)


categorizer.train("A", %w[a b c d e])
categorizer.train("B", %w[a b f g h])

p categorizer.categorize(%w[a b])
p categorizer.categorize(%w[a b c])
p categorizer.categorize(%w[a b f])

=begin
p classifier
h = classifier.to_hash
p h
p classifier2.to_hash
classifier2.save("out.db")
classifier3 = NaiveBayesCategoryClassifier.load(tokenizer, "out.db")
p classifier3.to_hash
=end

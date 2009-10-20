#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_category_classifier"

tokenizer  = BigramTokenizer.new
classifier = NaiveBayesCategoryClassifier.new(tokenizer)


classifier.train("A", %w[a b c d e])
classifier.train("B", %w[a b f g h])

p classifier.classify(%w[a b f])

=begin
p classifier
h = classifier.to_hash
p h
p classifier2.to_hash
classifier2.save("out.db")
classifier3 = NaiveBayesCategoryClassifier.load(tokenizer, "out.db")
p classifier3.to_hash
=end

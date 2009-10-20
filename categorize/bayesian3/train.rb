#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_category_classifier"

tokenizer  = BigramTokenizer.new
classifier = NaiveBayesCategoryClassifier.new(tokenizer)
classifier.input_dictionary.encode("A")
classifier.output_dictionary.encode("B")

p classifier

h = classifier.to_hash
p h

classifier2 = NaiveBayesCategoryClassifier.new(tokenizer, h)
p classifier2.to_hash

classifier2.save("out.db")

classifier3 = NaiveBayesCategoryClassifier.load(tokenizer, "out.db")
p classifier3.to_hash

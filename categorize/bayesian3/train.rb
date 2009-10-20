#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_category_classifier"

dict = Dictionary.new
p dict.encode("a")
p dict.encode("b")
p dict

h = dict.to_hash
p h

dict2 = Dictionary.new(h)
p dict2

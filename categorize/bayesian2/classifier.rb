#! ruby -Ku

# 単純ベイズ分類器

class BayesianClassifier
  def initialize(tokenizer)
    @tokenizer  = tokenizer
    # {"feature1" => {"categoryA" => 0, "categoryB" => 1}}
    @features   = Hash.new { |hash, key|
      hash[key] = Hash.new(0)
    }
    # {"categoryA" => 100, "categoryB" => 200}
    @quantities = Hash.new(0)
  end

  def add(category, document)
    tokens = @tokenizer.tokenize(document)
    tokens.each { |token|
      @features[token][category] += 1
    }
    @quantities[category] += 1
    return self
  end
end

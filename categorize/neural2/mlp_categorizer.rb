
# 多層パーセプトロンネットワークによるカテゴリ分類器

$: << File.join(File.dirname(__FILE__), "..")
require "mlp_classifier"
require "bigram_tokenizer"
require "dictionary"

class MlpCategorizer
  def initialize(tokenizer, hash = {})
    @tokenizer = tokenizer

    @category_dictionary = Dictionary.new(hash[:category_dictionary] || {})
    @feature_dictionary  = Dictionary.new(hash[:feature_dictionary] || {})
    @classifier          = MlpClassifier.new(hash[:classifier] || {:hidden_num => 10})
  end

  def self.load(tokenizer, filepath)
    bin  = File.open(filepath, "rb") { |file| file.read }
    hash = Marshal.load(bin)
    return self.new(tokenizer, hash)
  end

  def to_hash
    return {
      :category_dictionary => @category_dictionary.to_hash,
      :feature_dictionary  => @feature_dictionary.to_hash,
      :classifier          => @classifier.to_hash,
    }
  end

  def save(filepath)
    hash = self.to_hash
    bin  = Marshal.dump(hash)
    File.open(filepath, "wb") { |file| file.write(bin) }
  end

  def train(category, document)
    features    = @tokenizer.tokenize(document)
    category_id = @category_dictionary.encode(category)
    feature_ids = @feature_dictionary.encode_multiple(features)

    input_values = feature_ids.inject({}) { |memo, feature_id|
      memo[feature_id] = 1.0
      memo
    }
    target_values = @category_dictionary.ids.inject({}) { |memo, id|
      memo[id] = 0.0
      memo
    }
    target_values[category_id] = 1.0

    @classifier.backpropagation(input_values, target_values)
  end

=begin
  def categorize(document, thresholds = {})
    probs = self.classify(document).
      map     { |category, prob| [category, prob] }.
      sort_by { |category, prob| prob }

    first_category,  first_prob  = probs[-1]
    second_category, second_prob = probs[-2]

    if first_prob > second_prob * (thresholds[first_category] || 1.0)
      return first_category
    else
      return nil
    end
  end
=end
end

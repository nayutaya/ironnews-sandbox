
# 単純ベイズ分類器を用いたカテゴリ分類器

$: << File.join(File.dirname(__FILE__), "..")
require "naive_bayes_classifier"
require "dictionary"
require "tokenizer"

class NaiveBayesCategorizer
  def initialize(tokenizer, hash = {})
    @tokenizer = tokenizer

    @category_dictionary = Dictionary.new(hash[:category_dictionary] || {})
    @feature_dictionary  = Dictionary.new(hash[:feature_dictionary] || {})
    @classifier          = NaiveBayesClassifier.new(hash[:classifier] || {})
  end

  attr_reader :category_dictionary, :feature_dictionary

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

  def train(category, features)
    category_id = @category_dictionary.encode(category)
    feature_ids = @feature_dictionary.encode_multiple(features)
    @classifier.train(category_id, feature_ids)
  end

  def classify(features)
    feature_ids = @feature_dictionary.encode_multiple(features)
    probs = @classifier.classify(feature_ids)
    return @category_dictionary.decode_multiple(probs)
  end

  def categorize(features, thresholds = {})
    probs = self.classify(features).
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
end

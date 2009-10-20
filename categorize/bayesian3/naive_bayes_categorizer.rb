
# 単純ベイズ分類器を用いたカテゴリ分類器

$: << File.join(File.dirname(__FILE__), "..")
require "naive_bayes_classifier"
require "dictionary"
require "tokenizer"

class NaiveBayesCategoryClassifier
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

  def classify(features, thresholds = {})
    feature_ids = @feature_dictionary.encode_multiple(features)
    return @classifier.classify(feature_ids)
  end
end


# 単純ベイズ分類器を用いたカテゴリ分類器

$: << File.join(File.dirname(__FILE__), "..")
require "naive_bayes_classifier"
require "dictionary"
require "tokenizer"

class NaiveBayesCategoryClassifier
  def initialize(tokenizer, hash = {})
    @tokenizer = tokenizer

    @input_dictionary  = Dictionary.new(hash[:input_dictionary]  || {})
    @output_dictionary = Dictionary.new(hash[:output_dictionary] || {})
  end

  attr_reader :input_dictionary, :output_dictionary

  def self.load(tokenizer, filepath)
    bin  = File.open(filepath, "rb") { |file| file.read }
    hash = Marshal.load(bin)
    return self.new(tokenizer, hash)
  end

  def to_hash
    return {
      :input_dictionary  => @input_dictionary.to_hash,
      :output_dictionary => @output_dictionary.to_hash,
    }
  end

  def save(filepath)
    hash = self.to_hash
    bin  = Marshal.dump(hash)
    File.open(filepath, "wb") { |file| file.write(bin) }
  end
end

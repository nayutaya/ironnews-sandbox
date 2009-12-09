#! ruby -Ku

# 多層パーセプトロンネットワークによるカテゴリ分類のクロステストを行う

require "mlp_categorizer"

srand(0)

STDERR.puts("loading...")
training_data  = []
training_data += File.foreach("sample_rail_a.txt").map { |line| ["rail", line.strip] }
training_data += File.foreach("sample_rest_a.txt").map { |line| ["rest", line.strip] }
training_data  = training_data.sort_by { rand }
test_data      = []
test_data     += File.foreach("sample_rail_b.txt").map { |line| ["rail", line.strip] }
test_data     += File.foreach("sample_rest_b.txt").map { |line| ["rest", line.strip] }

calc = proc { |params|
  srand(0)
  tokenizer   = BigramTokenizer.new
  categorizer = MlpCategorizer.new(
    tokenizer,
    :classifier => {:hidden_num => params[:hidden], :weight => params[:weight]})

  STDERR.puts("training...")
  params[:count].times { |i|
    STDERR.printf("%i/%i\n", i + 1, params[:count])
    training_data.each { |category, line|
      categorizer.train(category, line)
    }
  }

  STDERR.puts("categorizing...")
  thresholds = {"rail" => params[:rail], "rest" => params[:rest]}
  table = Hash.new(0)
  test_data.each { |expected, line|
    actual = categorizer.categorize(line, thresholds) || "unknown"
    table[expected + "-" + actual] += 1
    table[expected] += 1
  }

  score  = 0.0
  score += table["rail-rail"]    / table["rail"].to_f * 100 * 1.0
  score -= table["rail-rest"]    / table["rail"].to_f * 100 * 3.0
  score -= table["rail-unknown"] / table["rail"].to_f * 100 * 1.0
  score -= table["rest-rail"]    / table["rest"].to_f * 100 * 1.0
  score += table["rest-rest"]    / table["rest"].to_f * 100 * 1.0
  score -= table["rest-unknown"] / table["rest"].to_f * 100 * 1.0
  score
}

x = {
  :hidden => 5,
  :count  => 1,
  :weight => 0.1,
  :rail   => 0.1,
  :rest   => 0.3,
}

p x
p calc[x]

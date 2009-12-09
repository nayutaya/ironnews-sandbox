#! ruby -Ku

require "drb/drb"
require "mlp_categorizer"


STDERR.puts("loading...")
training_data  = []
training_data += File.foreach("sample_rail_a.txt").map { |line| ["rail", line.strip] }
training_data += File.foreach("sample_rest_a.txt").map { |line| ["rest", line.strip] }
test_data      = []
test_data     += File.foreach("sample_rail_b.txt").map { |line| ["rail", line.strip] }
test_data     += File.foreach("sample_rest_b.txt").map { |line| ["rest", line.strip] }

srand(0)
training_data = training_data.sort_by { rand }


calc = proc { |params|
  srand(0)
  tokenizer   = BigramTokenizer.new
  categorizer = MlpCategorizer.new(
    tokenizer,
    :classifier => {:hidden_num => params[:hidden], :weight => params[:weight]})

  STDERR.puts("training...")
  train_start = Time.now
  params[:count].times { |i|
    STDERR.printf("%i/%i\n", i + 1, params[:count])
    training_data.each { |category, line|
      categorizer.train(category, line)
    }
  }
  train_end = Time.now

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

  STDERR.puts("done")

  [score, train_end - train_start]
}


uri = ARGV.shift
ts  = DRbObject.new(nil, uri)

STDERR.puts("waiting...")

loop {
  symbol, params = ts.take([:request, Hash])
  p [symbol, params]

  score, time = calc[params]

  result = params.merge(:score => score, :time => time)
  ts.write([:result, result])
}

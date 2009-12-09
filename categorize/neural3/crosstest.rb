#! ruby -Ku

# 多層パーセプトロンネットワークによるカテゴリ分類のクロステストを行う

require "mlp_categorizer"

input_files = {
  "rail" => "sample_rail_a.txt",
  "rest" => "sample_rest_a.txt",
}
test_files = {
  "rail" => "sample_rail_b.txt",
  "rest" => "sample_rest_b.txt",
}

count      = 5
hidden_num = 1
weight     = 0.5
thresholds = {"rail" => 0.1, "rest" => 0.3}

tokenizer   = BigramTokenizer.new
categorizer = MlpCategorizer.new(tokenizer, :classifier => {:hidden_num => hidden_num, :weight => weight})

STDERR.puts("shuffling...")
training_data = []
input_files.each { |category, filepath|
  File.open(filepath) { |file|
    file.each { |line|
      training_data << [category, line.chomp]
    }
  }
}

srand(0)
training_data = training_data.sort_by { rand }

STDERR.puts("training...")
count.times { |i|
  STDERR.printf("%i/%i\n", i + 1, count)
  training_data.each { |category, line|
    categorizer.train(category, line)
  }
}

table = Hash.new(0)

STDERR.puts("categorizing...")
test_files.each { |expected, filename|
  File.foreach(filename) { |line|
    line.chomp!
    actual = categorizer.categorize(line, thresholds) || "unknown"
    table[expected + "-" + actual] += 1
    table[expected] += 1
  }
}

p table

p table["rail-rail"]    / table["rail"].to_f * 100
p table["rail-rest"]    / table["rail"].to_f * 100
p table["rail-unknown"] / table["rail"].to_f * 100
p table["rest-rail"]    / table["rest"].to_f * 100
p table["rest-rest"]    / table["rest"].to_f * 100
p table["rest-unknown"] / table["rest"].to_f * 100
#! ruby -Ku

# 多層パーセプトロンネットワークによる学習を行う

require "mlp_categorizer"

unless ARGV.size >= 1 && (ARGV.size - 1) % 2 == 0
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} database [category1 file1 [category2 file2]]...")
  exit(1)
end

db_filename = ARGV.shift
count       = 5
input_files = ARGV.enum_slice(2).inject({}) { |memo, (category, filepath)|
  memo[category] = filepath
  memo
}

STDERR.puts("loading...")
tokenizer = BigramTokenizer.new
if File.exist?(db_filename)
  categorizer = MlpCategorizer.load(tokenizer, db_filename)
else
  categorizer = MlpCategorizer.new(tokenizer)
end

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

STDERR.puts("saving...")
categorizer.save(db_filename)

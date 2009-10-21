#! ruby -Ku

# 多層パーセプトロンネットワークによる学習を行う

unless ARGV.size >= 1 && (ARGV.size - 1) % 2 == 0
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} database [category1 file1 [category2 file2]]...")
  exit(1)
end

db_filename = ARGV.shift
input_files = ARGV.enum_slice(2).inject({}) { |memo, (category, filepath)|
  memo[category] = filepath
  memo
}

STDERR.puts("loading...")
=begin
tokenizer = BigramTokenizer.new
if File.exist?(db_filename)
  categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)
else
  categorizer = NaiveBayesCategorizer.new(tokenizer)
end
=end

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
=begin
training_data.each { |category, line|
  categorizer.train(category, line)
}
=end

STDERR.puts("saving...")
=begin
categorizer.save(db_filename)
=end

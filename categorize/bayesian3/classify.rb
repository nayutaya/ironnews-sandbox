#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を行う

require "naive_bayes_categorizer"

unless ARGV.size >= 1 && (ARGV.size - 1) % 2 == 0
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} database [category1 threshold1 [category2 threshold2]]...")
  exit(1)
end

db_filename = ARGV.shift
thresholds  = ARGV.enum_slice(2).inject({}) { |memo, (category, threshold)|
  memo[category] = threshold.to_f
  memo
}

STDERR.puts("loading...")
tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)

results = Hash.new { |hash, key|
  hash[key] = []
}

STDERR.puts("categorizing...")
STDIN.each { |line|
  line.chomp!
  category = categorizer.categorize(line, thresholds) || "unknown"
  results[category] << line
}

STDERR.puts("writing...")
results.each { |category, lines|
  File.open("out.#{category}", "wb") { |file|
    file.puts(lines)
  }
}

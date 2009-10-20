#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を行う

require "naive_bayes_categorizer"

unless ARGV.size >= 2 && (ARGV.size - 2) % 2 == 0
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} db input (category threshold)...")
  exit(1)
end

db_filename    = ARGV.shift
input_filename = ARGV.shift
thresholds = ARGV.enum_slice(2).inject({}) { |memo, (category, threshold)|
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
File.open(input_filename) { |file|
  file.each { |line|
    line.chomp!
    category = categorizer.categorize(line, thresholds) || "unknown"
    results[category] << line
  }
}

STDERR.puts("writing...")
results.each { |category, titles|
  File.open("out.#{category}", "wb") { |file|
    titles.each { |title|
      file.puts(title)
    }
  }
}

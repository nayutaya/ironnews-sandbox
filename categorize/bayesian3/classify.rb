#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類を行う

require "naive_bayes_categorizer"

unless ARGV.size == 2
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} db input")
  exit(1)
end

db_filename    = ARGV[0]
input_filename = ARGV[1]

STDERR.puts("loading...")
tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)

results = Hash.new { |hash, key|
  hash[key] = []
}

# TODO: 閾値をオプションで指定する
thresholds = {"rail" => 1.0, "rest" => 3.5}

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

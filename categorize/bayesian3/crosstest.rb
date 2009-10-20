#! ruby -Ku

# 単純ベイズ分類器によるカテゴリ分類のクロステストを行う

require "naive_bayes_categorizer"

unless ARGV.size >= 2 && (ARGV.size - 2) % 2 == 0
  STDERR.puts("Usage:")
  STDERR.puts("  ruby #{$0} database category [category1 threshold1 [category2 threshold2]]...")
  exit(1)
end

db_filename   = ARGV.shift
category_name = ARGV.shift
thresholds    = ARGV.enum_slice(2).inject({}) { |memo, (category, threshold)|
  memo[category] = threshold.to_f
  memo
}

STDERR.puts("loading...")
tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.load(tokenizer, db_filename)

table = {}
count = 0

STDERR.puts("categorizing...")
STDIN.each { |line|
  line.chomp!
  category   = categorizer.categorize(line, thresholds)
  category ||= "unknown"
  table[category] ||= 0
  table[category] += 1
  count += 1
}

printf("total %i\n", count)
table.
  sort_by { |category, num| category }.
  each { |category, num|
    printf("%-10s -> %-10s %5i %5.1f%\n", category_name, category, num, num.to_f / count * 100)
  }

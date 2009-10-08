#! ruby -Ku

# 分類器を生成する

STDOUT.binmode

# カテゴリ0のドキュメント数
$cat0_num = File.open("out/20.rail") { |file| file.readlines.size }
# カテゴリ1のドキュメント数
$cat1_num = File.open("out/20.rest") { |file| file.readlines.size }

# 特徴のカテゴリ毎の出現数
$table = {}
File.open("out/32") { |file|
  file.each { |line|
    key, *values = line.chomp.split(/\t/)
    $table[key] = values.map { |s| s.to_i }
  }
}

# あるカテゴリの中に、ある特徴が現れた数
def fcount(key, catno)
  return (($table[key] || [])[catno] || 0).to_f
end

# あるカテゴリの中のアイテム数
def catcount(catno)
  return [$cat0_num.to_f, $cat1_num.to_f][catno] || raise("invalid cat")
end


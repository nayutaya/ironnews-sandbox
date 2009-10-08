#! ruby -Ku

# 分類器を生成する

STDOUT.binmode

# ドキュメント = 記事のタイトル
# カテゴリ0 = 鉄
# カテゴリ1 = 非鉄
# 特徴 = 2-gramで分割した要素

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

# あるカテゴリの中のドキュメント数
def catcount(catno)
  return [$cat0_num.to_f, $cat1_num.to_f][catno] || raise("invalid cat")
end

# ドキュメントの総数
def totalcount
  return $cat0_num + $cat1_num
end

# カテゴリの一覧
def categories
  return [0, 1]
end

def fprob(key, catno)
  count = catcount(catno)
  return 0.0 if count == 0.0
  return fcount(key, catno) / count
end

def weightedprob(key, catno, weight = 1.0, ap = 0.5)
  basicprob = fprob(key, catno)
  totals = categories.map { |cn| fcount(key, cn) }.inject { |a, b| a + b }
  return ((weight * ap) + (totals * basicprob)) / (weight + totals)
end


def docprob(features, catno)
  x = 1.0
  features.each { |key|
    x *= weightedprob(key, catno)
  }
  return x
end

def prob(features, catno)
  catprob = catcount(catno) / totalcount
  docprob = docprob(features, catno)
  return docprob * catprob
end

def classifier(features)
  cat0prob = prob(features, 0)
  cat1prob = prob(features, 1)
  if cat0prob > cat1prob
    return "鉄道"
  elsif cat1prob > cat0prob * 3
    return "非鉄"
  else
    return "不明"
  end
end

File.open("out/20.rest") { |file|
  file.each { |line|
    tuple = line.chomp.split(/\t/)
    cat   = classifier(tuple)
    printf("%s|%s\n", cat, tuple.join(","))
  }
}

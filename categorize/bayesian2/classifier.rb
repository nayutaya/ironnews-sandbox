#! ruby -Ku

# 単純ベイズ分類器

class BayesianClassifier
  def initialize
    # {"feature1" => {"categoryA" => 0, "categoryB" => 1}}
    @features   = Hash.new { |hash, key|
      hash[key] = Hash.new(0)
    }
    # {"categoryA" => 100, "categoryB" => 200}
    @quantities = Hash.new(0)
  end

  def train(category, features)
    features.each { |feature|
      @features[feature][category] += 1
    }
    @quantities[category] += 1
    return self
  end

  # あるカテゴリの中に、ある特徴が現れた数
  def fcount(feature, category)
    return @features[feature][category]
  end

  # あるカテゴリの中のドキュメント数
  def catcount(category)
    return @quantities[category]
  end

  # ドキュメントの総数
  def totalcount
    return @quantities.values.inject { |ret, val| ret + val }
  end

  # カテゴリの一覧
  def categories
    return @quantities.keys
  end

  # ある特徴が、あるカテゴリに現れる確率
  def fprob(feature, category)
    count = self.catcount(category)
    return 0.0 if count == 0
    return self.fcount(feature, category).to_f / count.to_f
  end

  def weightedprob(feature, category, weight = 1.0, ap = 0.5)
    basicprob = self.fprob(feature, category)
    totals    = self.categories.
      map { |cat| self.fcount(feature, cat) }.
      inject { |ret, val| ret + val }.to_f
    return ((weight * ap) + (totals * basicprob)) / (weight + totals)
  end

  def docprob(features, category)
    return features.inject(1.0) { |prob, feature|
      prob * self.weightedprob(feature, category)
    }
  end

  def prob(features, category)
    catprob = self.catcount(category).to_f / self.totalcount.to_f
    docprob = self.docprob(features, category)
    return docprob * catprob
  end

  def classify(features, thresholds = Hash.new(1.0))
    probs = self.categories.
      map { |category| [category, self.prob(features, category)] }.
      sort_by { |category, prob| prob }
    first_category,  first_prob  = probs[-1]
    second_category, second_prob = probs[-2]
    if first_prob > second_prob * thresholds[first_category]
      return first_category
    else
      return nil
    end
  end
end

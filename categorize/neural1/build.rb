#! ruby -Ku

require "tokenizer"

nonrail = (<<EOS).lines.map { |line| line.strip }
イチロー、９年連続200安打に王手
オバマ大統領、アポロ11号乗組員を称賛　月面着陸40周年で
スー・チーさんの裁判初公開…でも１日限定　ミャンマー
パキスタンで武装集団が警察学校襲撃
マツバボタン６万本、一気に咲きそろう　愛知・南知多
海水浴場の事故、相次ぐ　中１ら３人死亡
公明代表「民主に協力やぶさかでない」　鳩山代表と会談
子に重い脳性まひ、お産事故５件を補償認定
首都高で１０台絡む事故　６人けが　江戸川の中央環状線
新首相に野党側の前ソウル大総長を指名　韓国大統領
石川遼、トップで予選通過　ＫＢＣオーガスタ
仙谷・行政刷新相「10年度予算、09年度より減額を」
中央三井信託、顧客情報6912件紛失　50店舗で、誤廃棄か
朝青龍が右ひざに痛み　秋場所へ「ぎりぎりだが治す」
土砂崩れ、親子不明現場から遺体の一部　福岡・篠栗町
東京円相場　１１時現在１ドル＝１００円８０?８５銭
盗まれた現金回収、輸送車乗り逃げ　コインロッカーから
柏崎刈羽原発７号機、運転再開へ　新潟知事が容認
北朝鮮ミサイル「発射なら安保理でとり上げる」　日韓首脳一致
両横綱４連勝、日馬富士２敗目　大相撲秋場所４日目
EOS

rail = (<<EOS).lines.map { |line| line.strip }
「ミニスカポリス」の蜂須賀さん、電車で痴漢容疑者逮捕
ＪＲ６社、秋の臨時列車は大幅減　利用者８％減予想
ＪＲ横須賀線、東京―逗子運転見合わせ　戸塚駅人身事故
ＪＲ王子駅、トイレの汚水垂れ流し　３０年前から？
ＪＲ根岸線で人身事故　大宮?大船間で一時運転見合わせ
ＪＲ西、安全・収益どう両立　井手元会長とは「縁切り」
ＪＲ西日本、役員報酬を減額　業績悪化受け１０?５％
ＪＲ中央・総武線などで一時運転見合わせ
ＪＲ南武線で運転見合わせ
ベルリン、通勤路線が全面運休　点検長期化、平常復帰は12月
リニア「迂回」なら建設費６４００億円増　ＪＲ東海提示
帰宅ラッシュＪＲ中央線、事故でダイヤ乱れる
山形新幹線にカリスマ販売員　１日５０万円の記録も
中央・総武線の下り運転一時見合わせ　阿佐ケ谷駅で事故
中東初の「無人鉄道」、ドバイで開業
東海道線（東京―小田原）一時運転見合わせ　人身事故で
東京メトロ東西線、衝突事故で２９万人に影響
尼崎脱線漏えい　別の元委員も面会　ＪＲ西幹部が要請
浮かび上がった「国鉄一家」の癒着　福知山線脱線情報漏洩
名古屋始発、東京行き「のぞみ」誕生　ＪＲ東海
EOS

class ThreeLayerPerceptronNetwork
  def initialize
    @default_in_mid_weight  = 0.0
    @default_mid_out_weight = 0.0
    @default_mid_bias       = 0.0

    @in_mid_weight = Hash.new { |in_mid, in_key|
      in_mid[in_key] = Hash.new { |mid_weight, mid_key|
        mid_weight[mid_key] = self.default_in_mid_weight
      }
    }

    @mid_out_weight = Hash.new { |mid_out, mid_key|
      mid_out[mid_key] = Hash.new { |out_weight, out_key|
        out_weight[out_key] = self.default_mid_out_weight
      }
    }

    @mid_bias = Hash.new { |mid_bias, mid_key|
      mid_bias[mid_key] = self.default_mid_bias
    }
  end

  attr_accessor :default_in_mid_weight, :default_mid_out_weight, :default_mid_bias
  attr_reader :in_mid_weight, :mid_out_weight, :mid_bias

  def in_keys
    return @in_mid_weight.keys.sort
  end

  def out_keys
    return @mid_out_weight.map { |mid_key, out_weight|
      out_weight.keys
    }.flatten.sort.uniq
  end

  def mid_keys
    #return @mid_bias.keys.sort
    return @in_mid_weight.map { |in_key, mid_weight|
      mid_weight.keys
    }.flatten.sort.uniq
  end

  def in_mid_links
    links = []
    self.in_keys.each { |in_key|
      self.mid_keys.each { |mid_key|
        links << [in_key, mid_key]
      }
    }
    return links
  end

  def mid_out_links
    links = []
    self.mid_keys.each { |mid_key|
      self.out_keys.each { |out_key|
        links << [mid_key, out_key]
      }
    }
    return links
  end
end

network = ThreeLayerPerceptronNetwork.new
#p network

#p network.in_mid_links

network.in_mid_weight[0][0] = 1.0
network.in_mid_weight[0][1] = 2.0
network.in_mid_weight[1][3] = 3.0
#p network.in_mid_links

p network.mid_out_links

network.mid_bias[0] = 4.0
network.mid_bias[3] = 5.0
#p network.in_mid_links
p network.mid_out_links

network.mid_out_weight[0][0] = 1.0
network.mid_out_weight[0][1] = 2.0
network.mid_out_weight[1][0] = 3.0
p network.mid_out_links


__END__

class Neural
  def initialize(tokenizer)
    @tokenizer = tokenizer
    @in_dict = Hash.new { |hash, key|
      hash[key] = hash.size
    }
    @out_dict = Hash.new { |hash, key|
      hash[key] = hash.size
    }
    @sigmoid = proc { |x| x }
  end

  def add_in_dict(key)
    return @in_dict[key]
  end

  def add_out_dict(key)
    return @out_dict[key]
  end

  attr_reader :in_dict, :out_dict
end

tokenizer = BigramTokenizer.new
neural    = Neural.new(tokenizer)

rail.each { |title|
  tokenizer.tokenize(title).each { |token|
    neural.add_in_dict(token)
  }
}
nonrail.each { |title|
  tokenizer.tokenize(title).each { |token|
    neural.add_in_dict(token)
  }
}

p neural.in_dict
p neural.in_dict.size

neural.add_out_dict("rail")
neural.add_out_dict("nonrail")
p neural.out_dict
p neural.out_dict.size

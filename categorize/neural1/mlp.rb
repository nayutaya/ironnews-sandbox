#! ruby -Ku

# 多層パーセプトロンニューラルネットワーク
# 入力層-中間層-出力層
# バイアスなし
# 初期値ランダム
class ThreeLayerPerceptronNetwork
  def initialize(in_num, mid_num, out_num)
    @in_num  = in_num
    @mid_num = mid_num
    @out_num = out_num

    @in_mid  = {}
    @mid_out = {}
  end

  def setup
    (0..@in_num).each { |in_key|
      (0..@mid_num).each { |mid_key|
        @in_mid[in_key] ||= {}
        @in_mid[in_key][mid_key] = rand
      }
    }

    (0..@mid_num).each { |mid_key|
      (1..@out_num).each { |out_key|
        @mid_out[mid_key] ||= {}
        @mid_out[mid_key][out_key] = rand
      }
    }
  end

  def fire(values)
    values[0] = 1.0

    mid = {0 => 1.0}
    (1..@mid_num).each { |mid_key|
      sum = 0.0
      values.each { |in_key, in_value|
        weight = @in_mid[in_key][mid_key]
        sum += in_value * weight
      }
      mid[mid_key] = Math.tanh(sum)
    }

    out = {}
    (1..@out_num).each { |out_key|
      sum = 0.0
      (0..@mid_num).each { |mid_key|
        weight = @mid_out[mid_key][out_key]
        value  = mid[mid_key]
        sum += value * weight
      }
      out[out_key] = Math.tanh(sum)
    }

    return out
  end

  def dtanh(x)
    return 1.0 - x * x
  end

  # バックプロパゲーションによるトレーニング
  def train(in_values, ret_values)
    in_values[0] = 1.0

    mid = {0 => 1.0}
    (1..@mid_num).each { |mid_key|
      sum = 0.0
      in_values.each { |in_key, in_value|
        weight = @in_mid[in_key][mid_key]
        sum += in_value * weight
      }
      mid[mid_key] = Math.tanh(sum)
    }

    out = {}
    (1..@out_num).each { |out_key|
      sum = 0.0
      (0..@mid_num).each { |mid_key|
        weight = @mid_out[mid_key][out_key]
        value  = mid[mid_key]
        sum += value * weight
      }
      out[out_key] = Math.tanh(sum)
    }

    out_delta = {}
    (1..@out_num).each { |out_key|
      error = ret_values[out_key] - out[out_key]
      out_delta[out_key] = self.dtanh(out[out_key]) * error
    }
    #p out_delta

    mid_delta = {}
    (0..@mid_num).each { |mid_key|
      error = 0.0
      (1..@out_num).each { |out_key|
        error += out_delta[out_key] * @mid_out[mid_key][out_key]
      }
      mid_delta[mid_key] = self.dtanh(mid[mid_key]) * error
    }
    #p mid_delta

    n = 0.5 # 学習率

    (0..@mid_num).each { |mid_key|
      (1..@out_num).each { |out_key|
        change = out_delta[out_key] * mid[mid_key]
        @mid_out[mid_key][out_key] += n * change
      }
    }

    (0..@in_num).each { |in_key|
      (0..@mid_num).each { |mid_key|
        change = mid_delta[mid_key] * in_values[in_key]
        @in_mid[in_key][mid_key] += n * change
      }
    }

    return out_delta.values.inject(0.0) { |sum, val| sum + val * val }
  end
end


network = ThreeLayerPerceptronNetwork.new(2, 3, 2)

srand(0)
p network.setup

p network

# XORを学習させる

puts "before"
p network.fire(1 => 0, 2 => 0)
p network.fire(1 => 0, 2 => 1)
p network.fire(1 => 1, 2 => 0)
p network.fire(1 => 1, 2 => 1)

puts "train"
100.times {
  p network.train({1 => 0, 2 => 0}, {1 => 1, 2 => 0})
  p network.train({1 => 0, 2 => 1}, {1 => 0, 2 => 1})
  p network.train({1 => 1, 2 => 0}, {1 => 0, 2 => 1})
  p network.train({1 => 1, 2 => 1}, {1 => 1, 2 => 0})
}

puts "after"
p network.fire(1 => 0, 2 => 0)
p network.fire(1 => 0, 2 => 1)
p network.fire(1 => 1, 2 => 0)
p network.fire(1 => 1, 2 => 1)

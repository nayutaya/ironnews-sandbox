#! ruby -Ku

# 多層パーセプトロンニューラルネットワーク
# 入力層-中間層-出力層
# バイアスあり
# 初期値ランダム
class ThreeLayerPerceptronNetwork
  def initialize(in_num, mid_num, out_num)
    @in_num  = in_num
    @mid_num = mid_num
    @out_num = out_num

    @in_mid_weight  = {}
    @mid_out_weight = {}
  end

  def setup
    (0..@in_num).each { |in_key|
      (0..@mid_num).each { |mid_key|
        @in_mid_weight[in_key] ||= {}
        @in_mid_weight[in_key][mid_key] = rand
      }
    }

    (0..@mid_num).each { |mid_key|
      (1..@out_num).each { |out_key|
        @mid_out_weight[mid_key] ||= {}
        @mid_out_weight[mid_key][out_key] = rand
      }
    }
  end

  def sigmoid(x)
    return Math.tanh(x)
  end

  def dsigmoid(x)
    return 1.0 - x * x
  end

  def feedforward_in_to_mid(in_values)
    return (1..@mid_num).inject({}) { |mid_values, mid_key|
      sum = in_values.inject(0.0) { |result, (in_key, in_value)|
        value  = in_value
        weight = @in_mid_weight[in_key][mid_key]
        result + value * weight
      }
      mid_values[mid_key] = self.sigmoid(sum)
      mid_values
    }
  end

  def feedforward_mid_to_out(mid_values)
    return (1..@out_num).inject({}) { |out_values, out_key|
      sum = (0..@mid_num).inject(0.0) { |result, mid_key|
        value  = mid_values[mid_key]
        weight = @mid_out_weight[mid_key][out_key]
        result + value * weight
      }
      out_values[out_key] = self.sigmoid(sum)
      out_values
    }
  end

  def backpropagation_out_to_mid(target_values, out_values)
    return (1..@out_num).inject({}) { |out_delta, out_key|
      target = target_values[out_key]
      out    = out_values[out_key]
      error  = target - out
      out_delta[out_key] = self.dsigmoid(out) * error
      out_delta
    }
  end

  def backpropagation_mid_to_in(out_delta, mid_values)
    return (0..@mid_num).inject({}) { |mid_delta, mid_key|
      error = (1..@out_num).inject(0.0) { |result, out_key|
        value  = out_delta[out_key]
        weight = @mid_out_weight[mid_key][out_key]
        result + value * weight
      }
      mid_delta[mid_key] = self.dsigmoid(mid_values[mid_key]) * error
      mid_delta
    }
  end

  def update_in_to_mid(mid_delta, in_values, n)
    (0..@in_num).each { |in_key|
      (1..@mid_num).each { |mid_key|
        change = mid_delta[mid_key] * in_values[in_key]
        @in_mid_weight[in_key][mid_key] += n * change
      }
    }
  end

  def update_mid_to_out(out_delta, mid_values, n)
    (0..@mid_num).each { |mid_key|
      (1..@out_num).each { |out_key|
        change = out_delta[out_key] * mid_values[mid_key]
        @mid_out_weight[mid_key][out_key] += n * change
      }
    }
  end

  def feedforward(in_values)
    in_values  = in_values.merge(0 => 1.0)
    mid_values = self.feedforward_in_to_mid(in_values)
    mid_values = mid_values.merge(0 => 1.0)
    out_values = self.feedforward_mid_to_out(mid_values)
    return out_values
  end

  # バックプロパゲーションによるトレーニング
  def train(in_values, target_values)
    in_values  = in_values.merge(0 => 1.0)
    mid_values = self.feedforward_in_to_mid(in_values)
    mid_values = mid_values.merge(0 => 1.0)
    out_values = self.feedforward_mid_to_out(mid_values)

    out_delta = self.backpropagation_out_to_mid(target_values, out_values)
    mid_delta = self.backpropagation_mid_to_in(out_delta, mid_values)

    n = 0.5 # 学習率
    self.update_in_to_mid(mid_delta, in_values, n)
    self.update_mid_to_out(out_delta, mid_values, n)

    return out_delta.values.inject(0.0) { |sum, val| sum + val * val }
  end
end


network = ThreeLayerPerceptronNetwork.new(2, 3, 2)

srand(0)
p network.setup

p network

# XORを学習させる

puts "before"
p network.feedforward(1 => 0, 2 => 0)
p network.feedforward(1 => 0, 2 => 1)
p network.feedforward(1 => 1, 2 => 0)
p network.feedforward(1 => 1, 2 => 1)

puts "train"
100.times {
  x = 0.0
  x += network.train({1 => 0, 2 => 0}, {1 => 1, 2 => 0})
  x += network.train({1 => 0, 2 => 1}, {1 => 0, 2 => 1})
  x += network.train({1 => 1, 2 => 0}, {1 => 0, 2 => 1})
  x += network.train({1 => 1, 2 => 1}, {1 => 1, 2 => 0})
  p x
}

puts "after"
p network.feedforward(1 => 0, 2 => 0)
p network.feedforward(1 => 0, 2 => 1)
p network.feedforward(1 => 1, 2 => 0)
p network.feedforward(1 => 1, 2 => 1)

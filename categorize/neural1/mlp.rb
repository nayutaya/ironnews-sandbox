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
end


network = ThreeLayerPerceptronNetwork.new(2, 3, 2)
#network.default_in_mid_weight  = -0.2
#network.default_mid_out_weight = 0.0

srand(0)
p network.setup

p network

p network.fire(1 => 0, 2 => 0)
p network.fire(1 => 0, 2 => 1)
p network.fire(1 => 1, 2 => 0)
p network.fire(1 => 1, 2 => 1)


#-1.step(1, 0.1) { |x|
#  p [x, Math.tanh(x), 1.0 - x * x]
#}

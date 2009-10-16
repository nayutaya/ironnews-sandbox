#! ruby -Ku

class LinkWeight
  def initialize
    @weight  = {}
    @default = proc { rand }
  end

  def get(from, to)
    @weight[from] ||= {}
    @weight[from][to] ||= @default[]
    return @weight[from][to]
  end

  def set(from, to, weight)
    @weight[from] ||= {}
    @weight[from][to] = weight
    return weight
  end

  def [](from, to)
    return self.get(from, to)
  end

  def []=(from, to, weight)
    self.set(from, to, weight)
    return weight
  end

  def from_keys
    return @weight.keys
  end
end

# 多層パーセプトロンニューラルネットワーク
class ThreeLayerPerceptronNetwork
  def initialize(hidden_num)
    @hidden_num           = hidden_num     # 隠しユニットの数
    @input_hidden_weight  = LinkWeight.new # 入力層-隠し層の重み
    @output_hidden_weight = LinkWeight.new # 出力層-隠し層の重み
    @sigmoid  = proc { |x| Math.tanh(x) }  # シグモイド関数
    @dsigmoid = proc { |x| 1.0 - x * x }   # シグモイド関数の微分
  end

  def feedforward(input_values)
    input_values  = input_values.merge(0 => 1.0) # バイアス
    hidden_values = self.feedforward_input_to_hidden(input_values)
    hidden_values = hidden_values.merge(0 => 1.0) # バイアス
    output_values = self.feedforward_hidden_to_output(hidden_values)
    return output_values
  end

  def feedforward_input_to_hidden(input_values)
    return (1..@hidden_num).inject({}) { |hidden_values, hidden_id|
      sum = input_values.inject(0.0) { |result, (input_id, input_value)|
        value  = input_value
        weight = @input_hidden_weight[input_id, hidden_id]
        result + (value * weight)
      }
      hidden_values[hidden_id] = @sigmoid[sum]
      hidden_values
    }
  end

  def feedforward_hidden_to_output(hidden_values)
    return @output_hidden_weight.from_keys.inject({}) { |output_values, output_id|
      sum = (0..@hidden_num).inject(0.0) { |result, hidden_id|
        value  = hidden_values[hidden_id]
        weight = @output_hidden_weight[output_id, hidden_id]
        result + value * weight
      }
      output_values[output_id] = self.sigmoid(sum)
      output_values
    }
  end
end

if $0 == __FILE__
  srand(0)
  network = ThreeLayerPerceptronNetwork.new(3)
  p network.feedforward(1 => 0.0, 2 => 0.0)
  p network.feedforward(1 => 0.0, 2 => 1.0)
  p network.feedforward(1 => 1.0, 2 => 0.0)
  p network.feedforward(1 => 1.0, 2 => 1.0)
  p network
end

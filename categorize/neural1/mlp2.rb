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
      output_values[output_id] = @sigmoid[sum]
      output_values
    }
  end

  def backpropagation(input_values, target_values)
    input_values  = input_values.merge(0 => 1.0)
    hidden_values = self.feedforward_input_to_hidden(input_values)
    hidden_values = hidden_values.merge(0 => 1.0)
    output_values = self.feedforward_hidden_to_output(hidden_values)

    output_delta = self.calc_output_delta(target_values, output_values)
    hidden_delta = self.calc_hidden_delta(output_delta, hidden_values)

    n = 0.5 # 学習率
    self.update_input_hidden_weight(hidden_delta, input_values, n)
    self.update_output_hidden_weight(output_delta, hidden_values, n)

    return output_delta.values.inject(0.0) { |sum, delta| sum + (delta * delta) }
  end

  def calc_output_delta(target_values, output_values)
    output_ids = target_values.keys

    return output_ids.inject({}) { |output_delta, output_id|
      target = target_values[output_id] || 0.0
      output = output_values[output_id] || 0.0
      error  = target - output
      output_delta[output_id] = @dsigmoid[output] * error
      output_delta
    }
  end

  def calc_hidden_delta(output_delta, hidden_values)
    output_ids = output_delta.keys

    return (0..@hidden_num).inject({}) { |hidden_delta, hidden_id|
      error = output_ids.inject(0.0) { |result, output_id|
        delta  = output_delta[output_id]
        weight = @output_hidden_weight[output_id, hidden_id]
        result + delta * weight
      }
      hidden_delta[hidden_id] = @dsigmoid[hidden_values[hidden_id]] * error
      hidden_delta
    }
  end

  def update_input_hidden_weight(hidden_delta, input_values, n)
    input_values.keys.each { |input_id|
      (1..@hidden_num).each { |hidden_id|
        delta  = hidden_delta[hidden_id]
        value  = input_values[input_id]
        change = delta * value
        @input_hidden_weight[input_id, hidden_id] += n * change
      }
    }
  end

  def update_output_hidden_weight(output_delta, hidden_values, n)
    (0..@hidden_num).each { |hidden_id|
      @output_hidden_weight.from_keys.each { |output_id|
        delta  = output_delta[output_id]
        value  = hidden_values[hidden_id]
        change = delta * value
        @output_hidden_weight[output_id, hidden_id] += n * change
      }
    }
  end
end

if $0 == __FILE__
  srand(0)
  network = ThreeLayerPerceptronNetwork.new(3)
  puts "before:"
  p network.feedforward(1 => 0.0, 2 => 0.0)
  p network.feedforward(1 => 0.0, 2 => 1.0)
  p network.feedforward(1 => 1.0, 2 => 0.0)
  p network.feedforward(1 => 1.0, 2 => 1.0)

  puts "train:"
  p network.backpropagation({1 => 0, 2 => 0}, {1 => 1, 2 => 0})
  #network.backpropagation({1 => 0, 2 => 1}, {1 => 0, 2 => 1})
  #network.backpropagation({1 => 1, 2 => 0}, {1 => 0, 2 => 1})
  #network.backpropagation({1 => 1, 2 => 1}, {1 => 1, 2 => 0})

  puts "after:"
  p network.feedforward(1 => 0.0, 2 => 0.0)
  p network.feedforward(1 => 0.0, 2 => 1.0)
  p network.feedforward(1 => 1.0, 2 => 0.0)
  p network.feedforward(1 => 1.0, 2 => 1.0)
end

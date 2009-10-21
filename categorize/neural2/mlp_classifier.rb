
# 多層パーセプトロンネットワークによる分類器

$: << File.join(File.dirname(__FILE__), "..")
require "link_weight"

class MlpClassifier
  def initialize(hash = {})
    # 隠しユニットの数
    @hidden_num           = hash[:hidden_num] || 10
    # 入力層-隠し層の重み
    @input_hidden_weight  = LinkWeight.new(hash[:input_hidden_weight]  || {}) { (rand - 0.5) / 5.0 }
    # 出力層-隠し層の重み
    @output_hidden_weight = LinkWeight.new(hash[:output_hidden_weight] || {}) { (rand - 0.5) / 5.0 }

    @sigmoid  = proc { |x| Math.tanh(x) }  # シグモイド関数
    @dsigmoid = proc { |x| 1.0 - x * x }   # シグモイド関数の微分
  end

  def to_hash
    return {
      :hidden_num           => @hidden_num,
      :input_hidden_weight  => @input_hidden_weight.to_hash,
      :output_hidden_weight => @output_hidden_weight.to_hash,
    }
  end

  def feedforward(input_values)
    input_values  = input_values.merge(0 => 1.0) # バイアス
    hidden_values = self.feedforward_input_to_hidden(input_values)
    hidden_values = hidden_values.merge(0 => 1.0) # バイアス
    output_values = self.feedforward_hidden_to_output(hidden_values)
    return output_values
  end

  def feedforward_input_to_hidden(input_values)
    hidden_ids = (1..@hidden_num)
    input_ids  = input_values.keys

    return hidden_ids.inject({}) { |hidden_values, hidden_id|
      sum = input_ids.inject(0.0) { |result, input_id|
        value  = input_values[input_id]
        weight = @input_hidden_weight[input_id, hidden_id]
        result + (value * weight)
      }
      hidden_values[hidden_id] = @sigmoid[sum]
      hidden_values
    }
  end

  def feedforward_hidden_to_output(hidden_values)
    output_ids = @output_hidden_weight.from_keys
    hidden_ids = (0..@hidden_num)

    return output_ids.inject({}) { |output_values, output_id|
      sum = hidden_ids.inject(0.0) { |result, hidden_id|
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
    hidden_ids = (0..@hidden_num)
    output_ids = output_delta.keys

    return hidden_ids.inject({}) { |hidden_delta, hidden_id|
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
    input_ids  = input_values.keys
    hidden_ids = (1..@hidden_num)

    input_ids.each { |input_id|
      hidden_ids.each { |hidden_id|
        delta  = hidden_delta[hidden_id]
        value  = input_values[input_id]
        change = delta * value
        @input_hidden_weight[input_id, hidden_id] += n * change
      }
    }
  end

  def update_output_hidden_weight(output_delta, hidden_values, n)
    hidden_ids = (0..@hidden_num)
    output_ids = output_delta.keys

    hidden_ids.each { |hidden_id|
      output_ids.each { |output_id|
        delta  = output_delta[output_id]
        value  = hidden_values[hidden_id]
        change = delta * value
        @output_hidden_weight[output_id, hidden_id] += n * change
      }
    }
  end
end

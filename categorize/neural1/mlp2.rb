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
end

# 多層パーセプトロンニューラルネットワーク
class ThreeLayerPerceptronNetwork
end

if $0 == __FILE__
  weight = LinkWeight.new
  p weight
  p weight.get(1,2)
  p weight
  weight.set(3, 4, 1.0)
  p weight
  p weight.get(3, 4)
end

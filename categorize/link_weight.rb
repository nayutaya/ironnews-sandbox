
# リンクの重み

class LinkWeight
  def initialize(hash = {}, &block)
    @weight  = {}
    @default =
      if block_given?
        block
      else
        proc { rand }
      end

    hash.each { |(from, to), weight|
      self[from, to] = weight
    }
  end

  def [](from, to)
    @weight[from] ||= {}
    @weight[from][to] ||= @default[]
    return @weight[from][to]
  end

  def []=(from, to, weight)
    @weight[from] ||= {}
    @weight[from][to] = weight
    return weight
  end

  def from_keys
    return @weight.keys
  end

  def to_hash
    hash = {}
    @weight.each { |from, from_weight|
      from_weight.each { |to, weight|
        hash[[from, to]] = weight
      }
    }
    return hash
  end
end

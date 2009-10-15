#! ruby -Ku

class Dictionary
  def initialize
    @obj2id = {}
    @id2obj = {}
  end

  def encode(obj)
    return @obj2id[obj] ||
      begin
        id = @obj2id.size + 1
        @id2obj[id]  = obj
        @obj2id[obj] = id
        id
      end
  end

  def encode_multiple(collection)
    case collection
    when Array
      return collection.map { |obj|
        self.encode(obj)
      }
    when Hash
      return collection.inject({}) { |memo, (obj, value)|
        memo[self.encode(obj)] = value
        memo
      }
    else raise(ArgumentError)
    end
  end

  def decode(id)
    return @id2obj[id]
  end

  def decode_multiple(collection)
    case collection
    when Array
      return collection.map { |id|
        self.decode(id)
      }
    when Hash
      return collection.inject({}) { |memo, (id, value)|
        memo[self.decode(id)] = value
        memo
      }
    else raise(ArgumentError)
    end
  end
end

dict = Dictionary.new
p dict.encode("a")
p dict.encode("b")
p dict.encode("a")
p dict.encode("b")
p dict.encode(1)
p dict.encode_multiple(["a", "b", 1, 2])
p dict.encode_multiple({"a" => :a, "b" => :b, 1 => :one, 2 => :two})

p dict.decode(1)
p dict.decode(2)
p dict.decode(3)
p dict.decode_multiple([1, 2, 3, 5])
p dict.decode_multiple({1 => :a, 2 => :b, 3 => :one, 5 => :nil})

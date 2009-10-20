#! ruby -Ku

# オブジェクトとID（1～）を相互に変換する辞書

class Dictionary
  def initialize(hash = {})
    @obj2id = {}
    @id2obj = {}
    hash.each { |obj, id|
      @obj2id[obj] = id
      @id2obj[id]  = obj
    }
  end

  def to_hash
    return @obj2id.dup
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

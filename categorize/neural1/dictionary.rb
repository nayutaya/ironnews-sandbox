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

  def decode(id)
    return @id2obj[id]
  end
end

dict = Dictionary.new
p dict.encode("a")
p dict.encode("b")
p dict.encode("a")
p dict.encode("b")
p dict.encode(1)

p dict.decode(1)
p dict.decode(2)
p dict.decode(3)

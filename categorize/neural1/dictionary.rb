#! ruby -Ku

class Dictionary
  def initialize
    @table = {}
    @table2 = {}
  end

  def to(word)
    return @table[word] ||
      begin
        @table2[@table.size + 1] = word
        @table[word] = @table.size + 1
      end
  end

  def from(id)
    return @table2[id]
  end
end

dict = Dictionary.new
p dict.to("a")
p dict.to("b")
p dict.to("a")
p dict.to("b")

p dict.from(1)
p dict.from(2)
p dict.from(3)

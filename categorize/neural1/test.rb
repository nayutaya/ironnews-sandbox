#! ruby -Ku

require "tokenizer"
require "dictionary"
require "mlp2"

rail_titles1 = File.open("title_rail400a.txt") { |file| file.map { |line| line.chomp } }
rail_titles2 = File.open("title_rail400b.txt") { |file| file.map { |line| line.chomp } }
rest_titles1 = File.open("title_rest400a.txt") { |file| file.map { |line| line.chomp } }
rest_titles2 = File.open("title_rest400b.txt") { |file| file.map { |line| line.chomp } }

training_titles = []
training_titles += rail_titles1.map { |title| ["rail", title] }
training_titles += rest_titles1.map { |title| ["rest", title] }
srand(0)
training_titles = training_titles.sort_by { rand }

tokenizer = BigramTokenizer.new
input_dict  = Dictionary.new
output_dict = Dictionary.new

output_dict.encode("rail")
output_dict.encode("rest")

network = ThreeLayerPerceptronNetwork.new(10)

puts "init..."

training_data = []
training_titles.each { |category, title|
  tokens = tokenizer.tokenize(title)
  input_ids = input_dict.encode_multiple(tokens)
  output_id = output_dict.encode(category)
  input_values  = input_ids.inject({}) { |memo, id| memo[id] = 1.0; memo }
  output_values = {1 => 0.0, 2 => 0.0}.merge(output_id => 1.0)
  training_data << [input_values, output_values]
}

puts "training..."

10.times { |i|
  p i
  training_data.each { |input_values, output_values|
    network.backpropagation(input_values, output_values)
  }
}

puts "rail..."
File.open("out.rail", "wb") { |file|
  rail_titles2.each { |title|
    tokens = tokenizer.tokenize(title)
    input_ids = input_dict.encode_multiple(tokens)
    input_values = input_ids.inject({}) { |memo, id| memo[id] = 1.0; memo }
    results = network.feedforward(input_values)
    category = (results[1] > results[2] ? "rail" : "rest")
    file.printf("%s %s\n", category, title)
    #file.puts([results, title].inspect)
  }
}

puts "rest..."
File.open("out.rest", "wb") { |file|
  rest_titles2.each { |title|
    tokens = tokenizer.tokenize(title)
    input_ids = input_dict.encode_multiple(tokens)
    input_values = input_ids.inject({}) { |memo, id| memo[id] = 1.0; memo }
    results = network.feedforward(input_values)
    category = (results[1] > results[2] ? "rail" : "rest")
    file.printf("%s %s\n", category, title)
    #file.puts([results, title].inspect)
  }
}

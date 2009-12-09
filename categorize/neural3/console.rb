#! ruby -Ks

require "drb/drb"

uri = ARGV.shift
ts  = DRbObject.new(nil, uri)

loop {
  symbol, result = ts.take([:result, Hash])
  p result

  File.open("result.txt", "a") { |file|
    file.puts(result.inspect)
  }
}

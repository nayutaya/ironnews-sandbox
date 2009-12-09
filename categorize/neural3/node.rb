#! ruby -Ks

require "drb/drb"

uri = ARGV.shift
ts  = DRbObject.new(nil, uri)


ts.write([:result, {:hoge => :fuga}])

#! ruby -Ku

require "rinda/tuplespace"
require "drb/drb"

DRb.start_service(nil, Rinda::TupleSpace.new)
puts DRb.uri
$stdin.gets

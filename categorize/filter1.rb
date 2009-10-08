#! ruby -Ku

require "nkf"

def full_to_half(line)
  return NKF.nkf("-W8 -w80 -m0 -Z1", line)
end

STDIN.each { |line|
  line.chomp!
  line = full_to_half(line)
  STDOUT.puts(line)
}

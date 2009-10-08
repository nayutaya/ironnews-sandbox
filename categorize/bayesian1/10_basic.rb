#! ruby -Ku

require "nkf"

STDOUT.binmode

STDIN.each { |line|
  line = NKF.nkf("-W -w80 -m0 -Z1", line)
  line.strip!
  line.gsub!(/ +/, " ")
  STDOUT.puts(line)
}

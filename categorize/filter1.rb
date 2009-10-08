#! ruby -Ku

require "nkf"

def filter(line)
  #return NKF.nkf("-S -w80 -m0", NKF.nkf("-W8 -s -m0", line))
  return NKF.nkf("-W8 -w80 -m0 -Z1", line)
end

File.open("data/title_rail.txt", "r") { |infile|
  File.open("out1.txt", "w") { |outfile|
    infile.each { |line|
      outfile.write(filter(line))
    }
  }
}

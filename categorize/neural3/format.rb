#! ruby -Ku

STDIN.each { |line|
  value = eval(line)
  printf("%i\t%i\t%.2f\t%.2f\t%.2f\t%i\t%i\n",
    value[:hidden],
    value[:count],
    value[:weight],
    value[:rail],
    value[:rest],
    value[:time],
    value[:score])
}

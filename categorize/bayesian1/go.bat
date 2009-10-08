
rem copy out\00.rail out\00.rail.1
rem copy out\00.rest out\00.rest.1
copy ..\data\title_rail.txt    out\00.rail
copy ..\data\title_nonrail.txt out\00.rest

rem copy out\10.rail out\10.rail.1
rem copy out\10.rest out\10.rest.1
ruby 10_basic.rb < out\00.rail > out\10.rail
ruby 10_basic.rb < out\00.rest > out\10.rest

rem copy out\11.rail out\11.rail.1
rem copy out\11.rest out\11.rest.1
ruby 11_alphabet.rb < out\10.rail > out\11.rail
ruby 11_alphabet.rb < out\10.rest > out\11.rest

rem copy out\12.rail out\12.rail.1
rem copy out\12.rest out\12.rest.1
ruby 12_sign.rb < out\11.rail > out\12.rail
ruby 12_sign.rb < out\11.rest > out\12.rest

rem copy out\14.rail out\14.rail.1
rem copy out\14.rest out\14.rest.1
ruby 14_sort.rb < out\12.rail > out\14.rail
ruby 14_sort.rb < out\12.rest > out\14.rest

rem copy out\20.rail out\20.rail.1
rem copy out\20.rest out\20.rest.1
ruby 20_bigram.rb < out\14.rail > out\20.rail
ruby 20_bigram.rb < out\14.rest > out\20.rest

rem copy out\30.rail out\30.rail.1
rem copy out\30.rest out\30.rest.1
ruby 30_frequency.rb < out\20.rail > out\30.rail
ruby 30_frequency.rb < out\20.rest > out\30.rest


set DBNAME=crosstest1.db
set THRESHOLDS=rail 0.1 rest 0.5

del %DBNAME%

ruby train.rb %DBNAME% rail ..\sample_rail_500_a.txt rest ..\sample_rest_500_a.txt

ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\sample_rail_500_a.txt  > crosstest1.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\sample_rest_500_a.txt >> crosstest1.txt
ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\sample_rail_500_b.txt >> crosstest1.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\sample_rest_500_b.txt >> crosstest1.txt

del %DBNAME%


set DBNAME=crosstest2.db
set THRESHOLDS=rail 1.0 rest 3.5

del %DBNAME%

ruby train.rb %DBNAME% rail < ..\data\rail.txt
ruby train.rb %DBNAME% rest < ..\data\rest.txt

ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\data\rail.txt  > crosstest2.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\data\rest.txt >> crosstest2.txt

del %DBNAME%


set DBNAME=out.full.db
set THRESHOLDS=rail 1.0 rest 3.5
ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\data\rail.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\data\rest.txt


set DBNAME=out.full.db
set THRESHOLDS=rail 1.0 rest 3.5
ruby classify.rb %DBNAME% %THRESHOLDS% < ..\data\rail.txt

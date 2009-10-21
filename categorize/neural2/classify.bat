
set DBNAME=out.full.db
set THRESHOLDS=rail 0.1 rest 0.5
ruby classify.rb %DBNAME% %THRESHOLDS% < ..\data\rail2.txt

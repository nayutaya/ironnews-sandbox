
set DBNAME=out.full.db
set THRESHOLDS=rail 0.1 rest 0.3
ruby classify.rb %DBNAME% %THRESHOLDS% < unknown.txt

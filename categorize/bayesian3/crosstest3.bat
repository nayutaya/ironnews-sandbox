
set DBNAME=crosstest3.db
set THRESHOLDS=rail 1.0 rest 3.5

del %DBNAME%
del rail.txt
del rest.txt

type ..\..\..\ironnews-data\news_url_title\rail.txt >> rail.txt
type ..\..\..\ironnews-data\news_url_title\rest.txt >> rest.txt
type ..\..\..\ironnews-data\news_title\rail_*.txt >> rail.txt
type ..\..\..\ironnews-data\news_title\rest_*.txt >> rest.txt

ruby train.rb %DBNAME% rail < rail.txt
ruby train.rb %DBNAME% rest < rest.txt

ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\..\..\ironnews-data\news_url_title\rail.txt  > crosstest3.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\..\..\ironnews-data\news_url_title\rest.txt >> crosstest3.txt

del %DBNAME%
del rail.txt
del rest.txt

pause


set DBNAME=crosstest2.db
set THRESHOLDS=rail 0.1 rest 0.3

del %DBNAME%
del rail.txt
del rest.txt

type ..\..\..\ironnews-data\news_url_title\rail.txt >> rail.txt
type ..\..\..\ironnews-data\news_url_title\rest.txt >> rest.txt
type ..\..\..\ironnews-data\news_title\rail_*.txt >> rail.txt
type ..\..\..\ironnews-data\news_title\rest_*.txt >> rest.txt

ruby train.rb %DBNAME% rail rail.txt rest rest.txt

ruby crosstest.rb %DBNAME% rail %THRESHOLDS% < ..\..\..\ironnews-data\news_url_title\rail.txt  > crosstest2.txt
ruby crosstest.rb %DBNAME% rest %THRESHOLDS% < ..\..\..\ironnews-data\news_url_title\rest.txt >> crosstest2.txt

del %DBNAME%
del rail.txt
del rest.txt

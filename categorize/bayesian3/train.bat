
set DBNAME=out.full.db
del %DBNAME%
ruby train.rb %DBNAME% rail < ..\data\rail.txt
ruby train.rb %DBNAME% rail < ..\data\rail2.txt
ruby train.rb %DBNAME% rest < ..\data\rest.txt
ruby train.rb %DBNAME% rest < ..\data\rest2.txt


set DBNAME=out.full.db
del %DBNAME%
ruby train.rb %DBNAME% rail ..\data\rail2.txt rest ..\data\rest2.txt

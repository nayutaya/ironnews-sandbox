
set BAYESIAN_DBNAME=..\bayesian3\out.full.db
set BAYESIAN_THRESHOLDS=rail 1.0 rest 3.5

ruby ..\bayesian3\classify.rb %BAYESIAN_DBNAME% %BAYESIAN_THRESHOLDS% < in
rename out.rail    out.bayesian.rail
rename out.rest    out.bayesian.rest
rename out.unknown out.bayesian.unknown

set NEURAL_DBNAME=..\neural2\out.full.db
set NEURAL_THRESHOLDS=rail 0.1 rest 0.3

ruby ..\neural2\classify.rb %NEURAL_DBNAME% %NEURAL_THRESHOLDS% < out.bayesian.rail
rename out.rail    out.rail.rail
rename out.rest    out.rail.rest
rename out.unknown out.rail.unknown
del out.bayesian.rail

ruby ..\neural2\classify.rb %NEURAL_DBNAME% %NEURAL_THRESHOLDS% < out.bayesian.rest
rename out.rail    out.rest.rail
rename out.rest    out.rest.rest
rename out.unknown out.rest.unknown
del out.bayesian.rest

ruby ..\neural2\classify.rb %NEURAL_DBNAME% %NEURAL_THRESHOLDS% < out.bayesian.unknown
rename out.rail    out.unknown.rail
rename out.rest    out.unknown.rest
rename out.unknown out.unknown.unknown
del out.bayesian.unknown

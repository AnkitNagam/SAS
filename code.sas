data pubg;
infile "s:\My SAS Files\9.4\project\Dataset_Ankit_Nagam.csv" delimiter = ',' firstobs = 2;
input solo_Rating	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	solo_RoundsPlayed	solo_Wins	solo_Losses	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_WeaponAcquired	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt;
run;
proc print data = pubg;
run;

*creating dummy variable; 
title "dummy variables";
data pubg;
set pubg;
d1_swa = (solo_WeaponAcquired = 1);
d2_swa = (solo_WeaponAcquired = 2);
run;
 

*creating intreaction terms;
title "interaction terms";
data pubg;
set pubg;
inter_wins_losses = solo_Wins*solo_Losses;
inter_dist_walk = solo_TimeSurvived*solo_WalkDistance;
run;


*transforming solo_rating variable;
title "setting solo_rating";
data pubg_trans;
set pubg;
ln_rating = log(solo_Rating);
run;


*centering variables;
title "centering variables";
data pubg_trans_c;
set pubg_trans;
c_solo_RoundsPlayed = 45.0000000 - solo_RoundsPlayed;
run;

*descriptives;
title "Descrptives";
proc means min P25 P50 P75 max data =  pubg_trans_c;
var solo_Rating	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk;
run;

*frequency;
title "frequencty table";
proc freq data = pubg_trans_c;
run;


*associations b/w variables;
title "scatterplot";
proc sgscatter data = pubg;
matrix solo_Rating	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	solo_RoundsPlayed	solo_Wins solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk;
run;

*histogram;
Title "Histogram of Y variable";
proc univariate data= pubg normal;
var solo_rating;
histogram/normal(mu=est sigma=est);
run;

*histogram;
Title "Histogram of transformed Y variable";
proc univariate data=pubg_trans normal;
var ln_rating;
histogram/normal(mu=est sigma=est);
run;

*associations b/w transformed Y and x-variables;
title "scatterplot";
proc sgscatter data = pubg_trans_c;
matrix ln_rating solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk;
run;


*associations b/w significant variables;
title "scatterplot";
proc sgscatter data = influencer_set9;
matrix ln_rating  solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance solo_DamageDealt inter_wins_losses inter_dist_walk;
run;

*correlationc btw variables;
title "correlationc btw variables";
proc corr data = pubg_trans_c;
var ln_rating solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk;
run;


*correlation on significant variables;
title "correlationc btw significant variables";
proc corr data =  influencer_set9;
var ln_rating  solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance solo_DamageDealt inter_wins_losses inter_dist_walk;
run;

*checking for mutlicollinearity;
title " vif, tol, stb on all variables";
proc reg data=pubg;
model solo_rating = solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/tol vif;
run;


*initial model, removed solo_losses because solo_roundsplayed - solo_wins = solo_losses;
title "full regression model";
proc reg data = pubg_trans_c;
model solo_Rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk;
run;


*intial model with transformation;
title "intial regression model with forward selection method & transformed y";
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = forward;
run;


*intial model with transformation;
title "intial regression model with backward selection method & transformed y";
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = backward;
run;


*intial model with transformation;
title "intial regression model with stepwise selection method & transformed y";
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = stepwise;
run;


*intial model with transformation;
title "intial regression model with adjrsq selection method & transformed y";
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = adjrsq;
run;



*intial model with transformation;
title "intial regression model with cp selection method & transformed y ";
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = cp;
run;



*model selection methods;
title " final model- stepwise after removing outliers and influential points";
proc reg data=influencer_set9;
model ln_rating = solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = stepwise;
run;


*analyze residuals on full model;
proc reg data = pubg_trans_c;
model ln_rating =	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/r influence;
plot student.*(	solo_KillDeathRatio	solo_WinRatio	solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk);
plot student.*predicted.;
plot npp.*student.;
run;

 *model analysis with options r, influence;
title "r, influence";
proc reg data=influencer_set9;
model ln_rating = solo_KillDeathRatio	solo_WinRatio solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = stepwise r influence;
run;


*model analysis with options vif, tol , stb on significant variables;
title " vif, tol, stb ";
proc reg data=influencer_set9;
model ln_rating = solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance solo_DamageDealt inter_wins_losses inter_dist_walk/ tol vif stb;
run;


*removing outliers and influence points set1;
data influencer;
set pubg_trans_c;
if _n_ = 5 then delete;
if _n_ = 1163 then delete;
if _n_ = 1206 then delete;
if _n_ = 1409 then delete;
if _n_ = 2212 then delete;
run;


*removing outliers and influence points set2;
data influencer_set2;
set influencer;
if _n_ = 2614 then delete;
if _n_ = 2542 then delete;
if _n_ = 2460 then delete;
if _n_ = 2208 then delete;
if _n_ = 1406 then delete;
if _n_ = 1204 then delete;
if _n_ = 1162 then delete;
if _n_ = 390 then delete;
run;



*removing outliers and influence points set3;
data influencer_set3;
set influencer_set2;
if _n_ = 2787 then delete;
if _n_ = 2606 then delete;
if _n_ = 2396 then delete;
if _n_ = 2354 then delete;
if _n_ = 1980 then delete;
if _n_ = 1548 then delete;
if _n_ = 1517 then delete;
if _n_ = 1237 then delete;
if _n_ = 111 then delete;
if _n_ = 70 then delete;
if _n_ = 30 then delete;
if _n_ = 16 then delete;
if _n_ = 10 then delete;
if _n_ = 2 then delete;
run;

*removing outliers and influence points set4;
data influencer_set4;
set influencer_set3;
if _n_ = 158 then delete;
if _n_ = 168 then delete;
if _n_ = 178 then delete;
if _n_ = 180 then delete;
if _n_ = 486 then delete;
if _n_ = 609 then delete;
if _n_ = 678 then delete;
if _n_ = 1302 then delete;
if _n_ = 1690 then delete;
if _n_ = 1935 then delete;
if _n_ = 349 then delete;
if _n_ = 363 then delete;
if _n_ = 369 then delete;
if _n_ = 405 then delete;
if _n_ = 846 then delete;
if _n_ = 852 then delete;
if _n_ = 1308 then delete;
if _n_ = 1318 then delete;
if _n_ = 2679 then delete;
if _n_ = 2691 then delete;
run;


*removing outliers and influence points set5;
data influencer_set5;
set influencer_set4;
if _n_ = 990 then delete;
if _n_ = 940 then delete;
if _n_ = 461 then delete;
if _n_ = 224 then delete;
if _n_ = 199 then delete;
if _n_ = 125 then delete;
if _n_ = 128 then delete;
if _n_ = 22 then delete;
if _n_ = 23 then delete;
if _n_ = 8 then delete;


*removing outliers and influence points set6;
data influencer_set6;
set influencer_set5;
if _n_ = 2257 then delete;
if _n_ = 1806 then delete;
if _n_ = 1814 then delete;
if _n_ = 1551 then delete;
if _n_ = 1533 then delete;
if _n_ = 1344 then delete;
if _n_ = 1168 then delete;
if _n_ = 1123 then delete;
if _n_ = 939 then delete;
if _n_ = 586 then delete;
if _n_ = 430 then delete;
if _n_ = 283 then delete;
if _n_ = 297 then delete;
if _n_ = 228 then delete;
if _n_ = 186 then delete;
if _n_ = 150 then delete;
if _n_ = 8 then delete;
if _n_ = 17 then delete;
if _n_ = 12 then delete;
if _n_ = 42 then delete;



*removing outliers and influence points set7;
data influencer_set7;
set influencer_set6;
if _n_ = 11 then delete;
if _n_ = 43 then delete;
if _n_ = 32 then delete;
if _n_ = 36 then delete;
if _n_ = 70 then delete;
if _n_ = 67 then delete;
if _n_ = 185 then delete;
if _n_ = 229 then delete;
if _n_ = 276 then delete;
if _n_ = 393 then delete;
if _n_ = 464 then delete;
if _n_ = 539 then delete;
if _n_ = 633 then delete;
if _n_ = 715 then delete;
if _n_ = 938 then delete;
if _n_ = 978 then delete;
if _n_ = 1132 then delete;
if _n_ = 1453 then delete;
if _n_ = 1899 then delete;
if _n_ = 1946 then delete;
if _n_ = 2835 then delete;
if _n_ = 2800 then delete;
if _n_ = 2724 then delete;
if _n_ = 2577 then delete;
if _n_ = 2262 then delete;
run;



*removing outliers and influence points set8;
data influencer_set8;
set influencer_set7;
if _n_ = 2898 then delete;
if _n_ = 2620 then delete;
if _n_ = 2438 then delete;
if _n_ = 2221 then delete;
if _n_ = 2088 then delete;
if _n_ = 1863 then delete;
if _n_ = 1854 then delete;
if _n_ = 1824 then delete;
if _n_ = 1645 then delete;
if _n_ = 1587 then delete;
if _n_ = 1421 then delete;
if _n_ = 1423 then delete;
if _n_ = 1320 then delete;
if _n_ = 685 then delete;
if _n_ = 578 then delete;
if _n_ = 436 then delete;
if _n_ = 238 then delete;
if _n_ = 140 then delete;
if _n_ = 2673 then delete;
if _n_ = 2040 then delete;
if _n_ = 1993 then delete;
if _n_ = 1133 then delete;
if _n_ = 1064 then delete;
if _n_ = 930 then delete;
if _n_ = 58 then delete;
if _n_ = 65 then delete;
run;


*removing outliers and influence points set9;
data influencer_set9;
set influencer_set8;
if _n_ = 2487 then delete;
if _n_ = 2414 then delete;
if _n_ = 2385 then delete;
if _n_ = 2389 then delete;
if _n_ = 2075 then delete;
if _n_ = 1756 then delete;
if _n_ = 1716 then delete;
if _n_ = 1653 then delete;
if _n_ = 1072 then delete;
if _n_ = 932 then delete;
if _n_ = 929 then delete;
if _n_ = 818 then delete;
if _n_ = 815 then delete;
if _n_ = 809 then delete;
if _n_ = 741 then delete;
if _n_ = 526 then delete;
if _n_ = 407 then delete;
run;

*analyze residuals on significant variables;
title "residuals on significant variables";
proc reg data = influencer_set9;
model ln_rating =	solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance	solo_DamageDealt inter_wins_losses inter_dist_walk/r influence;
plot student.*(	solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance solo_DamageDealt inter_wins_losses inter_dist_walk);
plot student.*predicted.;
plot npp.*student.;
run;


*test and train;
title "test and train";
proc surveyselect data = influencer_set9 out = test1 seed = 1926239 samprate = 0.75 outall;
run;
proc print data = test1;
run;

*setting selected to new_rating;
title "new_rating = ln_rating";
data test1;
set test1;
if selected then new_rating = ln_rating;
run;
proc print data = test1;
run;

*training set model;
title "traning set model";
proc reg data = test1; 
model new_rating = solo_KillDeathRatio	solo_WinRatio solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk/ selection = stepwise;
run;
proc print data = test1;
run;

*predicting values for the missing new_rating in test set;
title "yhat";
proc reg data = test1; 
model new_rating = solo_KillDeathRatio	solo_TimeSurvived c_solo_RoundsPlayed	solo_Wins solo_HeadshotKills solo_RoundMostKills solo_AvgSurvivalTime solo_WinPoints solo_WalkDistance solo_DamageDealt inter_wins_losses inter_dist_walk/ p clm cli;
output out = pred (where= (new_rating=.)) p= yhat;
run;
proc print data = pred;
run;

*summarizing the results of cross-validation;
title "difference btw obs and pred";
data cv;
set pred;
diff = ln_rating - yhat;
absd = abs(diff);
run;


*computing predictive statistics: rmse and mae;
title " rmse and mae";
proc summary data = cv;
var diff absd;
output out = cv1 std(diff)= rmse mean(absd)= mae;
run;
proc print data = cv1;
run;

*corr for obs and pred;
title "corr for obs and pred";
proc corr data = cv;
var ln_rating yhat;
run;


*5 fold cross validation;
title "5 fold cv";
proc glmselect data = influencer_set9 plots = (asePlot Criteria);
partition fraction(test = 0.25);
model ln_rating = solo_KillDeathRatio	solo_WinRatio solo_TimeSurvived	c_solo_RoundsPlayed	solo_Wins	solo_Kills	solo_Assists	solo_Suicides	solo_HeadshotKills	solo_VehicleDestroys	solo_RoundMostKills	solo_AvgSurvivalTime	solo_WinPoints	solo_WalkDistance	solo_DamageDealt d1_swa d2_swa inter_wins_losses inter_dist_walk
/ selection = stepwise(stop = cv) cvMethod = split(5) cvdetails = all;
run;



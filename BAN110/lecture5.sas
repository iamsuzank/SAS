/* 1. Sum and Average are pretty handy derived variables */
data Scores;
	length ID $ 3;
	input ID $ Score1-Score3;
	Min_Score=min(Score1, Score2, Score3);
	datalines;
1,0,95,98;
2 78 77 75
3 88 91 92
4 80 75 55
5 66 87 93
6 78 88 98
7 62 82 72
;




proc print data=Scores;
run;

/* 2. Another way to find minimum is by using of */
data Scores;
	length ID $ 3;
	input ID $ Score1-Score3;
	Min_Score=min(of Score1-Score3);
	datalines;
1 90 95 98
2 78 77 75
3 88 91 92
4 80 75 55
5 66 87 93
6 78 88 98
7 62 82 72
;

	/* 3. Finding minimum for the whole column */
data Scores;
	length ID $ 3;
	input ID $ Score1-Score3;
	Min_Score=min(Score1, Score2, Score3);
	datalines;
1 90 95 98
2 78 77 75
3 88 91 92
4 80 75 55
5 66 87 93
6 78 88 98
7 62 82 72
;

proc sort data=Scores;
	by Min_Score;
run;

proc print data=Scores (obs=1);
	var ID Min_Score;
run;

/* 4. Another way of finding the minimum value is using proc means */
data Scores;
	length ID $ 3;
	input ID $ Score1-Score3;
	Min_Score=min(Score1, Score2, Score3);
	datalines;
1 90 95 98
2 78 77 75
3 88 91 92
4 80 75 55
5 66 87 93
6 78 88 98
7 62 82 72
;

proc means data=Scores maxdec=2;
	var Min_Score;
run;

/* 4. Simple Derived variables are the
variables that are created normally from other variables */
data Class;
	set SASHELP.Class;
	BMI=Height / Weight;
run;

proc print data=Class;
run;

/* 5. Find all Males that are > 13 years old and
have a BMI of > 0.5 */
data Class;
	set SASHELP.Class;
	BMI=Height / Weight;
run;

proc print data=Class;
	where Sex='M' and Age > 13 and BMI > 0.5;
run;

/* 3. Relative Derived variables help in studying different
variations on a variable */
DATA class;
	FORMAT ID 8.;
	SET sashelp.class(KEEP=weight);
	ID=_N_;
	Weight_Shift=Weight-100.03;
	Weight_Ratio=Weight/100.03;
	Weight_CentRatio=(Weight-100.03)/100.03;
RUN;

proc sgplot data=class;
	histogram Weight;
	density Weight;
run;

proc sgplot data=class;
	histogram Weight_Shift;
	density Weight_Shift;
run;

proc sgplot data=class;
	Histogram Weight_Ratio;
	density Weight_Ratio;
run;

proc sgplot data=class;
	Histogram Weight_CentRatio;
	density Weight_CentRatio;
run;

/* 4. Binning in groups is an important task at times */
proc rank data=sashelp.air groups=10 out=air ties=dense;
	var air;
	ranks air_grp;
run;

proc print data=air;
run;

/* 5. In order to design your own groups, you can use IF ELSE IF */
data individual_groups;
	set SASHELP.AIR;

	if Air <=220 then
		Air_Group='Group1';
	else if Air >220 and Air <=275 then
		Air_Group='Group2';
	else if Air > 275 then
		Air_Group='Group3';
run;

proc print data=individual_groups;
run;

/* 6. Missing Values can create problems in analysis */
data missing_test;
	Input Marks;

	if marks=. then
		Grade='NA';
	else if marks >=90 then
		Grade='A';
	else if marks >=80 then
		Grade='B';
	else if marks >=70 then
		Grade='C';
	else if marks >=60 then
		Grade='D';
	else if marks < 60 then
		Grade='F';
	Datalines;
70
88
.
90
.
65
;

proc print data=missing_test;
run;

/* 7. It is important to replace the missing values or deal with them properly. One of the ways of replacing missing
values is by using Proc standard which would replace the missing values by the mean. */
data missing_test;
	Input Marks;
	Datalines;
70
88
.
90
.
65
;

proc Standard data=missing_test Replace out=missing_test_fixed;
	var marks;
run;

data missing_test_final;
	set missing_test_fixed;

	if marks >=90 then
		Grade='A';
	else if marks >=80 then
		Grade='B';
	else if marks >=70 then
		Grade='C';
	else if marks >=60 then
		Grade='D';
	else if marks < 60 then
		Grade='F';
run;

proc print data=missing_test_final;
run;

/* 8. Values for mean can be specified as well: */
proc Standard data=missing_test replace out=missing_test_fixed mean=70;
	var marks;
run;

/* 9. Calculate the average age at death */
/*  */
/* First find number of missing values to see
how many missing values are there for that column */
proc means data=SASHELP.HEART NMISS N;
run;

/* Replace all the missing values by mean of values */
proc Standard data=SASHELP.Heart replace out=heart_no_miss;
	var AgeAtDeath;
run;

/* Set format to have only whole numbers for that column
and keep only Sex column with it */
data heart_final;
	set heart_no_miss(keep=Sex AgeAtDeath);
	Format AgeAtDeath 3.;
run;

/* Use Proc means to show the result */
title "Average Age at Death";

proc means data=heart_final mean maxdec=1;
run;
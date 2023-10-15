Data UCL_Score;
	length Teams $10;
	input Teams $ score1-score3;
	Sum1=score1+score2+score3;
	Sum2=sum(score1, score2, score3);
	Sum3=mean(score1, score2, score3);
	Minimum=min(score1, score2, score3);
	Maximum=max(score1, score2, score3);

	/* find the second highest score */
	Max_2nd=largest(2, of score1-score3);
	highest=largest(1, of score1-score3);

	/* find 3rd smallest number in score */
	min_3rd=smallest(3, of score1-score3);
	datalines;
Barcelona 4 2 1
Madrid    1 3 0
Atletico  1 2 3  
City      2 1 3

;
run;

/* find the smallest score among all the score */
proc sort data=UCL_Score out=smallest_score;
	by Minimum;

proc print data=Ucl_score;
run;

title'method1:Smallest score';

proc print data=smallest_score (obs=1);
run;

/* method2 */
proc means data=Ucl_score min maxdec=2;
	var Minimum;
run;

/* data Score; */
/* Input ID $ Score1-Score3; */
/* Total = Score1 +Score2+ Score3; */
/* total_Sum= sum(Score1,Score2,Score3); */
/* -------------------------------------------------------------------- */
/* 4. Simple Derived variables are the variables that
are created normally from other variables */
data Personal_Info;
	set sashelp.class;
	BMI=Height/Weight;

	if Sex='M' and age>13 and BMI>0.5;
run;

/* 5. Find all Males that are > 13 years old and
have a BMI of > 0.5 */
proc print data=Personal_Info;
	/* where Sex = 'M' and age>13 and BMI>0.5; */
run;

/* 3. Relative Derived variables help in studying different variations on a variable */
data personal_info;
	set sashelp.class;
	weight_shift=weight-100.03;
	weight_ratio=weight/100.03;
	weight_centRatio=(weight-100.03)/100.03;
run;

title 'before shift';

proc sgplot data=personal_info;
	histogram weight;
	density weight;
run;

title "after shift";

proc sgplot data=personal_info;
	histogram weight_shift;
	density weight_shift;
run;

proc print data=personal_info;
run;

proc sgplot data=personal_info;
	Histogram weight_centRatio;
	density weight_centRatio;
run;

/* ---------------------------------------------------------- */
/* 4. Binning in groups is an important task at times */
data AirData;
	set sashelp.air;
run;

proc print data=airdata;
run;

/* making the different groups of air dataset according to its air values */
proc rank data=airdata groups=3 out=Grouped_AirData ties=dense;
	var air;
	ranks Air_Group;
run;

/* Making our own group and name it */
data newAirdata;
	set sashelp.air;

	if air <=200 then
		Group='A';
	else if air>200 and air<250 then
		Group='B';
	else
		Group='C';
run;

proc print data=newAirdata;
run;

/* ---------------------------------------------------------------------- */
/* data Missing_Test; */
/* Input Marks; */
/*  */
/* if marks = . then Grade= "na"; */
/* else  if marks>=90 then Grade="A"; */
/* else if marks>=80 then Grade="B"; */
/* else if Grade="Pass"; */
/*  */
/*  */
/* Datalines; */
/* 90 */
/* 70 */
/* . */
/* . */
/*  */
/* 30 */
/* . */
/* 50 */
/* 60 */
/* ; */
/*  */
/* proc print data=missing_test;run; */
/*  */
/*  */
/*  */
/* data HeartData; */
/* set sashelp.Heart; */
/* var AgeAtDeath; */
/*  */
/* run; */
/*  */
/* proc means data=HeartData NMISS N; */
/*  */
/*  */
/* proc print data = HeartData (obs=20); run; */
/*  */
/* proc standard data =HeartData replace ; */
/* age=round(AgeAtDeath, 0.1); */
/* var  Sex age; */
/* run; */
/* 4. Binning in groups is an important task at times */
/*  */
/* proc rank data = sashelp.air groups=10 out=air ties=dense; */
/* 	var air; */
/* 	ranks air_grp; */
/* run; */
/*  */
/*  */
/* proc print data=air; */
/* run; */
/*  */
/* 5. In order to design your own groups, you can use IF ELSE IF */
/*  */
/* data individual_groups; */
/* 	set SASHELP.AIR; */
/* 	 */
/* 	if Air <=220 then Air_Group = 'Group1'; */
/* 	else if Air >220 and Air <=275 then Air_Group = 'Group2'; */
/* 	else if Air > 275 then Air_Group = 'Group3'; */
/* 	 */
/* run; */
/*  */
/*  */
/* proc print data=individual_groups; */
/* run; */
/*  */
/* 6. Missing Values can create problems in analysis */
/*  */
/* data missing_test; */
/* 	Input Marks; */
/* 	 */
/* 	if marks = . then Grade = 'NA'; */
/* 	else if marks >=90 then Grade = 'A'; */
/* 	else if marks >=80 then Grade = 'B'; */
/* 	else if marks >=70 then Grade = 'C'; */
/* 	else if marks >=60 then Grade = 'D'; */
/* 	else if marks < 60 then Grade = 'F'; */
/* 	 */
/*  */
/* Datalines; */
/* 70 */
/* 88 */
/* . */
/* 90 */
/* . */
/* 65 */
/* ; */
/*  */
/* proc print data=missing_test; */
/* run; */
/*  */
/* 7. It is important to replace the missing values or deal with them properly. One of the ways of replacing missing values is by using Proc standard which would replace the missing values by the mean. */
/*  */
/* data missing_test; */
/* 	Input Marks; */
/*  */
/* Datalines; */
/* 70 */
/* 88 */
/* . */
/* 90 */
/* . */
/* 65 */
/* ; */
/*  */
/* proc Standard data=missing_test Replace out=missing_test_fixed; */
/* 	var marks; */
/* run; */
/*  */
/* data missing_test_final; */
/* 	set missing_test_fixed; */
/* 	 */
/* 	if marks >=90 then Grade = 'A'; */
/* 	else if marks >=80 then Grade = 'B'; */
/* 	else if marks >=70 then Grade = 'C'; */
/* 	else if marks >=60 then Grade = 'D'; */
/* 	else if marks < 60 then Grade = 'F'; */
/* run; */
/*  */
/* proc print data=missing_test_final; */
/* run; */
/*  */
/* 8. Values for mean can be specified as well: */
/*  */
/* proc Standard data=missing_test replace out=missing_test_fixed mean=70; */
/* 	var marks; */
/* run; */
/*  */
/*  */
/* 9. Calculate the average age at death */
/*  */
/* First find number of missing values to see how many missing values are there for that column */
/*  */
/* proc means data=SASHELP.HEART NMISS N; */
/* run; */
/*  */
/* Replace all the missing values by mean of values */
/*  */
/* proc Standard data=SASHELP.Heart replace out=heart_no_miss ; */
/* 	var AgeAtDeath; */
/* 	 */
/* run; */
/*  */
/* Set format to have only whole numbers for that column and keep only Sex column with it */
/*  */
/* data heart_final; */
/* 	set heart_no_miss(keep= Sex AgeAtDeath); */
/* 	 */
/* 	Format AgeAtDeath 3.; */
/* 	 */
/* run; */
/*  */
/* Use Proc means to show the result */
/*  */
/* title "Average Age at Death"; */
/* proc means data=heart_final mean maxdec=1; */
/* 	 */
/* run; */
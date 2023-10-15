/* libname patientsData '/home/u63049952/BAN110ZAA/Week3/Patients.txt'; */

data week3;
	infile '/home/u63049952/BAN110ZAA/Week3/Patients.txt';
input @1 Patno $3.
	  @4 Account_No $7.
	  @11 Gender $1.
	  @12 Visit mmddyy10.
	  @22 HR 3.
	  @25 SBP 3.
	  @28 DBP 3.
	  @31 Dx 7.
	  @38 AE 1.;
	 Format Visit mmddyy10.;
	 Gender = upcase(Gender);
/* 	always copy the main dataset. don't use the original dataset you can change your data  */
run;


/* making copy of the original dataset */
data copy_week3;
	set week3(keep=Account_No Gender Visit HR); 	 
/* 	where Gender = 'F';  */
 
/* 	subsetting the dataset where there are data of only female */
/* 	if Gender = 'F' or 'f'; */
	/* 	 if can be use with only data block   */
/* 	where Gender in ('F','f'); */
run;
	
proc print data= copy_week3;

/* where gender in ('f','F'); */
/* where can be used both in proc and data block */
run;




/* --------------------------------------------------------------------------------- */
/* copying the mater dataset into two sub data sets MAles and Females */
data Males Females;
	set week3;
	
/* 	dividing or splitting the dataset according to the gender*/
if Gender = 'M' or 'm' then output Males;
else if Gender = 'F' or 'f' then output Females;

title "Male dataset";
proc print data = Males;
run;

title "Female dataset";
proc print data = Females;
run;


/* ------------------------------------------------------------------------------------------------ */

/* Merging / Joining two dataset; */

data One;
	input Id Year Population;
		Datalines;
		  1 2010 1234
	      2 2011 4456
		  4 2012 5567
		  3 2013 7910
		;
		
/* 	before merging we have to sort dataset */
proc sort data = One;
 by Year;
 run;



data Two;
	input Id Year Population;
datalines;
5 2014 1234
1 2015 4567
2 2016 7778
;


proc sort data = Two;
 by Year;
 run;
 
/* comibine data one and two in Combine dataset */
data Combine;
merge One Two;
by Year;
run;

proc print data = One;
run;
/* 1. Simple Random Sampling will randomly samples the data */

data Patients;
	infile '/home/u63049952/BAN110ZAA/lib_patients/Patients.txt';
	
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
run;

proc surveyselect data=Patients method=srs sampsize=50 out=sample_data;
	id Patno VisitDate Gender HR SBP;
run;

proc print data=sample_data;
run;

/* proc surveyselect data=patients method=srs out=sample_2 sampsize=10; */
/* id patno Gender; */
/* run; */
/* proc print; */

/* 2. Two samples can be created from one dataset using reps = 2 */

proc surveyselect data=Patients method=srs sampsize=50 out=sample_data reps=2;
	id Patno VisitDate Gender HR SBP;
run;

proc print data=sample_data;
run;

/* Above can then be placed into two separate datasets using replicate column */

data sample_data_1 sample_data_2;
	set sample_data;
	
	if replicate = 1 then output sample_data_1;
	else if replicate = 2 then output sample_data_2;
run;

/* 3. Samples can be generated using percentages */

proc surveyselect data=Patients method=srs samprate=0.5 out=sample_data;
	id Patno VisitDate Gender HR SBP;
run;

proc print data=sample_data;
run;


/* 4. Proc SQL can be used to generate random samples as well */

proc SQL;
	Create Table Sample_Data_SQL as
		select * from Patients where ranuni(1234) lt 0.9;
quit;

proc print data=sample_data_sql;
run;

/* 5. To limit the number of observations outobs can be used */

proc SQL outobs=50;
	Create Table Sample_Data_SQL as
		select * from Patients where ranuni(1234) lt 0.5;
quit;

/* 6. Stratified sampling works by keeping the strata close to equal  */
proc sort data=patients;
by patno;
run;

/* proc freq data=Patients order=freq; */
/* 	tables Gender * HR/crosslist out=stat; */
/* 	by patno; */
/* run; */

proc sort data=Patients;
	by Gender;
run;

proc surveyselect data=Patients method=srs samprate=0.5 out=sample_data;
	id Patno VisitDate Gender HR SBP;
	strata Gender;
run;


proc freq data=sample_data;
	tables Gender;
run;

/* 7. Using Proc SQL to generate Stratified Sampling */

proc sql;
	Create Table sample_data_male as
	select * from Patients where Gender = 'M' and ranuni(1234) < 0.5;
quit;

proc sql;
	Create Table sample_data_female as
	select * from Patients where Gender = 'F' and ranuni(1234) < 0.5;
quit;


proc surveyselect data=patients method=srs samprate=0.5 
out=sample_data_female_2(where=(gender='F'));
run;

proc sql;
	Create Table sample_data_strat as
	select * from sample_data_male union all select * from sample_data_female;
quit;

proc freq data=sample_data_strat;
	tables Gender / out=data(drop=percent) nocum nopercent ;
run;


/* 8. Proc compare helps in comparing datasets */

data One;
	infile "/home/u50479107/BAN110ZAA/file_1.txt";
	input @1 Patno 3.
		  @4 Gender $1.
		  @5 DOB mmddyy8.
		  @13 SBP 3.
		  @16 DBP 3.;
	format DOB mmddyy10.;
run;

data Two;
	infile "/home/u50479107/BAN110ZAA/file_2.txt";
	input @1 Patno 3.
		  @4 Gender $1.
		  @5 DOB mmddyy8.
	 	  @13 SBP 3.
		  @16 DBP 3.;
	format DOB mmddyy10.;
run;

proc compare base=one compare=two;
	id Patno;
run;

/* 9. Brief option can give a brief summary of the output */

proc compare base=one compare=two brief;
	id Patno;
run;

/* 10. Transpose options order the report in id order */

proc compare base=one compare=two brief transpose;
	id Patno;
run;
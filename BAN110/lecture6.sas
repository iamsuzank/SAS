data Patients;
	infile '/home/u63049952/BAN110ZAA/week6/Patients.txt';
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
/* proc surveyselect data=patients sampsize=50 method = srs out=sample_output reps=2; */
/* id patno visitdate gender hr sbp; */
/* run; */
/*  */
/* data sample1 sample2; */
/* set sample_output; */
/* if replicate=1 then output sample1; */
/* else if replicate=2 then output sample2; */
/* run; */

/* proc print data=sample1; */
/* run; */
/*  */
/* proc print data=sample2; */
/* run; */
/*    */

/* proc sql outobs=50; */
/* create table sample as */
/* select * from  */
/* patients where  ranuni(1234) <0.9 */
/* ; */
/* quit; */


proc freq data=patients;
tables gender;
run;


proc sort data = patients out=sample_out;
by gender;
run;

proc surveyselect data=sample_out method=srs samprate=0.5 out=sample;
id patno visitdate gender hr;
strata gender;
run;

proc freq data=sample;
tables gender;
run;


proc sql outobs=50;

create table male_sample as
select * from patients where  ranuni(1234) <0.5 and gender = 'M';

quit;

proc sql outobs=50;
create table female_sample as
select * from patients where  ranuni(1234) <0.5 and gender = 'F';


quit;

proc sql;

create table combined as 
select * from male_sample union all select * from female_sample;

quit; 

proc freq data=combined;
run;


data One;
	infile '/home/u63049952/BAN110ZAA/week6/Patients.txt';
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



data two;
	infile '/home/u63049952/BAN110ZAA/week6/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
	run;

proc compare base=one compare=two;
run;
















/* 1. Proc Means can be used to get a quick overview of numeric data */
proc means data=Patients min max maxdec=3 ;
	var HR SBP DBP;
	output out=short;
run;

proc print data=short;
run;

/* 2. Proc Univariate is used to review numeric data  */
proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
run;

/* 3. Proc Univariate can draw histograms as well */
proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

/* 4. This proc shows a lot of output. Sometimes, it is a good */
/* idea to trim the output. ODS can help. */
ODS Trace ON/Listing;

proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

ODS Trace OFF;

/* Above Trace ON/OFF statements can help in knowing the name of the objects. */
/* 5. ODS Select can be then used with Object name to only show the output of */
/* that object for each variable. */
ODS Select ExtremeOBS;

proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

/* 6. NextROBS option on the proc can be used to change the limit of output */
/* ODS Select ExtremeOBS; */

proc univariate data=Patients nextrobs=10;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

/* 7. Keep= can be used on proc print as well */
proc print data=Patients(keep=Patno HR);
run;

/* Same goes with where= cla use */
proc print data=Patients(keep=Patno HR where=(HR > 75));
run;

/* 8. Same applies to Proc Sort as well */
proc sort data=Patients(keep=Patno HR where=(HR is not missing)) 
		out=Sorted_Patients;
	by HR;
run;

/* 9. Show 10 patients with lowest HR values */
proc sort data=Patients(keep=Patno HR where=(HR is not missing)) 
		out=Sorted_Patients;
	by HR;
run;

proc print data=Sorted_Patients (obs=10);
run;

/* 10. Show 10 patients with highest HR values */
proc sort data=Patients(keep=Patno HR where=(HR is not missing)) 
		out=Sorted_Patients;
	by descending HR;
run;

proc print data=Sorted_Patients (obs=10);
run;

/* 9. Macro variables and Put statements are pretty handy to get data overview. */
/* This exercise below is expected to display ten lowest and ten highest values for HR */
/* in the log window; */
proc sort data=Patients(keep=Patno HR where=(HR is not missing)) out=Tmp;
	by HR;
run;

data temp;
	set tmp nobs=Number_of_Obs;
	*nobs get total rows and stores in a variable;
	High=Number_of_Obs - 9;
	* Getting last ten rows starting from 91 (highest);
	call Symputx('High_Cutoff', High);
run;

data temp2;
	set tmp(obs=10) tmp(firstobs=&High_Cutoff);
	*merging rows;

	if _n_ le 10 then
		do;
			*_n_ is used for getting the row number;

			if _n_=1 then
				put "Ten Lowest Values";
			*put is used to show on console;
			put "Patno=" Patno @15 "Value=" HR;
			*@15 is width between two values;
		end;
	else if _n_ ge 11 then
		do;

			if _n_=11 then
				put "Ten Highest Values";
			put "Patno=" Patno @15 "Value=" HR;
		end;
run;

/* 8. Percentiles from Univariate can be used for showing top and bottom % */
proc univariate data=Patients;
	id Patno;
	var HR;
	output out=tmp pctlpts=5 95 pctlpre=Percent_;
run;

data HighLow;
	set Patients;

	if _n_=1 then
		set tmp;

	if HR <=Percent_5 and not missing(HR) then
		do;
			Range='Low ';
			output;
		end;
	else if HR >=Percent_95 then
		do;
			Range='High';
			output;
		end;
run;

proc sort data=HighLow;
	by HR;
run;

proc print data=HighLow;
	id Patno;
	var HR Range;
run;

9. Proc Rank can be used for achieve results like above with little variation 
	proc format;
value groups 0='Low' 19='High';
run;

proc rank data=Patients(keep=Patno HR) out=HighLow groups=20;
	var HR;
	ranks HR_Groups;
run;

proc sort data=HighLow(where=(HR_Groups in (0, 19))) out=HighLow_Sorted;
	by HR;
run;

proc print data=HighLow_Sorted;
	id Patno;
	var HR HR_Groups;
	format HR_Groups groups.;
run;
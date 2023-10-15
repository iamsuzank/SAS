/* data People; */
/* Length Name $15 Address $40; */
/* infile Datalines dsd; */
/* Input Name $ Gender $ Address $; */
/* // Fill in missing lines of code (there can be multiple missing lines) */
/* First_Name = scan(Name,1,''); */
/* Last_Name = scan(Name,2, ''); */
/* Province=scan(Address,-2,''); */
/* Country=scan(Address,-1,''); */
/* datalines; */
/* Steve Jobs,M,'70 Senecaway, Markham, ON, Canada' */
/* Bill Gates,M,'120 Toronto Street, Toronto, ON, Canada' */
/* Elon Musk,M,'8 Hollywoon Drive, Newmarket, BC, Canada' */
/* Julia Roberts,F,'11 Elington Avenue, Orlando, FL, USA' */
/* Tim Austin,M,'10 John Moore Road, Miami, FL, USA' */
/* Angelina Jolie,F,'88 Sydney Drive, Surrey, BC, Canada' */
/* ; */
/* run; */
/*  */
/* proc print data=People; */
/* var First_Name Last_Name Province Country; */
/* run; */




/* filename dataset '/home/u63049952/BAN110ZAA/Midterm/movies_ban110.xlsx'; */
/* proc import datafile=dataset  */
/* out=imdb  */
/* dbms=xlsx replace; */
/* sheet='movies_ban110'; */
/*  */
/* proc print data=imdb (obs=10); */
/* run; */



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

proc univariate data=Patients;

	id Patno;
	var HR;
/*        // Fill in missing lines of code (there can be multiple missing lines) */
	output out=tmp pctlpts=5 95 pctlpre=Percent_;

run;

data setMacros;

       // Fill in missing lines of code (there can be multiple missing lines)

	set tmp nobs=Number_of_Obs;
	*nobs get total rows and stores in a variable;
	High=Number_of_Obs - 9;
	* Getting last ten rows starting from 91 (highest);
	call Symputx('High_Cutoff', High);
run;


data HighLow;

       set Patients;

       // Fill in missing lines of code (there can be multiple missing lines)            

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
// Fill in missing lines of code (there can be multiple missing lines)

	id Patno;
	var HR Range;
run;

/* 9. Proc Rank can be used for achieve results like above with little variation  */
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

proc print data=HighLow_Sorted (firstobs=&);
	id Patno;
	var HR HR_Groups;
	format HR_Groups groups.;
run;

















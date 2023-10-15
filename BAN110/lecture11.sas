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

proc print;



data salary;
	do subj =1 to 1000;
	salary= int(100*rand('Exponential',20));
	output;
end;
run;

proc print;

proc sgplot data=salary;
histogram salary;



proc univariate data=salary;
var salary;
histogram / normal;
proc print;

/* proc means data=patients order=freq; */
/* var SBP; */
/* class DBP ; 
/* ways 1; */
/* run; */

proc freq data=patients order=freq noprint  ;
tables sbp / nocum nopercent   out=stat  ;
run;


data root_transformation;
set salary;
root_salary=sqrt(salary+2);
run;

proc sgplot data=root_transformation;
histogram root_salary;



proc univariate data=root_transformation;
var root_salary;
histogram / normal;


/* log trnasformation */

data log_transformation;
set salary;
log_salary=log(salary+2);
run;

proc sgplot data=log_transformation;
histogram log_salary;



proc univariate data=log_transformation;
var log_salary;
histogram / normal;


data sample;

input id$ v1 v2;
datalines;
A 10 20
B 30 40
A 10 20
C 50 60
A 70 80
D 90 100
;

run;

proc sort data=sample out=demo;
by id;
run;

data duplicates;
set demo;
by id v1 v2;
put id= v1= v2= first.id= last.id= first.v1= last.v1= first.v2= last.v2=;
if first.id = 1 and last.id = 1 and first.v1= 1 and last.v1= 1 and first.v2=1 and  
last.v2=1 then delete;
run;
proc print;
 
PROC SORT data = patients nodupkey ;
by patno;
run;

data patients;
set patients;
by Patno;
retain count;
put patno= first.patno= last.patno=1;
if first.patno=1 and last.patno=1 then do;
count=1;
end;
else do;
count+1;
end;
if count >1 then delete;
run;
proc print;

proc sort data=patients out=demo;
by patno;
run;

/* data duplicates; */
/* set demo; */
/* by patno; */
/* put patno= first.patno= last.patno=1; */
/* if first.patno=1 and last.patno=1 then output; */

data duplicates;
set demo;
if patno not eq lag(patno) then output;
run;

/* proc print; */




proc freq data=patients noprint ;
tables Patno / out= new_data(where=(Count > 1) drop=Percent );

proc print data=new_data;


proc sort data=dataset.patients;
by patno;

data final;
merge demo new_data(in=dup drop=count);
by patno;
if dup;
run;

data or





proc print data=final;

proc sort data=dataset.patients nodupkey out=demo;
by patno visitdate;
/* checks the value of patno and visitdate and if they are similar remove it */

proc sort data=dataset.patients noduprecs out=demo;
/* checks the entire columns */
by patno;



/*  1. A Skewed data can provide inaccurated results. Lets try the data below */

data Salary;
	do Subj = 1 to 1000;
		Salary = int(10000*rand('Exponential', 20));
		output;
	end;
run;

/* 2. Histogram can be generated to see the skewness */

proc sgplot data=Salary;
	histogram Salary;
run;

/* 3. Univariate can be used to check for skewness value and drawing of histogram */

proc univariate data=Salary;
	var Salary;
	histogram / normal;
run;

/* 4. One of the ways of reducing skewness is root transformation */

data fixed_skewness_root;
	set Salary;
	root_salary = sqrt(Salary + 2);
run;

/* Checking the histogram for both the original and the fixed one */

proc sgplot data=FIXED_SKEWNESS_ROOT;
	histogram root_salary;
run;

proc sgplot data=FIXED_SKEWNESS_ROOT;
	histogram Salary;
run;

/* Checking the skewness of the modified dataset using univariate */

proc univariate data=Fixed_skewness_root;
	var root_Salary;
	histogram / normal;
run;

/* 5. Another way of reducing skewness is using log transformation */

data fixed_skewness_log;
	set Salary;
	log_salary = log(Salary + 1.5);
run;

proc sgplot data=FIXED_SKEWNESS_log;
	histogram log_salary;
run;

proc sgplot data=FIXED_SKEWNESS_LOG;
	histogram Salary;
run;

proc univariate data=Fixed_skewness_log;
	var log_Salary;
	histogram / normal;
run;

/* 6. Duplicate entries can affect the data analysis as well. It is recommended to identify duplicates in the data */

data sample_data;
  input id $ var1 var2;
  datalines;
  A 10 15
  B 20 25
  C 30 35
  A 11 50
  D 40 45
;

proc sort data=sample_data;
  by id;
run;

data Duplicates;
	set sample_data;
	by id;
	
	if first.id and last.id then delete;
run;

proc print data=Duplicates;
run;

/* 7. To check for duplication of the whole record (observation) we can do the following: */

data sample_data;
  input id $ var1 var2;
  datalines;
  A 10 15
  B 20 25
  C 30 35
  A 10 15
  D 40 45
;

proc sort data=sample_data;
  by id var1 var2;
run;

proc print data=sample_data;
run;

data Duplicates;
	set sample_data;
	by id var1 var2;
	put id= var1= var2= first.id= last.id= first.var1= last.var1= first.var2= last.var2=;
	if first.var2=0 and last.var2=1 and first.id=0 and last.id= 1 and first.var1 = 0 and last.var1 = 1 then output;
run;

proc print data=Duplicates;
run;


8. We can check for duplicate in the Patient Dataset as well

data Patients;
	infile '/home/u50479107/BAN110ZAA/Patients.txt';
	
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

proc sort data=Patients out=Demo;
	by Patno;
run;

data Duplicates;
	set Demo;
	by Patno;
	put patno= first.patno= last.patno=;
	if first.patno and last.patno then delete;
run;

proc print data=Duplicates;
run;

/* 9. Proc Freq can be used to find duplicates */

proc freq data=Demo;
	tables Patno / out=Duplicates(where=(Count gt 1) drop=percent);
run;

/* 10. Duplicates from Proc Freq can be merged with original dataset to show duplicate observations */

data Duplicate_Obs;
	merge Demo Duplicates(in=InDuplicates drop=Count);
	by patno;
	if inDuplicates;
run;

proc print data=Duplicate_Obs;
run;

11. It is a good idea to remove duplicates


data Patients;
	infile '/home/u50479107/BAN110ZAA/Patients.txt';
	
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

proc sort data=Patients out=Demo;
	by Patno;
run;

data No_Duplicates;
	set Demo;
	by Patno;
	put patno= first.patno= last.patno=;
	if first.patno then output;
run;

proc print data=No_Duplicates;
run;

/* 12. Lag function can be used to remove duplicates as well */

data Patients;
	infile '/home/u50479107/BAN110ZAA/Patients.txt';
	
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

proc sort data=Patients out=Demo;
	by Patno;
run;

data no_duplicates;
  set Demo;
  if Patno^=lag(Patno)  then output;
run;

proc print data=no_duplicates;
  title "Dataset Without Duplicates";
run;

/* 12. Another way of removing duplicates is using proc sort. */

proc sort data=Patients out=Demo nodupkey;
	by Patno;
run;

proc print data=Demo;
run;

/* Duplicates from various columns can be used for deletion as well 
by putting columns next to by statement */

proc sort data=Patients out=Demo nodupkey;
	by Patno VisitDate;
run;

proc print data=Demo;
run;

/* 12. NoDUPRECS can be used to delete duplicates where all the variables of observations are similar */

proc sort data=Patients out=Demo noduprecs;
	by Patno VisitDate;
run;

proc print data=Demo;
run;



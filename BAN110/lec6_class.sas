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



/* A having clause is used if range is checked using aggregate functions */
	proc SQL;
		select Patno, SBP from Patients
		having SBP not between mean(SBP) - 2* std(SBP) and
		mean(SBP) + 2* std(SBP) and SBP is not missing;
	quit;


proc sort data=patients(keep=Patno HR where =(HR is not missing)) out=sorted_1 ;
by   HR;
run;


proc sort data=patients(keep=Patno HR where =(HR is not missing)) out=sorted_2;
by  descending HR;
run;



data combined;
set  sorted_2(obs=10) sorted_1(obs=10);
run;

proc print data=combined;
run;


 proc sort data=Patients (keep= Patno HR where=(HR is not missing)) out=sorted_patients; 
by HR;
run;


data temp;
set sorted_patients nobs=Num_of_obs;
/* creating macros */
High= Num_of_obs-9;
Low=Num_of_obs-90;
call symputx('High_Cutoff',High);
call symputx('Low_Cutoff',Low);

run;




data Final;
/* use & before macros */
set sorted_patients(firstobs=&High_Cutoff);
run;



data Final2;
/* use & before macros */

set sorted_patients(obs=&Low_Cutoff);
/* put "Patno=" Patno; */
run;



/* printing */
proc print data=Final2;
run;

proc univariate data = Patients;
var HR ;
output out=temp pctlpts=5 95 pctlpre=Percent_;
 
run;


proc print data=temp;
run;

data high_low;
set patients temp;
if _n_=1 then set temp;

if HR>91 then Range="High";
if HR> Percent_95 then Range="High";
else if HR<=Percent_5 then Range="Low";
run;

proc print data=high_low;
run;




proc sort data =Patients ;
by HR;
run;

proc rank data=Patients(keep=HR Patno) out = grouped groups=20;



var HR;
ranks rank_x;
run;

/* proc sort data=grouped(where =(rank_x in (0,19)) ); */

proc print data=grouped;
run;

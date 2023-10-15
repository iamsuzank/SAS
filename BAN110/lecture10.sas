/* method 1 - deteting outlier */
data Patients;
set dataset.patients;
where HR ~=900;
run;
proc print;


proc means data=patients;
var HR;
output out=mean_std
(drop=_type_ _freq_)
STD=  MEAN= 
/autoname;
run;

data temp;
set patients(keep=Patno HR);
if _n_ =1 then set mean_std;
if HR lt HR_Mean - 2*HR_StdDev and not missing(HR) or
		HR gt HR_Mean + 2*HR_StdDev;
run;


method 2- detecting outlier

data outlier;
set dataset.patients(keep= patno hr);
run;

proc rank data=outlier groups=10 out=temp;
var HR;
Ranks HR_Rank;
run;

proc sort data=temp;
by HR_Rank;
run;
proc print;


proc means data=temp(where=(HR_Rank not in(0,9)));
var HR;
output out=mean_std_trimmed(drop=_type_ _freq_)
mean= std= /autoname;
run;

data temp_trim;
set dataset.patients(keep= patno hr);
if _n_ =1 then set mean_std_trimmed;
if HR lt HR_Mean - 2*HR_StdDev and not missing(HR) or
		HR gt HR_Mean + 2*HR_StdDev;
run;

title "outliers";
proc print data=temp_trim;
run;

/* method 3- detecting outlier using plot */

proc sgplot data=dataset.patients(keep=patno hr sbp gender where=(gender in ('M','F')));
hbox sbp / category=gender;
run;



proc means data=dataset.patients;
var HR;
output out = quartiles(drop= _type_ _freq_) q1= q3= qrange=/autoname;
run;

data temp;
set dataset.patients(keep=patno hr gender);
if _n_ =1 then set quartiles;
run;

proc print;
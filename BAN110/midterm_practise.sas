/* 1. Reading in data from a text file */

data Patients;
	infile '/home/u63049952/BAN110ZAA/Midterm/Patients.txt';
	
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

/* proc means data=patients N Nmiss; */

/* 2. Report can be printed as well */

proc print data=Patients;
run;

/* 3. Date seems to be not in a proper format, so we can fix it */

data Patients;
	infile '/home/u63049952/BAN110ZAA/Midterm/Patients.txt';
	
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
		  
		  Format VisitDate mmddyy10.;
run;

/* 4. In order to further explore data, we can use proc freq */

proc freq data=Patients;
	tables Gender Account_no Patno;
run;

/* This will show us missing values as well. */

/* 5. There are several built-in functions in SAS to perform cleaning. One of such is upcase */

data Clean_Data;
	set Patients;
	
	Gender = upcase(Gender);
run;

proc print data=Clean_Data;
run;



/* 6. Data step can be used to perform some conditional 
statements and check for missing values */

data Clean_Data;
	set Patients;
	
	Gender = upcase(Gender);
	
	if missing(Gender) then put "Missing Gender Value";
run;

/* In Data step we can use if statement to perform the following actions */

data Clean_Data; 
	set Patients; 
	 
	Gender = upcase(Gender); 
	 
	if Gender not in ('M', 'F') then put "na"; 
run; 


proc print data = Clean_Data ;
/* where gender='M'; */
where gender not in ('M', "F");
run;

data cleaned;
set patients(where=(gender  in ('M','F')));
run;

proc print data=cleaned;
where gender not in ('M','F');
run;
/* 7. Proc Step can be used for perform some conditional statements and check for missing values */

data Clean_Data; 
	set Patients; 
run; 
 
proc print data=Clean_Data; 
	where Gender not in ('M', 'F'); 
run;

/* 8. BTW, in proc step var can be used to display only specific columns */

proc print data=Clean_Data; 
/* 	var Gender Patno Account_no;  */
	where Gender not in ('M', 'F'); 
run;


/* 9. Spaces can be trimmed to one space in the middle of the words */

data demo;
	Name = " Seneca  College "; 
	New_Name = compbl(Name);
run;


data mytext;
text=12345;
text1=compress(text,12);
run;

/* 10. Trailing spaces can be removed using trimn */

data demo;
	Name = "Seneca College "; 
	New_Name = trimn(Name);
run;

/* 11. Strip is used to remove the leading spaces */

data demo;
	Name = "  Seneca College   "; 
	New_Name = strip(Name);
run;
/*  */
/* proc print data=demo; */
/* run; */
/* 12. Compress can be used to remove specific characters */

data demo;
	Name = "Seneca College"; 
	New_Name = compress(Name, "e");
run;

/* 13. Compress can also be used to remove digits */
data demo;
	Name = "Seneca College 456"; 
	New_Name = compress(Name, "1234567890");
run;

/* 14. Other variations of compress are also interesting */

data demo;
	Name = "Seneca College 456"; 
	New_Name = compress(Name, , 'ka');
run;

/* 15. Below will keep only digits */

data demo;
	Name = "Seneca College 456"; 
	New_Name = compress(Name, , 'kd');
run;


/* data demo; */
/* 	Name = "Seneca College 456";  */
/* 	New_Name = compress(Name, "Seneca College"); */
/* run; */


/* 16. NotDigit is used to find if there is anything which 
is not digits */

data demo;
	Name = "1231121AB56"; 
	New_Name = NotDigit(Name);
run;

/* 17. Can use index to start searching for in NotDigit */

data demo;
	Name = "123A5B6"; 
	New_Name = NotDigit(Name, 5);
run;


/* 18. Removing units from a value */

data Units; 
length Weight $10;
	input Weight $ ; 
	Digits = compress(Weight,,'kd'); 
datalines; 
100lbs. 
110 Lbs. 
50Kgs. 
70 kg 
180 
; 
proc print data=Units; 
run; 

/* 19. In order to remove all the spaces, we can use */

data demo;
	Input Weight $ 10.;
	Digits = compress(Weight,,'kad');

datalines; 
100lbs. 
110 ....Lbs. 
50Kgs. 
70 kg 
180 
; 

/* 20. Keeping . and removing spaces */

data demo;
	Input Weight $ 10.;
	Digits = compress(Weight,,'kad');

datalines; 
100lbs. 
110 Lbs. 
50Kgs. 
70 kg 
180 
; 




/* --------------lecture 3------------------------------------------ */

/* 1. Subsetting Data is important in Data Extraction */
data Patients;
	infile '/home/u63049952/BAN110ZAA/Midterm/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;

	if Gender='F';
run;

/* Above would return only the data for female patients. */
/* 2. Data module can also use where clause to do the same */
data Patients;
	infile '/home/u63049952/BAN110ZAA/Midterm/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
	Format VisitDate mmddyy10.;
run;

data Clean_Patients;
	set Patients;
	where Gender='F';
run;

/* 3. Sometimes not all the columns are required so one can drop some of the columns */
data Clean_Patients;
	set Patients(keep=Account_no Gender VisitDate HR);
	where Gender='F';
run;

/* 4. Sometimes it is a good idea to split a larger dataset into smaller ones */
data Males Females;
	set Patients;

	if Gender='M' then
		output Males;
	else if Gender='F' then
		output Females;
run;

/* 5. Data can be combined from various datasets. It is normally called merging in SAS 
and it requires data to be sorted. */
data one;
	INPUT id v1 v2;
	DATALINES;
1 10 100
2 15 150
3 20 200
;

data two;
	INPUT id v3 v4;
	DATALINES;
1 1000 10000
2 1500 15000
3 2000 20000
4  800 30000
;

proc sort data=one;
	by id;
run;

proc sort data=two;
	by id;
run;

data combine;
	merge one two;
	by id;
run;

/* 6. Merge Data using Employee_ID */
data Employee;
	infile Datalines dsd;
	Length Name $ 13;
	Input Employee_ID $ Name $ Age;
	Datalines;
"001","Steve Jobs",55
"002","Bill Gates",65
"003","Elon Musk",45
"004","Warren Buffet",75
"005","Jeff Bezos",68
;

data Payroll;
	infile Datalines dsd;
	Input Payroll_ID $ Employee_ID $ Salary;
	Datalines;
"P01","001",50000
"P02","002",70000
"P03","003",45000
"P04","004",75000
"P05","005",68000
;

proc print data=Payroll;
run;

proc sort data=Employee out=Employee_Sorted;
	by Employee_ID;
run;

proc sort data=Payroll out=Payroll_Sorted;
	by Employee_ID;
run;

data Report;
	merge Employee(IN=inEmployee) Payroll(IN=inPayroll);
	by Employee_ID;

	if inEmployee=1 and inPayroll=1;
run;

proc print data=Report;
	var Name Salary;
	format Salary dollar11.2;
run;


/* ---------------------lecture 3--------------------------------- */
/* 1. Subsetting Data is important in Data Extraction */
data Patients;
	infile '/home/u63049952/BAN110ZAA/Midterm/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;

	if Gender='F';
run;

/* Above would return only the data for female patients. */
/* 2. Data module can also use where clause to do the same */
data Patients;
	infile '/home/u63049952/BAN110ZAA/Week3/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
	Format VisitDate mmddyy10.;
run;

data Clean_Patients;
	set Patients;
	where Gender='F';
run;

/* 3. Sometimes not all the columns are required so one can drop some of the columns */
data Clean_Patients;
	set Patients(keep=Account_no Gender VisitDate HR);
	where Gender='F';
run;

/* 4. Sometimes it is a good idea to split a larger dataset into smaller ones */
data Males Females;
	set Patients;

	if Gender='M' then
		output Males;
	else if Gender='F' then
		output Females;
run;

/* 5. Data can be combined from various datasets. It is normally called merging in SAS 
and it requires data to be sorted. */
data one;
	INPUT id v1 v2;
	DATALINES;
1 10 100
2 15 150
3 20 200
;

data two;
	INPUT id v3 v4;
	DATALINES;
1 1000 10000
2 1500 15000
3 2000 20000
4  800 30000
;

proc sort data=one;
	by id;
run;

proc sort data=two;
	by id;
run;

data combine;
	merge one two;
	by id;
run;

/* 6. Merge Data using Employee_ID */
data Employee;
	infile Datalines dsd;
	Length Name $ 13;
	Input Employee_ID $ Name $ Age;
	Datalines;
"001","Steve Jobs",55
"002","Bill Gates",65
"003","Elon Musk",45
"004","Warren Buffet",75
"005","Jeff Bezos",68
;

data Payroll;
	infile Datalines dsd;
	Input Payroll_ID $ Employee_ID $ Salary;
	Datalines;
"P01","001",50000
"P02","002",70000
"P03","003",45000
"P04","004",75000
"P05","005",68000
;

proc print data=Payroll;
run;

proc sort data=Employee out=Employee_Sorted;
	by Employee_ID;
run;

proc sort data=Payroll out=Payroll_Sorted;
	by Employee_ID;
run;

data Report;
	merge Employee(IN=inEmployee) Payroll(IN=inPayroll);
	by Employee_ID;

	if inEmployee=1 and inPayroll=1;
run;

proc print data=Report;
	var Name Salary;
	format Salary dollar11.2;
run;



/* --------------lecture 4---------------- */
/* 1. SAS formats can be used to further format the data */
proc format;
	value gender 1='Male' 0='Female';
	value $gender_ch M='Male' F='Female';
run;

data Gender_Example;
	Input Gender Gender_ch $;
	DATALINES;
1 M
1 M
0 F
0 F
1 M
;

proc print data=gender_example;
	Format Gender gender. Gender_ch $gender_ch.;
run;

/* 2. Formatting the Patients Dataset */
proc format;
	value $gender 'M'='Male' 'F'='Female' Other='NA';
run;

data Patients;
	infile '/home/u63049952/BAN110ZAA/Week4/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
	Format Gender $gender.;
run;

proc print data=Patients;
run;

/* 3. In order to find the number of males and females */
proc freq data=Patients;
	tables Gender;
run;

/* 4. To get only few rows from a dataset, obs can be used */
data Snacks;
	set SASHELP.Snacks;
run;

proc print data=Snacks (obs=100);
run;

/* In Above dataset, holiday and working day can be set using proc format */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* You can search by formatted value as well */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);

	if put(Holiday, holiday.)='Holiday';
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* 5. Search using multiple conditions involvinng Dates */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);

	if put(Holiday, holiday.)='Holiday' and (Date >='01MAR2002'd and 
		Date <='31MAR2002'd);
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* Another way of doing this is in proc print using where */
proc print data=Snacks;
	where Date >='01MAR2002'd and Date <='31MAR2002'd;
run;

/* OR */
proc print data=Snacks;
	where Date between '01MAR2002'd and '31MAR2002'd;
run;

/* 2. Sometimes data needs to be converted into different formats, e.g., char to numeric and vice versa. */
data conversion;
	input Digits $;
	numbers=input(Digits, 5.);
	Format numbers mmddyy10.;
	Datalines;
14561
12342
15233
22228
;

	/* 3. More information on conversion */
data conversion;
	input Temperature $;
	temp_clean=compress(Temperature, , 'a');
	temp=input(temp_clean, 5.);
	Temp_Celsius=round((temp-32)*0.556, 0.1);
	temp_c=put(Temp_Celsius, 6.1);
	Final=cats(temp_c, 'C');
	Drop temp_clean temp temp_c Temp_Celsius;
	Datalines;
98.9F
100.2F
99.7F
102.5F
;

	/* 4. Hierarchical Codes are sometimes a way of extracting information. */
data Codes;
	Input Code $;
	Main_Group=substr(Code, 1, 1);
	Datalines;
216
305
404
233
105
311
290
;

	/* 5. Indicator for Special Category is sometimes important at a glance */
data Codes;
	Input Code $;
	Main_Group=substr(Code, 1, 1);

	IF Main_Group='2' THEN
		ProductMainGroupMF=1;
	ELSE
		ProductMainGroupMF=0;
	Datalines;
216
305
404
233
105
311
290
;

	/* Above can be done directly without creating another column */
	if substr(Code, 1, 1)='2' then
		Category=1;
	else
		Category=0;
run;

/* 6. IN variable is pretty handy to create derived variables */
data employee;
	Input ID Name $;
	Datalines;

1 Steve
2 Bill
3 Elon
4 Warren
5 Jeff
;

data status;
	Input ID status;
	Datalines;
1 0
2 1
3 1
4 1
;

proc sort data=employee out=employee_sorted;
	by ID;
run;

proc sort data=status out=status_sorted;
	by ID;
run;

data report;
	Merge employee_sorted(IN=inEmployee) status_sorted(IN=inStatus);
	by ID;
	length HasFullRecord $ 5.;

	if inEmployee and inStatus then
		HasFullRecord='True';
	else
		HasFullRecord='False';
run;

/* 7. Dummy Variables can be created as follows: */
data Employees;
	Input Name $ Employment_Status $10.;
	Employed=(Employment_Status='Employed');
	Unemployed=(Employment_Status='Unemployed');
	Retired=(Employment_Status='Retired');
	Datalines;

Steve Retired
Bill Retired
Elon Employed
Jeff Employed
John Unemployed


/* ---------------- lecture 4 ----------------------- */
/* 1. SAS formats can be used to further format the data */
proc format;
	value gender 1='Male' 0='Female';
	value $gender_ch M='Male' F='Female';
run;

data Gender_Example;
	Input Gender Gender_ch $;
	DATALINES;
1 M
1 M
0 F
0 F
1 M
;

proc print data=gender_example;
	Format Gender gender. Gender_ch $gender_ch.;
run;

/* 2. Formatting the Patients Dataset */
proc format;
	value $gender 'M'='Male' 'F'='Female' Other='NA';
run;

data Patients;
	infile '/home/u63049952/BAN110ZAA/Week4/Patients.txt';
	input @1 Patno $3.
		  @4 Account_no $7.
		  @11 Gender $1.
		  @12 VisitDate mmddyy10.
		  @22 HR 3.
		  @25 SBP 3.
		  @28 DBP 3.
		  @31 Dx $7.
		  @38 AE 1.;
	Format Gender $gender.;
run;

proc print data=Patients;
run;

/* 3. In order to find the number of males and females */
proc freq data=Patients;
	tables Gender;
run;

/* 4. To get only few rows from a dataset, obs can be used */
data Snacks;
	set SASHELP.Snacks;
run;

proc print data=Snacks (obs=100);
run;

/* In Above dataset, holiday and working day can be set using proc format */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* You can search by formatted value as well */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);

	if put(Holiday, holiday.)='Holiday';
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* 5. Search using multiple conditions involvinng Dates */
proc format;
	value holiday 1='Holiday' 0='Working';
run;

data Snacks;
	set SASHELP.Snacks(obs=100);

	if put(Holiday, holiday.)='Holiday' and (Date >='01MAR2002'd and 
		Date <='31MAR2002'd);
	Format Holiday holiday.;
run;

proc print data=Snacks;
run;

/* Another way of doing this is in proc print using where */
proc print data=Snacks;
	where Date >='01MAR2002'd and Date <='31MAR2002'd;
run;

/* OR */
proc print data=Snacks;
	where Date between '01MAR2002'd and '31MAR2002'd;
run;

/* 2. Sometimes data needs to be converted into different formats, e.g., char to numeric and vice versa. */
data conversion;
	input Digits $;
	numbers=input(Digits, 5.);
	Format numbers mmddyy10.;
	Datalines;
14561
12342
15233
22228
;

	/* 3. More information on conversion */
data conversion;
	input Temperature $;
	temp_clean=compress(Temperature, , 'a');
	temp=input(temp_clean, 5.);
	Temp_Celsius=round((temp-32)*0.556, 0.1);
	temp_c=put(Temp_Celsius, 6.1);
	Final=cats(temp_c, 'C');
	Drop temp_clean temp temp_c Temp_Celsius;
	Datalines;
98.9F
100.2F
99.7F
102.5F
;

	/* 4. Hierarchical Codes are sometimes a way of extracting information. */
data Codes;
	Input Code $;
	Main_Group=substr(Code, 1, 1);
	Datalines;
216
305
404
233
105
311
290
;

	/* 5. Indicator for Special Category is sometimes important at a glance */
data Codes;
	Input Code $;
	Main_Group=substr(Code, 1, 1);

	IF Main_Group='2' THEN
		ProductMainGroupMF=1;
	ELSE
		ProductMainGroupMF=0;
	Datalines;
216
305
404
233
105
311
290
;

	/* Above can be done directly without creating another column */
	if substr(Code, 1, 1)='2' then
		Category=1;
	else
		Category=0;
run;

/* 6. IN variable is pretty handy to create derived variables */
data employee;
	Input ID Name $;
	Datalines;

1 Steve
2 Bill
3 Elon
4 Warren
5 Jeff
;

data status;
	Input ID status;
	Datalines;
1 0
2 1
3 1
4 1
;

proc sort data=employee out=employee_sorted;
	by ID;
run;

proc sort data=status out=status_sorted;
	by ID;
run;

data report;
	Merge employee_sorted(IN=inEmployee) status_sorted(IN=inStatus);
	by ID;
	length HasFullRecord $ 5.;

	if inEmployee and inStatus then
		HasFullRecord='True';
	else
		HasFullRecord='False';
run;

/* 7. Dummy Variables can be created as follows: */
data Employees;
	Input Name $ Employment_Status $10.;
	Employed=(Employment_Status='Employed');
	Unemployed=(Employment_Status='Unemployed');
	Retired=(Employment_Status='Retired');
	Datalines;

Steve Retired
Bill Retired
Elon Employed
Jeff Employed
John Unemployed


/* ------------lecture 5 --------------- */
/* 1. Sum and Average are pretty handy derived variables */
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
/* 	density Weight; */
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
proc Standard data=missing_test replace out=missing_test_fixed 
mean=70;
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

/* ------------------lecture 6------------ */
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

/* 1. Proc Means can be used to get a quick overview of numeric data */
proc means data=Patients min max maxdec=3 ;
	var HR SBP DBP;
/* 	output out=short; */
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

/* 4. This proc shows a lot of output. Sometimes, it is a good
idea to trim the output. ODS can help. */
ODS Trace ON/Listing;

proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

ODS Trace OFF;

/* Above Trace ON/OFF statements can help in knowing the name of the objects. */
/* 5. ODS Select can be then used with Object name to only show the output of
that object for each variable. */
ODS Select ExtremeOBS;

proc univariate data=Patients;
	ID Patno;
	var HR SBP DBP;
	histogram / normal;
run;

/* 6. NextROBS option on the proc can be used to change the limit of output */
ODS Select ExtremeOBS;

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

/* 9. Macro variables and Put statements are pretty handy to get data overview.
This exercise below is expected to display ten lowest and ten highest values for HR
in the log window; */
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

proc print data=HighLow_Sorted;
	id Patno;
	var HR HR_Groups;
	format HR_Groups groups.;
run;

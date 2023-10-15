/* 1. Subsetting Data is important in Data Extraction */
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
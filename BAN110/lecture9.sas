/* 1. Manual error correction is sometimes the best error correction with small dataset */

data Patients;
	infile '/home/u63049952/BAN110ZAA/Week8/Patients.txt';
	
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

data clean_patients;
	set Patients;
	
	Gender = Upcase(Gender);
	
	if missing(Gender) then Gender = 'F';
	if Patno = '095' then Gender = 'M';
run;

/* 2. Named input can also be used in SAS */

data Named;
	length Char $3;
	
/* 3. Instead of length you can use informat as well */

/* informat Date mmddyy10. Char $3.; */
	informat Date mmddyy10.;
	Input x= y= Char= Date=;
	
	Format Date mmddyy10.;

datalines;
x=3 y=4 Char=abc Date=10/21/2010
y=7
date=11/12/2016 Char=xyz x=9
;


4. Missing values are automatically placed for columns that are not appearing

data Named;
	Length Patno $3 Gender $1;
	Input Patno= Gender= HR= SBP= DBP=;

datalines;
Patno=003 SBP=110
Patno=023 SBP=146 DBP=98
Patno=027 Gender=F
Patno=045 HR=90
;

5. Solution to Exercise 1 from Slides

data student_grades;
	informat name $20.;
    input ID= Name= Mid= Final=;
    Name = compress(Name, '"');
    Final_Grade = (mid + final) / 2;
datalines;
id=1001 name="John Smith" mid=85 final=90
id=1002 name="Jane Doe" mid=75 final=80
id=1003 name="David Lee" mid=90 final=85
;


6. Merge would update the final dataset by picking values from the second dataset

data Inventory;
infile datalines dlm='';
	length PartNo $3;
	Input PartNo  Quantity Price;

datalines;
133 200 10.99
198 105 30.00
933 45 59.95
;

data Transaction;
	Length PartNo $3;
	Input PartNo= Quantity= Price=;

datalines;
PartNo=133 Quantity=195
PartNo=933 Quantity=40 Price=69.95
;

proc sort data=Inventory;
	by PartNo;
run;

proc sort data=Transaction;
	by PartNo;
run;

data Combined;
	merge Inventory Transaction;
	by PartNo;
run;

7. An update statement would not do that

data Combined_2;
	update Inventory Transaction;
	by PartNo;
run;


8. Solution to Exercise 2

data employee_data;

input employee_id first_name $ last_name $ salary department $10.;
datalines;
1234 John Smith 65000 Marketing
2345 Jane Doe 75000 Sales
3456 David Lee 80000 Finance
;

data new_salary;
   employee_id = 1234;
   salary = 55000;
   output;
   employee_id = 2345;
   salary = 80000;
   output;
run;

data emp_update;
	update employee_data new_salary;
	by employee_id;
run;
proc print data=emp_update;
run;


7. Proc Standard can be used to replace missing values by their means
data demo;
	Input Age @@;

datalines;
12 60 . 24 . 50 48 34 .
;

proc Standard data=demo print  replace  out=demo_final;
	var Age;
run;

proc print data=demo_final;
run;


8. Use SASHELP.AIR to put some missing values and then impute them with mean

data demo;
	set SASHELP.Air;
	
	if Air > 400 then Air = .;
run;

proc Standard data=demo replace print out=demo_final mean=200;
	var Air;
run;

proc print data=demo_final;
run;

10. Solution for Exercise 4

data employees;
    input id name $ salary;
    datalines;
1 John 50000
2 Jane 60000
3 Bob 12000000
4 Susan 80000
5 Mike 150000
6 Sarah 90000
7 Tom 20000000
;

proc print data=employees;
	Format Salary dollar17.;
run;

%let max_salary = 120000;

data employees_corrected;
    set employees;

    if salary > &max_salary then salary = &max_salary;

run;

proc print data=employees_corrected;
	Format Salary dollar17.;
run;

9. Missing values can be shown using formats

data demo;
	infile Datalines dsd;
	Input ID Gender $ Age;

datalines;
1,F,29
2,,30
3,M,40
4,,50
;

proc format;
	value $missfmt ' '='Missing' other='Not Missing';
run;

proc freq data=demo;
	format _CHAR_ $missfmt.;
	tables _CHAR_ / missing missprint nocum nopercent;
run;
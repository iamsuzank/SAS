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
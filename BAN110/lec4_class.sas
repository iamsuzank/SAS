proc format;
VALUE gender_num 1= 'Male' 0 = 'Female'; *creating format like mmddyy10.;
value $gender_alpha 'M' = 'Male' 'F'='Female' 'f'='Female' 'm'='Male' other ="N/A";

RUN;


data Gender_Example;
	Input Gender_Code Gender_Ch $;
	format Gender_Code gender_num.;
	format Gender_Ch $gender_alpha.;
	we use . to inform intrepreter that it is a format instead o fvariable 

Datalines;
1 M
1 M
0 F
0 F
1 M
;
run;


proc print;
run;

filename database '/home/u63049952/BAN110ZAA/Week4/Patients.txt';

data patients;
	infile database;
	* start from column and name it patno and length of the column is 3 and it is character type;
	INPUT @1 Patno $3.
	  @4 Account_No $7.
	@11 Gender $1.
	  @12 Visit mmddyy10.
	@22 HR 3.
	  @25 SBP 3.
	  @28 DBP 3.
	  @31 Dx $7.
	  @38 AE 1.;
	  Format Visit mmddyy10 Gender $gender_alpha.; /* for changing the date
/* 	  format from the numerical format */

run;

proc print;
	  Format Visit mmddyy10 Gender $gender_alpha.; 
/* 	  for changing the date format from the numerical format */

run;

finding no of males and females
proc freq data=patients;
tables Gender;
run;
-------------------------------------------------------------------------
proc format;
VALUE holiday_index 1= 'Working' 0 = 'Not Working'; *creating format like mmddyy10.;


data Snacks;
	set SASHELP.Snacks(obs=1000);
	
	if put(Holiday,holiday_index.)= 'Working' ;
	where Date >='01MAR2002'd and Date<='31MAR2002'd ;

		format Holiday holiday_index. ;
		
	doesn't work because in original data set value are still 0 and 1
		if Holiday  = 1;
	run;
	
	we can control no of rows to display from here as well
	proc print data=snacks(obs=1000); 
	format Holiday holiday_index.;
	where Date between '01MAR2002'd and '31MAR2002'd;
	run;
	



---------------------------------------------------

data Conversion;
input Digits $;

Dates = input(Digits,5.);

 * 5 is the length of the column;

Datalines;
14561
12342
15233
22228
;

proc print data = Conversion;
format Dates mmddyy10.;
run;




data Conversion;
input Temperature $;
Temp_Digits = compress(Temperature, ,'a');
Temp_Num = input(Temp_Digits,5.);
Temp_cels= round((Temp_num-32)*0.556,0.1);
Temp_char = put(Temp_cels,5.1);
Final = cats(Temps_char,'C');
Drop Temp_:;


Temperature = input(Temperature,5.);

 * 5 is the length of the column;

Datalines;
98.5F
100.2F
99.5F
;

run;



data Codes;
Input code $;
Category = substr(Code,1,1);

column name, start of column , length 

if Category = '1' then Category='Tech';


datalines;
216
404
290
;

proc print data = Codes;
format Dates mmddyy10.;
run;

  


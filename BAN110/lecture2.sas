/* 1. Reading in data from a text file */

data Patients;
	infile '/home/u63049952/BAN110ZAA/Week2/Patients.txt';
	
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

/* 2. Report can be printed as well */

proc print data=Patients;
run;

/* 3. Date seems to be not in a proper format, so we can fix it */

data Patients;
	infile '/home/u63049952/BAN110ZAA/Week2/Patients.txt';
	
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



/* 6. Data step can be used to perform some conditional statements and check for missing values */

data Clean_Data;
	set Patients;
	
	Gender = upcase(Gender);
	
	if missing(Gender) then put "Missing Gender Value";
run;

/* In Data step we can use if statement to perform the following actions */

data Clean_Data; 
	set Patients; 
	 
	Gender = upcase(Gender); 
	 
	if Gender not in ('M', 'F') then put "Invalid Gender"; 
run; 


/* proc print data = Clean_Data; */
/* run; */

/* 7. Proc Step can be used for perform some conditional statements and check for missing values */

data Clean_Data; 
	set Patients; 
run; 
 
proc print data=Clean_Data; 
	where Gender not in ('M', 'F'); 
run;

/* 8. BTW, in proc step var can be used to display only specific columns */

proc print data=Clean_Data; 
	var Gender Patno Account_no; 
	where Gender not in ('M', 'F'); 
run;


/* 9. Spaces can be trimmed to one space in the middle of the words */

data demo;
	Name = " Seneca  College "; 
	New_Name = compbl(Name);
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


/* 16. NotDigit is used to find if there is anything which is not digits */

data demo;
	Name = "123AB56"; 
	New_Name = NotDigit(Name);
run;

/* 17. Can use index to start searching for in NotDigit */

data demo;
	Name = "123A5B6"; 
	New_Name = NotDigit(Name, 5);
run;


/* 18. Removing units from a value */

data Units; 
	input Weight $ 10.; 
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
110 Lbs. 
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
data patients;
	infile '/home/u63049952/BAN110ZAA/Week2/Patients.txt';
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
	  Format Visit mmddyy10.; /* for changing the date format from the numerical format */
run;


/* displaying only selected columns
proc print data = Patients;
var Patno Account_No Gender;
run;

*/

/*

* displaying the frequency of all the columns;
proc freq data = patients;
run;

*/


/*
*displaying frequency of only selected column;
proc freq data = patients;
tables Gender;
run;

*/


/* Display the complete information about the patients file*/
  /*proc print data= PATIENTS;
run;

   */
  
  
  * coping the original data set Patients t a new data set name patient_copy;
  data patients_copy;
  	set patients;
  *adding a new column on the patients_copy dataset;
/*   newGender = upcase(Gender); */
  Gender = upcase(Gender);
	
	* replacing empty value in gender column with na;
/* 	if Gender = "" then */
/*  		put"na"; */

/* Filtering */

		/* where Gender In ('M','F'); * show only those rows having value M or F; */
		
		/* we can do the same thing in another way */
/* 				if Gender = 'M' or Gender = 'F'; */
		  	run;
		  
  proc print data = patients_copy;
/*  if Gender = 'M' or Gender = 'F'; */ * don't know why this doesn't work here XD;
  Where Gender in ('M','F');
  run;
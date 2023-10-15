libname dataset '/home/u63049952/BAN110ZAA/lib_patients/';
/* filename dataset '/home/u63049952/BAN110ZAA/lib_patients/patients.txt'; */

data dataset.Patients;
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
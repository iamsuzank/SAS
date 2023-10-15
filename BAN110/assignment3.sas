/* Import the data from the excel sheet in SAS */
filename dataset '/home/u63049952/BAN110ZAA/Assignment3/jobsgender.xlsx';

/* Create a dataset in SAS namely JobsGender which would get all the data from Excel sheet. */
proc import datafile=dataset out=JobsGender replace dbms=xlsx;
	sheet='jobsgender';

proc format;
	value $missing NA='Missing' other='Non Missing';
run;

/*  create a new dataset called ‘Demography’ which would bring
only the following columns from the original Orders dataset:
Year Occupation Total_Earnings_Male Total_Earnings_Female. */
data Demography;
	set JobsGender(keep=year occupation Total_Earnings_Male Total_Earnings_Female);
run;

proc freq data=demography;
	tables occupation Total_Earnings_Male Total_Earnings_Female;
	format occupation Total_Earnings_Male Total_Earnings_Female $missing.;
run;

data Demography_Final;
	set demography;
	*finding the NA value and replacing it with readable value;

	if Total_Earnings_Male='NA' then
		Total_Earnings_Male=' ';

	if Total_Earnings_Female='NA' then
		Total_Earnings_Female='';

	/* 		converting character value to numeric value */
	Total_Earnings_Male_numeric=input(put(Total_Earnings_Male, 8.), 8.);
	Total_Earnings_Female_numeric=input(put(Total_Earnings_Female, 8.), 8.);

	/* 	deleting the redundant columns */
	drop Total_Earnings_Male Total_Earnings_Female;

	/* 	renaming column name to original column name */
	rename Total_Earnings_Male_numeric=Total_Earnings_Male 
		Total_Earnings_Female_numeric=Total_Earnings_Female;
run;

/* use Proc Standard to replace all the missing values in */
/*  those 2 columns by the mean of those columns. */
proc standard data=demography_final;
	var Total_Earnings_Male Total_Earnings_Female;
run;

title"Final Output";

/* final outpt */
proc print data=demography_final noobs;
	/* show a list of all the analysts in Year 2013 */
	format Total_Earnings_Male Total_Earnings_Female dollar11.2;
	Where Year=2013 AND lowcase(Occupation) CONTAINS "analysts";
run;
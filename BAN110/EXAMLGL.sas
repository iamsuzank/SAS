/* id name gender score */
data Players_1;
	Input ID Name $ Gender $ Score;
	Datalines;

01 Perry  M 165
02 Miller M 145
03 Davis  F 127
;

data Players_2;
	Input ID Name $ Gender $ Score;
	Datalines;

02 Miller . 160
03 Bush   . 157
05 Elliot F 125
02 .      M 170
;

proc sort data=players_2;
	by id;

data Combine;
/* 	       // Fill in missing lines of code (there can be multiple missing lines or modules) */
	
	update Players_1(in=p1) Players_2(in=p2);
	by id;
run;

/* proc print data=Combine noobs; */
/* run; */

/* -------------------qn 2-------------------------------- */

/* You are provided with some code in SAS that reads in Students data from Datalines. */
/*  The columns to read in are, ID, Name, Gender and marks. The data provided has some */
/*  duplicates in it.
 You have to remove the duplicates and display only the students  */
/*  who have passed the exam, e.g., have marks more than 50. Make sure to remove duplicates */
/*  WITHOUT using COUNT in PROC SQL. You are required to use only PROC SQL for removing duplicates. */
/*  */
/* Most of the code is provided to you, however, some of the lines of code are missing. */
/*  You are required to fill in those lines of code, so that output is printed as follows: */


/*  */
data Students;
/*       // Fill in missing lines of code (there can be multiple missing lines) */
infile datalines dlm=' ';
length ID 4. Name $ 10. gender $ 3. ;
input ID Name Gender marks;
 

Datalines;

1111 Steve M 90
2222 Bill M 35
3333 Salma F 85
1111 Steve M 90
4444 Lizzy F 48
5555 Tim M 65
3333 Salma F 85
;

 

proc sql;

/*        // Fill in missing lines of code (there can be multiple missing lines) */
select * from students s where s.marks>=50  group by s.id
having avg(s.name) between 0 and 1 ; 
quit;



/* -------------------------------qn 3------------------------------------------ */
/*  */
/* Requirement 1: */
/* Import the provided dataset using Proc import in SAS. */
/* Requirement 2: */
/* Explore the dataset to look for missing and non-values values for both character and numeric  */
/* columns. Below is the expected screenshot of the output: */

proc import datafile='/home/u63049952/BAN110ZAA/Final_examGL/covid_19_data.xlsx'
out=final_examgl
dbms=xlsx replace;


/* proc print data=final_examgl(obs=10); */

/* for character column */
proc freq data=final_examgl;
tables _char_ / missing  nocum nopercent;
format _char_ $miss_fmt.;
run;

proc format;
value $miss_fmt
' '='Missing'
other = 'Not missing';
run;

/* for numerical column */
proc means data=final_examgl n nmiss  min max mean std;
run;

/*  */
/* Requirement 3: */
/*  */
/* Perform following operations: */
/*  */
/* Convert Observation_Date into numeric column and give it mmddyy10. Format.
 Make sure the name of the converted column is still Observation_Date. */
/* Remove all the missing values for Province column. */
/* Make sure there are no ‘None’ or ‘Unknown’ in Province column. */
/* Make sure all the rows in Country column have referred to ‘China’ as ‘Mainland China’. */
/* Requirement 4: */
/*  */
/* Perform the following operations */
/*  */
/* Make sure to create a dataset that has highest confirmed cases per province per country. 
(Hint: Try group by in Proc SQL). For example, British Columbia has highest confirmed cases
 in Canada, e.g., 224 confirmed cases. */
/* Make sure you get the latest observation_date per province per country for confirmed cases. */
/* Below is the expected output of this requirement: */
/* Requirement 3: */
data cleaned_data;
set final_examgl;
Observation_Date_num=input(put(Observation_Date, mmddyy10.),mmddyy10.);
drop observation_date;
rename observation_date_num=observation_date;
if province not in ('','None','Unknown');
if country ='China' then Country='Mainland China'; 
run;
proc sql;

select * from  cleaned_data group by province having count(confirmed)=
(select * from cleaned_data group by province having max(confirmed));

quit;
/* Requirement 4: */



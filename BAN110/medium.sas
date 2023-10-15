/* importing the csv dataset in SAS Studio */
filename audible '/home/u63049952/Projects/Audible_Dataset_final.csv';

proc import datafile=audible replace out=audible_data replace dbms=csv;
	getnames=yes;

	/* Define the sample size */
%let n=10;

	/* randomly selecting 10 different observations from the dataset */
proc surveyselect data=audible_data out=sample_audio method=srs sampsize=&n;
run;

/* Display the sample data */
title "sample audible data";

proc print data=sample_audio;
run;

/* clearing the title */
title;

data dataset_rename;
	/* instead of dropping review 1 to review 100 we are using keep statement */
	set audible_data
	(keep='Book Title'n 'Book Author'n 'Book Narrator'n 'Audio Runtime'n 
		Audiobook_Type Categories Rating 'Total No. of Ratings'n price);

	/* renaming columns name with spaces between words */
	rename 'Book Title'n=title 'Book Author'n=authors 
		'Book Narrator'n=Book_Narrator 'Audio Runtime'n=Audio_Runtime 
		'Total No. of Ratings'n=Total_No_of_Ratings;
run;

data dataset_specialchar;
	set dataset_rename;

	/*  book's title after '(' symbol */
	title=scan(title, 1, '(');

	/* removing book's name after / */
	title=scan(title, 1, '/');

	/* keeping only the main author name by removing the secondary authors name after / */
	authors=scan(authors, 1, '/');
	title=compress(title, '.');
	title=compress(title, '@');
	title=compress(title, ':');
	title=compress(title, '/');
	title=compress(title, '&');
	title=compress(title, '*');
	title=compress(title, ',');
	title=compress(title, '-');
	title=compress(title, '!');
	authors=compress(authors, '.');
	authors=compress(authors, '@');
	authors=compress(authors, ':');
	authors=compress(authors, '/');
	authors=compress(authors, '&');
	authors=compress(authors, '*');
	authors=compress(authors, ',');
	authors=compress(authors, '-');
	authors=compress(authors, '!');
run;

data char_to_num;
	set dataset_specialchar;

	/* converting the rating column from char to num*/
	if Rating='Not rated yet' then
		Rating=' ';
	ratingNumericConverted=input(Rating, 8.2);
	format ratingNumericConverted 8.2;
	drop Rating;

	/*Converting Audio Runtime in minutes*/
	hrs=input(scan(Audio_Runtime, 1, ' '), best12.);
	mins=input(scan(Audio_Runtime, 4, ' '), best12.);
	audioRuntimeInMinutes=hrs * 60 + mins;

	/* 	drop 'Audio Runtime'n; */
	rename audioRuntimeInMinutes=Runtime_Minutes ratingNumericConverted=Rating;
	drop hrs mins Audio_Runtime;
run;

/* -------------------------------------------------------------------------------- */

proc sort data=char_to_num noduprecs;
	/* checks the entire columns for the duplicates records*/
	by title authors;
run;

/* removing the duplicates data */
data dataset_noduplicates;
	set char_to_num;
	by title authors;
	retain count;
	if first.title and first.authors then
		count=1;
	else
		count+1;

	if count > 1 then
		delete;
	drop count;
run;


proc format;
	value $missfrm ' '='Missing' other='Not Missing';
run;

title"Missing Values in Character Columns";

proc freq data=dataset_noduplicates;
	format _char_ $missfrm.;
	tables _char_ / missing nocum nopercent;
run;

title;
title"Missing Values in Numerical Columns";

proc means data=dataset_noduplicates n nmiss;
run;

title;

data dataset_filter;
	set dataset_noduplicates;
	if not missing(book_narrator) and not  missing(audiobook_type) and 
	not missing(categories);
run;

/* ---------------------------------------------------------------------------------------- */
/* proc sgplot data = audibleDataset; */
/* 	vbox Runtime_Minutes; */
/* run; */
/***************************/
/* proc print data = audibleDataset (obs = 10); */
/* run; */
/* --------------------------------------------------------- */
/* Removing duplicate records */
/* --------------------------------------------------------- */
/* 1. Method -1 */


/* ---------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------- */
/* NORMILIZATION OF COLUMN - Total_No_of_Ratings */
/* ------------------------------------------------------------------------------ */
/* 1. Total_No_of_Ratings */
/* ************************** */
/* CHECKING THE DISTRIBUTION */

*Outliers and Null Values:;
*finding the median and skewness of :Total_No_of_Ratings;
title"Histogram of Total_No_of_Ratings before removing outliers:";
ods noproctitle;
ods select histogram;
proc univariate data=dataset_filter noprint;
	var Total_No_of_Ratings;
	histogram / normal;
	output out=ratings_stat_1 pctlpre=perc pctlpts=25 50 75 
	mean=mean_v skewness=skewness_v;
run;

title"Statistics of Total_No_of_Ratings before removing outliers:";
proc print data=ratings_stat_1;
run;

/* temporary dataset */
data _null_;
	/* Use OBS=1 option to read only the first observation */
	set ratings_stat_1(obs=1);
	*creating macros;
	call symputx('ar_q1', perc25);
	call symputx('ar_q2', perc50);
	call symputx('ar_q3', perc75);
run;

*replacing outliers and null values with median;
data temp_1;
	set dataset_filter;
	Q1=&ar_q1.;
	Q2=&ar_q2.;
	Q3=&ar_q3.;
	
	if Total_No_of_Ratings > (Q3 + 1.5*(Q3 - Q1)) 
	and Total_No_of_Ratings < (Q1 - 1.5*(Q3 - Q1)) then
/* replacing the missing values with median(Q2) */
	Total_No_of_Ratings=Q2;
	if missing(Total_No_of_Ratings) then
	Total_No_of_Ratings=Q2;
	drop Q1 Q2 Q3;
run;

title"Histogram of Total_No_of_Ratings after removing outliers:";
ods select histogram;
proc univariate data=temp_1 noprint;
	var Total_No_of_Ratings;

	output out=ratings_stat_2 pctlpre=perc 
	pctlpts=25 50 75  mean=mean_v skewness=skewness_v;
run;

title "Statistics of  Total_No_of_Ratings after removing outliers";

proc print data=ratings_stat_2;
run;

/* Normalizing data */

data transformation_rating;
	set temp_1;
	log_Total_No_of_Ratings=log(Total_No_of_Ratings+10);
run;

title"Statistics of Total_No_of_Ratings after log transformation:";
ods select histogram;
proc univariate data=transformation_rating noprint;
	var log_Total_No_of_Ratings;
	histogram / normal;
	output out=ratings_stat_final pctlpre=perc pctlpts=25 50 75 
	skewness=skewness_v;
run;

title"Statistics of  Total_No_of_Ratings after log transformation";

proc print data=ratings_stat_final;
run;

proc sql;
	create table outliers as select runtime_minutes from transformation_rating 
	having (runtime_minutes not between mean(runtime_minutes) - 2 * std(runtime_minutes) 
	and mean(runtime_minutes) + 2 * std(runtime_minutes)) or runtime_minutes is missing ;
quit;

title" Data having outliers";

proc print data=outliers;
run;

/* replacing outlier with mean */
proc sql;
	create table outliers_free_data as select *, case when runtime_minutes
	not between mean(runtime_minutes) - 2 * std(runtime_minutes) 
	and mean(runtime_minutes) + 2 * std(runtime_minutes) or missing(runtime_minutes)
	then mean(runtime_minutes) 
	else runtime_minutes end as audio_runtime_mins from transformation_rating;
quit;


title"Histogram of runtime_minutes before";
ods select histogram;
proc univariate data=outliers_free_data noprint;
	var runtime_minutes;
	histogram / normal ;
	output out=stats_runtime_minutes pctlpre=prec pctlpts=25 50 75 mean=mean_v 
	skewness=skewness_v ;
run;

title"Skewness before removing outliers and null values";
proc print data=stats_runtime_minutes;
run;


title"Histogram of runtime_minutes after";
ods select histogram;
proc univariate data=outliers_free_data noprint;
	var audio_runtime_mins;
	histogram / normal ;
	output out=stats_audio_runtime_mins pctlpre=prec pctlpts=25 50 75 mean=mean_v 
	skewness=skewness_v ;
run;

title "Skewness after removing outliers and null values";
proc print data=stats_audio_runtime_mins;
run;


proc means data=outliers_free_data ;
var rating;
output out=rating_stat mean=mean_v;
run;




proc stdize data=outliers_free_data reponly method=mean out=Complete_data;

var rating;
run;

proc means data=Complete_data ;
var rating;
output out=rating_stat2 mean=mean_v2;
run;

proc sort data=outliers_free_data;
by rating;
run;

proc standard data=outliers_free_data replace ;
var rating;
run;

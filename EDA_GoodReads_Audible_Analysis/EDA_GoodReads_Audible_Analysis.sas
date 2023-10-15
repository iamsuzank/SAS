/* *********************************SUJAN KATWAL**************************************************** */
/* CREATING LIBRARY */
libname mylib '/home/u63049952/BAN110_Project/library/';

/* path to audible_data dataset */
filename audio '/home/u63049952/BAN110_Project/library/audible_data.xlsx';

/* path to Books_Rating_Record dataset */
filename book '/home/u63049952/BAN110_Project/library/Books_Rating_Record.xlsx';

/* ------------------------------------------------------------------------------------------ */
/* importing Books_Rating_Record dataset  from xlsx file */
proc import datafile=book out=mylib.books dbms=xlsx replace;
run;

/* importing dataset audible_data from xlsx file */
proc import datafile=audio out=mylib.audible dbms=xlsx replace;
run;

/* --------------------------------------------------------- */
/* DATASET - BOOK */
/* ------------------------------------------------------------ */
/* -------------------------------------------- */
/* analyzing the dataset books */
/* ------------------------------------------------ */
/* Generate random data using PROC SURVEYSELECT */
%let size = 10;
proc surveyselect data=mylib.books out=books_sample method=srs sampsize=&size;
run;

/* Display the sample data */
proc print data=books_sample(obs=3);
run;

/* finding missing and not missing character columns */
proc format;
	value $missfrm ' '='Missing' other='Not Missing';
run;

title "Missing vs Non Missing in Character columns";

proc freq data=mylib.books;
	format _char_ $missfrm.;
	tables _char_ / missing nocum nopercent;
run;

/* finding missing and not missing character columns */
title "Missing vs Non Missing in Numerical columns";

proc means data=mylib.books n nmiss;
run;

/* creating a new dataset for cleaning data */
data books_data;
	/* removing empty column M from original dataset */
	set mylib.books(drop=M);

	/* removing book name after ( this symbol */
	title=scan(title, 1, '(');

	/* removing book name after / */
	title=scan(title, 1, '/');

	/* keeping only the main author name by removing the secondary authors name after / */
	authors=scan(authors, 1, '/');

	/* removing books having more than or equal to 1 special characters and
	that are not in english languages */
	if countc(title, 'é‹¼ã®éŒ¬é‡‘è¡“å¸« 4!@#$%^&*()_+-={}[]|:;"<>,.?/~`') >=1 and 
		language_code not in ('eng', 'en-US', 'en-GB') then
			delete;

	/* Removing the special characters  from columns authors and title*/
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

/* ------------------------------------------------------- */
/* Removing duplicates records */
/* ------------------------------------------------------- */
/* Method 1. Duplicates- removing the duplicates value */
proc sort data=books_data noduprecs out=clean_book;
	/* checks the entire columns */
	by title authors;
run;

/* Method 2. Duplicates - displaying duplicate value based on title and authors name */
data books_data;
	set clean_book;
	by title authors;
	retain count;

	/* if first.title and first.authors and last.authors and last.title   then count = 1; */
	/* else */
	
	if first.title and first.authors then
		count=1;
	else
		count+1;

	if count > 1 then

		/* 	deleting the repeated observation */
		delete;
	drop count;

	/* 	extracting the year from the publication date */
	Year_Published=year(input(publication_date, mmddyy10.));
	drop publication_date;
run;

/* ---------------------------------------------------------------------- */
/* CHECKING THE DISTRIBUTION */
title"Ratings_count Original Histogram (with Outliers/empty values):";

proc univariate data=books_data noprint;
	var ratings_count;
	histogram;
	output out=stats_rc_1 pctlpre=perc pctlpts=25 50 75 mean=mean_v 
		skewness=skewness_v;
run;

title"Ratings_Count Statistics with Outliers:";

proc print data=stats_rc_1;
run;

data _null_;
	set stats_rc_1(obs=1);

	/* Use OBS=1 option to read only the first observation */
	call symputx('br_q1', perc25);
	call symputx('br_q2', perc50);
	call symputx('br_q3', perc75);
	call symputx('mean', mean_v);
	call symputx('skewness', skewness_v);
run;

data temp_2;
	set books_data;
	Q1=&br_q1.;
	Q2=&br_q2.;
	Q3=&br_q3.;
	mean=&mean.;

	if ratings_count > (Q3 + 1.5*(Q3 - Q1)) then
		ratings_count=Q2;

	/* the value of Q1 - 1.5*(Q3 - Q1) is negative since num of ratings can't be negative.
	also difference between mean and median (Q2) IS HUGE so we chose median(Q2) instead of
	MEAN TO make the distribution symmetrical*/
	/* 	if ratings_count < Q1 then */
	/* 		ratings_count=Q2; */
	if missing(ratings_count) then
		ratings_count=mean;
	drop Q1 Q2 Q3 mean;
run;

title "Ratings_Count Histogram after replacing outliers";

proc univariate data=temp_2 noprint;
	var ratings_count;
	histogram;
	output out=stats_rc_2 pctlpre=perc pctlpts=25 50 75 mean=mean_v 
		skewness=skewness_v;
run;

title "Ratings_Count Statitics after replacing outliers";

proc print data=stats_rc_2;
run;

data transformation_book;
	set temp_2;
	log_ratings_count=log(ratings_count+10);
run;

title "Ratings_Count Histogram after log transformation";

proc univariate data=transformation_book noprint;
	var log_ratings_count;
	histogram;
	output out=stats_rc_3 pctlpre=perc pctlpts=25 50 75 mean=mean_v 
		skewness=skewness_v;
run;

title"Ratings_Count Statistics after log transformation:";

proc print data=stats_rc_3;
run;

/*  */
/* final books dataset before merging*/
data final_books;
	set transformation_book;
run;

/* ****************************** UMESH BHATTA *************************************************************************** */
/* ------------------------------------------------------------------------------------- */
/* -------------------------------- */
/* Audible Dataset */
/* -------------------------------- */
/*Converting Rating column into numeric column and replacing missing values with
the mean values */

/* Checking our Audio dataset */
/* Define the sample size */
/* Generate random data using PROC SURVEYSELECT */
title "Audio data sample";
proc surveyselect data=mylib.audible out=sample_audio method=srs 
		sampsize=&size;
run;

/* Display the sample data */
title "Audio data sample";
proc print data=sample_audio(obs=1);
run;

data audibleDataset;
	set mylib.audible
	(keep='Book Title'n 'Book Author'n 'Book Narrator'n 'Audio Runtime'n 
		Audiobook_Type Categories Rating 'Total No. of Ratings'n price);

	/* renaming columns name with spaces between words */
	rename 'Book Title'n=title 'Book Author'n=authors 
		'Book Narrator'n=Book_Narrator 'Audio Runtime'n=Audio_Runtime 
		'Total No. of Ratings'n=Total_No_of_Ratings;

	/* removing book name after ( this symbol */
	title=scan(title, 1, '(');

	/* removing book name after / */
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

	/* Removing the character values in the Rating column of SAS dataset */
	if Rating='Not rated yet' then
		Rating=' ';

	/* else Rating = '5 out of 5 st' then Rating = '5'; */
	ratingNumericConverted=input(Rating, 8.2);
	format ratingNumericConverted 8.2;
	drop Rating;

	/*Converting Audio Runtime in minutes*/
	hrs=input(scan('Audio Runtime'n, 1, ' '), best12.);
	mins=input(scan('Audio Runtime'n, 4, ' '), best12.);
	audioRuntimeInMinutes=hrs * 60 + mins;

	/* 	drop 'Audio Runtime'n; */
	rename audioRuntimeInMinutes=Runtime_Minutes ratingNumericConverted=Rating;
	drop hrs mins;
run;

/* -------------------------------------------------------------------------------- */

proc format;
	value $missfrm ' '='Missing' other='Not Missing';
run;

proc freq data=audibleDataset;
	format _char_ $missfrm.;
	tables _char_ / missing nocum nopercent;
run;

proc means data=audibleDataset n nmiss;
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
proc sort data=audibleDataset noduprecs;
	/* checks the entire columns */
	by title authors;

	/* Method - 2 */
	/* 2. Duplicates - displaying duplicate value based on title and authors name */
data audibleDataset;
	set audibleDataset;
	by title authors;
	retain count;

	/* if first.title and first.authors and last.authors and last.title   then count = 1; */
	/* else */
	if first.title and first.authors then
		count=1;
	else
		count+1;

	if count > 1 then
		delete;
	drop count;
run;

/* ---------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------- */
/* NORMILIZATION OF COLUMN - Total_No_of_Ratings */
/* ------------------------------------------------------------------------------ */
/* 1. Total_No_of_Ratings */
/* ************************** */
/* CHECKING THE DISTRIBUTION */
title"Histogram of Total_No_of_Ratings before removing outliers:";

proc univariate data=audibledataset noprint;
	var Total_No_of_Ratings;
	histogram;
	output out=rating_quartile pctlpre=Q pctlpts=25 50 75 pctlname=Q mean=mean_v 
		skewness=skewness_v;
run;

title"Statistics of Total_No_of_Ratings before removing outliers:";

proc print data=rating_quartile;
run;

data _null_;
	set rating_quartile(obs=1);

	/* Use OBS=1 option to read only the first observation */
	call symputx('ar_q1', qq);
	call symputx('ar_q2', q50);
	call symputx('ar_q3', q75);
	call symputx('ar_mean', mean_v);
run;

data temp_1;
	set audibledataset;
	Q1=&ar_q1.;
	Q2=&ar_q2.;
	Q3=&ar_q3.;
	mean=&ar_mean.;

	if Total_No_of_Ratings > (Q3 + 1.5*(Q3 - Q1)) then
		Total_No_of_Ratings=Q2;

	/* the value of Q1 - 1.5*(Q3 - Q1) is negative since num of ratings can't be negative
	so we replaced value less than Q1 and  empty value by q2 make the distribution symmetrical*/
	/* 	if Total_No_of_Ratings < Q1 then */
	/* 		Total_No_of_Ratings=Q2; */
	if missing(Total_No_of_Ratings) then
		Total_No_of_Ratings=Q2;

	/* 		* there is huge difference between median(Q2) and mean */
	/* 		so we choose Q2(median) for missing value */
	drop Q1 Q2 Q3;
run;

title"Histogram of Total_No_of_Ratings after removing outliers:";

proc univariate data=temp_1 noprint;
	var Total_No_of_Ratings;
	histogram;
	output out=stats_num_ratings pctlpre=Q pctlpts=25 50 75 pctlname=Q mean=mean_v 
		skewness=skewness_v;
run;

title "Statistics of  Total_No_of_Ratings after removing outliers";

proc print data=stats_num_ratings;
run;

data transformation_audio;
	set temp_1;
	log_Total_No_of_Ratings=log(Total_No_of_Ratings+10);
run;

title"Statistics of Total_No_of_Ratings after log transformation:";
proc univariate data=transformation_audio noprint;
	var log_Total_No_of_Ratings;
	histogram ;
	output out=audio_quartile pctlpre=Q pctlpts=25 50 75 pctlname=Q 
		skewness=skewness_v;
run;

title"Statistics of  Total_No_of_Ratings after log transformation";

proc print data=audio_quartile;
run;

/* --------------------------------------------------------------------------------- */
/* 2. Price */
/* **************************************** */
proc univariate data=transformation_audio noprint;
	var price;

	/* 	histogram/normal; */
	output out=audio_quartile pctlpre=Q pctlpts=25 50 75 pctlname=Q 
		skewness=skewness_value;
run;

title"statistics of price";

proc print data=audio_quartile;
run;

/* ---------------------------------------------------------- */
/* 3. Runtime_Minutes */
proc univariate data=transformation_audio noprint;
	var Runtime_Minutes;

	/* 	histogram / normal; */
	output out=stats pctlpre=perc pctlpts=25 50 75 mean=mean_v std=std 
		skewness=skewness_v;
run;

title"Statistics of  of column Runtime_Minutes before replacing empty value and removing outliers:";

proc print data=stats;
run;

data _null_;
	set stats(obs=1);

	/* Use OBS=1 option to read only the first observation */
	call symputx('rt_q1', perc25);
	call symputx('rt_q2', perc50);
	call symputx('rt_q3', perc75);
	call symputx('rt_mean', mean_v);
run;

data temp_run_time;
	set transformation_audio;
	Q1=&rt_q1.;
	Q2=&rt_q2.;
	Q3=&rt_q3.;
	mean=&rt_mean.;

	if Runtime_Minutes > (Q3 + 1.5*(Q3 - Q1)) then
		Runtime_Minutes=mean;

	if missing(Runtime_Minutes) then
		Runtime_Minutes=rt_mean;
	drop Q1 Q2 Q3 mean;
run;

proc univariate data=temp_run_time noprint;
	var runtime_minutes;
	output out=new_stats pctlpre=perc pctlpts=25 50 75 mean=means 
		skewness=skewness_nv;
run;

title"Statistics  of Runtime_Minutes after removing Outliers: ";

proc print data=new_stats;
run;

/* ------------------------------------------------ */
/* final audbile dataset before merging */
data final_audible;
	set temp_run_time;
run;

/* *******************************Rahul Singh Adhikari***************************************************** */
/* ------------------------------------------------------------------- */
data mylib._book_;
	set final_books(drop=bookid language_code isbn isbn13 ratings_count);
run;

data mylib._audible_;
	set final_audible(keep=title authors Book_Narrator Audiobook_Type Categories 
		Rating price Runtime_Minutes log_Total_No_of_Ratings);
run;

proc sort data=mylib._book_;
	by title authors;
run;

proc sort data=mylib._audible_;
	by title authors;
run;

/* using macros to define threshold value */
/*  the default value is 0.8.  */
%let title_cutoff=7;
%let authors_cutoff=4;

/* merging two dataset book and qudible based the similarity of book title and author */
/* using fuzzy matching function complev */
proc sql;
	create table mylib.book_audible as select *, 
		/* 	book.title , book.authors ,  */
		/* 		book.average_rating , book.log_ratings_count , book.publication_date ,  */
		/* 		book.publisher, */
		audible.title, audible.authors, audible.Book_Narrator, 
		audible.Audiobook_Type, audible.Categories, audible.Rating, audible.price, 
		audible.Runtime_Minutes, audible.log_Total_No_of_Ratings 
		from mylib._book_ book inner join mylib._audible_ audible
		on
		complev(book.title, audible.title, 
		'ILN:') <&title_cutoff and complev(book.authors, audible.authors, 'ILN:') 
		< &authors_cutoff;
quit;

/* removing  duplicate records in all fields */
proc sort data=mylib.book_audible noduprecs out=combined;
	/* checks the entire columns */
	by title authors;

	/* removing duplicate data if the book title and author is same */
data clean_combined;
	set combined;
	by title authors;
	retain count;

	/* 	if first.title and first.authors and last.authors and last.title   then count = 1; */
	/* 	else */
	if upcase(first.title) and upcase(first.authors) then
		count=1;
	else
		count+1;

	/*  */
	if count > 1 then
		delete;
	drop count;
	Book_='  num_pages'n;

	/* 	changing the character column to numeric */
	Book_Pages=input(put(Book_, 5.), 5.);

	/* 	changing the character column to numeric */
	Book_Rating=input(put(average_rating, 8.2), 8.2);

	/* 	changing the character column to numeric */
	Audio_Rating=input(put(Rating, 8.2), 8.2);
	rename log_ratings_count=log_No_Of_Book_Ratings 
		log_total_no_of_ratings=log_No_Of_Audio_Ratings;
	drop average_rating rating '  num_pages'n Book_ text_reviews_count;
run;

proc sql;
	select count(*) as num_obs from clean_combined;
quit;

title "Sample dataset after Joining two datasets";

proc surveyselect data=clean_combined out=combined_sample method=srs 
		sampsize=&SIZE;
run;

/* Display the sample data */
proc print data=combined_sample(obs=3);
run;

/* ********************************DAMODAR KHADKA*************************************************************** */
/* ----------------------------------------------------------------------------------------- */
/* OUTLIER DETECTION AND REMOVAL*/
/* ----------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------- */
/* For book_rating column */
/* Checking if a column has outliers and missing value or not */
/* finding outliers in numerical columns */
proc sql;
/*  */
/* q3+Q3-q1> */
/* q1-(q3-q1)< */
/* mean(x)-2*std(x)< */
/* mean(x)+2*std(x)> */

	create table outliers as select * from clean_combined having (book_rating not 
		between mean(book_rating) - 2 * std(book_rating) and mean(book_rating) + 2 * 
		std(book_rating)) or book_rating is missing or (audio_rating not between 
		mean(audio_rating) - 2 * std(audio_rating) and mean(audio_rating) + 2 * 
		std(audio_rating)) or audio_rating is missing or (log_No_Of_Book_Ratings not 
		between mean(log_No_Of_Book_Ratings) - 2 * std(log_No_Of_Book_Ratings) and 
		mean(log_No_Of_Book_Ratings) + 2 * std(log_No_Of_Book_Ratings)) or 
		log_No_Of_Book_Ratings is missing or (log_No_Of_Audio_Ratings not between 
		mean(log_No_Of_Audio_Ratings) - 2 * std(log_No_Of_Audio_Ratings) and 
		mean(log_No_Of_Audio_Ratings) + 2 * std(log_No_Of_Audio_Ratings)) or 
		log_No_Of_Audio_Ratings is missing or (Price not between mean(Price) - 2 * 
		std(Price) and mean(Price) + 2 * std(Price)) or Price is missing;
quit;

title" Data having outliers";

proc print data=outliers(obs=3);
run;

/* replacing outlier with mean */
proc sql;
	create table combined_normalized as SELECT title , authors , year_published, 
		log_No_Of_Book_Ratings ,  publisher , Price , 
		Book_Narrator, Runtime_Minutes , Audiobook_Type , Categories , 
		log_No_Of_Audio_Ratings , book_Pages, Book_Rating , Audio_Rating, case when 
		book_rating not between mean(book_rating) - 2 * std(book_rating) and 
		mean(book_rating) + 2 * std(book_rating) or missing(book_rating) then 
		mean(book_rating) else book_rating end as Rating_Book,
		
		/* 		replacing Book_Rating column with Rating_Book */
		case when audio_rating not between mean(audio_rating) - 2 * 
		std(audio_rating) and mean(audio_rating) + 2 * std(audio_rating) or 
		missing(audio_rating) then mean(audio_rating) else audio_rating end as Rating_Audio,		
		/* 		replacing Audio_Rating column with Rating_Audio column */
		case when log_No_Of_Audio_Ratings not between 
		mean(log_No_Of_Audio_Ratings) - 2 * std(log_No_Of_Audio_Ratings) and 
		mean(log_No_Of_Audio_Ratings) + 2 * std(log_No_Of_Audio_Ratings) then 
		mean(log_No_Of_Audio_Ratings) else log_No_Of_Audio_Ratings end as Audio_Ratings_Num, 
		
		case when log_No_Of_Book_Ratings not between 
		mean(log_No_Of_Book_Ratings) - 2 * std(log_No_Of_Book_Ratings) and 
		mean(log_No_Of_Book_Ratings) + 2 * std(log_No_Of_Book_Ratings) then 
		mean(log_No_Of_Book_Ratings) else log_No_Of_Book_Ratings end as 
		Book_Ratings_Num , 
		
		case when Runtime_Minutes not between 
		mean(Runtime_Minutes) - 2 * std(Runtime_Minutes) and mean(Runtime_Minutes) 
		+ 2 * std(Runtime_Minutes) or missing(Runtime_Minutes)then 
		mean(Runtime_Minutes) else Runtime_Minutes end as Audio_Duration, 
		
		case when Book_Pages not between mean(Book_Pages) - 2 * std(Book_Pages) and 
		mean(Book_Pages) + 2 * std(Book_Pages) then mean(Book_Pages) else Book_Pages 
		end as Num_Pages from clean_combined;
quit;

data combined_normalized;
	set combined_normalized(drop=audio_rating book_rating Runtime_Minutes 
		 Book_Pages);

	/* applying square root transformation on book_pages column */
	/* 	book_pages=sqrt(book_pages); */
run;

title"Histogram of num of pages before";
proc univariate data=combined_normalized noprint;
	var Num_Pages;
	histogram;
	output out=stats_book_pgs pctlpre=prec pctlpts=25 50 75 mean=mean_v 
		skewness=skewness_v run;
	title"Book Pages after Square root transformation";

proc print data=stats_book_pgs;
run;

title "Final dataset";

/* drop audio_rating book_rating */
proc print data=combined_normalized(obs=3);
run;

/* checking if any numerical columns have empty value or not? */
proc means data=combined_normalized n nmiss;
run;

/* ------------------------------------------------------------------------------------------ */
/* 2. checking the skewness of audio_rating column */
proc univariate data=clean_combined noprint;
	var audio_rating;
	output out=audio_rating_quartile pctlpre=perc pctlpts=25 50 75 mean=mean_v 
		skewness=skw;
run;

/* *********************************** MD AAQUI AALAM ******************************************************************* */
/* ---------------------------------------------------*/
/* 1. which is the most popular genre? */
/* ---------------------------------------------------*/
/* most popular genre */
proc freq data=combined_normalized noprint;
	tables categories / out=categories_count(keep=categories Count where=(count>0 
		and categories <> ''));
run;

proc sort data=categories_count out=top_5_genre;
	by descending Count;
run;

proc print data=top_5_genre;
	title"Books / Audio Books by Categories";

proc sgplot data=top_5_genre(obs=5);
	hbar categories / response=COUNT datalabel datalabelattrs=(color=green) 
		dataskin=matte barwidth=0.5;
	yaxis label='Genre Name';
	xaxis label='No of Books/Audio Published ';
run;

/* --------------------------------------------------------------------------------------------- */
/* business qsn 2: who is the popular book narator */
/* --------------------------------------------------------------------------------------------- */
data top_book_narrator;
	set clean_combined(keep=book_narrator);
run;

proc freq data=clean_combined noprint;
	tables book_narrator / out=book_narrators_counts(keep=Book_narrator Count 
		where=(count>0));
run;

/* Sort the book_narrators_counts dataset in descending order of count */
proc sort data=book_narrators_counts;
	by descending Count;
run;

/* Keep only the top 10 rows */
data book_narrator_top10;
	set book_narrators_counts (obs=10);
run;

title"Top Book Narattor";

proc sgplot data=book_narrator_top10;
	hbar book_narrator / response=count fillattrs=(color=orange);
	xaxis grid;
	yaxis discreteorder=data display=(nolabel);
	yaxis label='Narrator Name';
	xaxis label='No of Books Narrated';
run;

/* ---------------------------------------------------------------------------- */
/* BQN 3. What is the average price of audio books by categories? */
/* ---------------------------------------------------------------------------- */
/*  Sort the dataset by categories*/
proc sort data=combined_normalized;
	by categories;
run;

/*  Calculate the average price per year */
proc means data=combined_normalized noprint;
	class categories;
	var price;
	output out=avg_price_by_genre(drop=_type_ _freq_) mean=avg_price;
run;

title "graph";

/* Create a line chart of the average price per year */
ods graphics on;

/* Enable ODS graphics */
proc sgplot data=avg_price_by_genre;
	title 'Average Price of Audio Books by Genre';
	label genre='Genre/Categores' avg_price='Average Price';
	series x=categories y=avg_price / lineattrs=(thickness=4);
	xaxis label='Genre/Categories';
	yaxis label='Average Price';
run;

/* displaying the line graph */
/* ods noproctitle; */
/* ods graphics / imagemap=on; */
/* proc corr data=COMBINED_NORMALIZED pearson nosimple noprob  */
/* 		plots=scatter(ellipse=prediction alpha=0.05 nvar=10 nwith=10); */
/* 	var Rating_Audio; */
/* 	with Rating_Book; */
/* run; */
/* ***********************************      2     ***************************************** */
/* 2. reading the cust file and displaying 10 random records. Find key insights */
/* ************************************************************************************** */
/* --------------------Cust File ------------------------- */
proc import file="/home/u63049952/BAN210/Project/custfile.csv" out=cust 
		dbms=csv Replace;
	delimiter=',';
	***	TAB - delimiter	;
	GUESSINGROWS=20;
	getnames=YES;
run;

/* Define the sample size */
%let n=10;

/* randomly selecting 10 different observations from the dataset */
proc surveyselect data=cust out=sample_customer method=srs sampsize=&n;
run;

/* Display the sample data */
title "sample customer data";

proc print data=sample_customer;
run;

proc print data=cust;
run;


/* ------------------------Trans File ------------------------------------ */
/* reading the cust file and displaying 10 random records */
proc import file="/home/u63049952/BAN210/Project/transfile.csv" out=trans 
		dbms=csv Replace;
	delimiter=',';
	***	TAB - delimiter	;
	GUESSINGROWS=20;
	getnames=YES;
run;

/* randomly selecting 10 different observations from the dataset */
proc surveyselect data=trans out=sample_transction method=srs sampsize=&n;
run;

/* Display the sample data */
title "sample transction data";

proc print data=sample_transction;
run;



/* ******************************************  3 *********************************************/
/* 3. Conduct frequency distributions on all variables in each source file */
/* ******************************************************************************************* */
*determine contents of data;

proc contents data=cust;
run;

/* renaming the columns name */
data cust;
	set cust;
	rename "region of country"n=region_of_country "source code"n=source_code 
		"preferred payment type"n=preferred_payment_type 
		"Number in house"n=Number_in_house "credit score"n=credit_score 
		"customer id"n=customer_id "tenure date"n=tenure_date 
		"year of birth"n=year_of_birth "type of card"n=type_of_card;
run;

/* proc freq data=cust; */
/* 	tables region_of_country source_code gender preferred_payment_type/missing; */
/* run; */

data cust1;
	set cust;
	region_of_country1=upcase(compress(region_of_country));
	source_code1=upcase(compress(source_code));
	preferred_payment_type1=upcase(compress(preferred_payment_type));
	gender1=upcase(compress(gender));
	DOB=year(input(year_of_birth, yyddmm10.));
	drop region_of_country source_code gender preferred_payment_type;
run;


/* Scatter plots of all the variables in customer file */
title "Scatter Plot Matrix";
ods graphics / width=640px height=480px;
proc sgscatter data=cust1;
	matrix  income education number_in_house credit_score 
/* 	region_of_country1 source_code1 gender1 preferred_payment_type1  */
DOB / diagonal=(histogram 
		kernel);
run;



proc freq data=cust1;
	tables region_of_country1 source_code1 gender1 preferred_payment_type1/missing;
run;

title "Distribution  # of customers by region";

proc sgplot data=cust1;
	*label reion_of_countrytottran = 'total transaction';
	format region_of_country1;
	hbar region_of_country1/missing datalabel colorstat=freq dataskin=matte 
		categoryorder=respdesc;
	yaxis label="Region of Country";
	xaxis label="Num. of Customers";
run;

/* frequency distribution in preferred payment type */
title "Distribution  # of customers by preferred payment type";

proc sgplot data=cust1;
	*label reion_of_countrytottran = 'total transaction';
	format preferred_payment_type1;
	hbar preferred_payment_type1/missing datalabel colorstat=freq dataskin=matte 
		categoryorder=respasc;
	yaxis label="Payment Types";
	xaxis label="Num. of Transction";
run;

title "Distribution  # of customers by gender";

proc sgplot data=cust1;
	*label reion_of_countrytottran = 'total transaction';
	format gender1;
	vbar gender1/ fillattrs=(color=CXe6cade) datalabel missing datalabel 
		colorstat=freq dataskin=matte categoryorder=respdesc;
	xaxis label="gender";
	yaxis label="population";
	yaxis grid;
run;

title "Distribution  # of customers by Source Code";

proc sgplot data=cust1;
	*label reion_of_countrytottran = 'total transaction';
	format source_code1;
	hbar source_code1/missing datalabel colorstat=freq dataskin=matte 
		categoryorder=respdesc;
	yaxis label="Source Code";
	xaxis label="Numbers";
run;

/* histogram of income */
title "histogram of income ";

proc sgplot data=WORK.CUST1;
	histogram income / scale=count showbins fillattrs=(color=CX8fdf18) 
		filltype=gradient;
	density income;
	density income / type=Kernel;
	xaxis valuesrotate=diagonal;
	yaxis grid;
run;

ods graphics / reset;

/* histogram of year of Birth */
title "histogram of year of Birth";

proc sgplot data=WORK.CUST1;
	histogram DOB/ scale=count showbins fillattrs=(color=CX8fdf18) 
		filltype=gradient;
	density DOB;
	density DOB / type=Kernel;
	xaxis valuesrotate=diagonal;
	yaxis grid;
run;

ods graphics / reset;
title;

/* histogram of year of Birth */
title "histogram of year of Credit Score";

proc sgplot data=WORK.CUST1;
	histogram credit_score/ scale=count showbins fillattrs=(color=CX8fdf18) 
		filltype=gradient;
	density credit_score;
	density credit_score / type=Kernel;
	xaxis valuesrotate=diagonal;
	yaxis grid;
run;

ods graphics / reset;
title;


/* ------------------------------------------------------------------------------------------ */

data trans;
set trans;
rename 
"customer id"n=customer_id
"transaction date"n=transaction_date
"transaction type"n = transaction_type;

	
run;

proc contents data=trans;
run;



proc freq data=trans;
run;

title"histogram of amount";
proc sgplot data=trans;
	histogram amount / scale=count showbins fillattrs=(color=CX8fdf18) 
		filltype=gradient;
	density amount;
	density amount / type=Kernel;
	xaxis valuesrotate=diagonal;
	yaxis grid;
run;


title "Distribution  # of transaction_type";
proc sgplot data=trans;
	*label reion_of_countrytottran = 'total transaction';
	format transaction_type;
	vbar transaction_type/ fillattrs=(color=CXe6cade) datalabel missing datalabel 
		colorstat=freq dataskin=matte categoryorder=respdesc;
	xaxis label="transaction type";
	yaxis label="Num of transction";
	yaxis grid;
run;
title;



ods graphics / reset width=6.4in height=4.8in imagemap;
title "Distribution of # in House";
proc sgplot data=CUST1;
	vline Number_in_house / datalabel lineattrs=(color=CX990099);
	yaxis grid;
run;
title;
ods graphics / reset;

/* Pie chart for education */
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart category=education / stat=pct start=270 datalabellocation=callout 
			fillattrs=(transparency=0.25) dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;
 
ods graphics / reset width=6.4in height=4.8in imagemap;
title "Distribution of Education";
proc sgrender template=SASStudio.Pie data=CUST1;
run;
title;
ods graphics / reset;



/* ****************************************************  4  **************************** */
/* CONDUCT BASIC STATISTICAL FUNCTIONS */
/* ************************************************************************************** */
proc contents data=cust1;
run;

/* proc means data=cust1 min max mean median stddev; */
/* class  */
/* gender1 */
/* preferred_payment_type1 */
/* region_of_country1 */
/* ; */
/* run; */



title "Before Replacing missing value";
proc corr data=cust1;
var 
income 
education 
Number_in_house
credit_score
year_of_birth 
tenure_date;
run;



proc stdize data=cust1 reponly method=mean out=cust_balanced;
var
income 
education 
Number_in_house
credit_score
year_of_birth 
tenure_date;
run;


title "After Replacing Missing Values with Means";
proc corr data=cust_balanced;
var 
income 
education 
Number_in_house
credit_score
year_of_birth 
tenure_date;
run;
title;

proc contents data=trans;
run;

/* proc corr data=trans; */
/* var  */
/* amount  */
/* transaction_date */
/* transaction_type */
/* ; */
/* run; */
/*  */
/*  */
/* proc stdize data=trans */
/*  reponly method=mean out=trans_balanced; */
/* var */
/* amount  */
/* transaction_date; */
/* run; */
/*  */
/*  */
/* proc corr data=trans_balanced; */
/* var  */
/* amount  */
/* transaction_date */
/* transaction_type */
/* ; */
/* run; */



PROC MEANS DATA=trans NOPRINT;
var 
amount
transaction_date;
	OUTPUT OUT=trans_stat
	min=min_amount min_trans_date
	max=max_amount max_trans_date
	MEAN= mean_amount mean_trans_date
	MEDIAN=med_amount med_trans_date
	stddev=std_amount std_trans_date;
RUN;


data statistics_trans;
infile datalines dlm=',';
  length Attributes $ 15 Min$ 15  Max$ 15  Mean $ 15 Median $ 15 Std_Deviation $ 15;
  input Attributes $ Min Max Mean Median Std_Deviation ;
  datalines;
Amount,200,1200,619.02,561, 269.53		
Transction Date,2012-01-31,2019-07-20,2016-06-11,2016-12-26,1961-12-02
;
run;

title "Transction Statistics";
proc print data=statistics_trans;
run;


PROC MEANS DATA=CUST1 NOPRINT;
	VAR income education ; 
/* 	Number_in_house credit_score year_of_birth tenure_date; */
	OUTPUT OUT=stat_1
	MEDIAN=med_income med_edu 
	MEAN=mean_income mean_edu 
	min=min_income min_edu 
	max=max_income max_edu 
	stddev=std_income std_edu ;
RUN;

PROC MEANS DATA=CUST1 NOPRINT;
	VAR  
	Number_in_house
	credit_score;
/* 	year_of_birth tenure_date; */
	OUTPUT OUT=stat_2
	
	min=min_house min_credit
	max=max_house max_credit
	MEAN= mean_house mean_credit
	MEDIAN=med_house med_credit

	stddev=std_house std_credit;
RUN;

PROC MEANS DATA=CUST1 NOPRINT;
	VAR  
/* 	income education */
/* 	Number_in_house */
/* 	credit_score; */
	year_of_birth tenure_date;
	OUTPUT OUT=stat_3
	min=min_YOB min_tenure
	max=max_YOB max_tenure
	MEAN= mean_YOB mean_tenure
	MEDIAN=med_YOB med_tenure
	stddev=std_YOB std_tenure;
RUN;

proc print data=stat_3(drop=_freq_ _type_);
run;


data statistics;
infile datalines dlm=',';
  length Attributes $ 15 Min$ 15  Max$ 15  Mean $ 15 Median $ 15 Std_Deviation $ 15;
  input Attributes $ Min Max Mean Median Std_Deviation ;
  datalines;
Income,23384,147898,81800.16,82955,36778.55
Education,10,20,15.36,15,3.15
Num_in_House,1,5,3.1,4,91.47
Credit_Score,303,749,516.44,550,137.35
Year_Of_Birth,1940-01-20,1997-09-19,1968-06-03,1967-04-01,1977-10-23	
Tenure_Date,2010-06-17,2021-12-02,2017-02-22,2017-08-01,1963-04-28		
;
run;

title"Customer Statistics";
proc print data=statistics;
run;
title;


/* proc univariate data=cust1 noprint; */
/* 	var year_of_birth tenure_date */
/* 		type_of_card	 */
/* 		gender1	 */
/* 		source_code1 */
/* 		preferred_payment_type1	 */
/* 	income education Number_in_house credit_score; */
/* 	histogram; */
/* run; */



/* ************************************************* 5 ************************************************* */

/* join trans file and cust file. display 5 random sample */
/* ************************************************************************************************ */

/* ---------------------------analytical file--------------------------------------- */
proc sql;
    Create Table analytical_file as
    Select c.*,t.*
    from cust1 as c inner join trans as t
    ON c.customer_id= t.customer_id;
quit;


proc surveyselect data=analytical_file sampsize=5 method=srs out=sample_analytical_file;
run;


title "Cust-Trans Combined File";
proc print data=sample_analytical_file;
run;
title;

/* **************************************** 6 ***************************************** *****************/
/* 10 derived variables from analytical variables and depicts min, max, mean, median std dev */
/* **************************************************************************************************** */


data derived_vars;
length region_of_country1 $ 15;
	set analytical_file;
	by customer_id;
	age=intck('year', year_of_birth, today());
	tenure=intck('year', TENURE_DATE, today());
	if first.customer_id then do;
	total_expenditure=0;
	total_transaction=0;
	total_expenditure+amount;
	total_transaction+1;
	end;
	else do;
	total_expenditure+amount;
	total_transaction+1;
	end;
	
	if last.customer_id then do;
	expenditure_per_year=total_expenditure/tenure;
	expenditure_per_trans=total_expenditure/total_transaction;
	transaction_per_year=ceil(total_transaction/tenure);
/* 	ptc=propensity to consume = expenditure/income */
	PTC=expenditure_per_year/income;
	output;
	end;
	format income total_expenditure expenditure_per_year expenditure_per_trans dollar15.2;
	format ptc 8.2;
	rename region_of_country1=Region_Name;
run;


data derived_vars_list;
set derived_vars(keep= age
 tenure
 total_expenditure
 total_transaction
 expenditure_per_year
 expenditure_per_trans
 transaction_per_year
 ptc);
 run;
 
title "List of Derived Variables";
footnote "PTC = Propensity to consume = expenditure / income";
proc print data=derived_vars_list(obs=10);
run; 
title;

 

 title"Basic Statistics in Derived Variables Wih Missing Value";
 proc means data=derived_vars(keep=
 age
 tenure
 total_expenditure
 total_transaction
 expenditure_per_year
 expenditure_per_trans
 transaction_per_year
 ptc
 )
 n nmiss 
 mean p50 std min max maxdec=2 STACKODS;

 output out=stats1 
 n= nmiss= 
 mean= p50= std= min=max=;
 ods output summary = Stats2;
 run;
 title;
 
 


/* proc means data=derived_vars; */
/* var age tenure; */
/* output out=sta median=med_age med_tenure; */
/* run; */

DATA derived_vars;
	SET derived_vars;

	IF expenditure_per_year=. THEN
		expenditure_per_year=18591.80;
	IF transaction_per_year=. THEN
		transaction_per_year=32.50;
	IF ptc=. THEN
		ptc=0.23;

run;




 title"Basic Statistics in Derived Variables ";
 ods noproctitle;
 proc means data=derived_vars(keep=
 age
 tenure
 total_expenditure
 total_transaction
 expenditure_per_year
 expenditure_per_trans
 transaction_per_year
 ptc
 )
/*  n nmiss  */
 mean median std min max maxdec=2 STACKODS;

 output out=stats1 
/*  n= nmiss=  */
 mean= median= std= min=max=;
 ods output summary = Stats2;
 run;
 title;


/* ********************************************* 7 ********************************************** */
/* ---------------------------------proc summary on derived Vars-------------------------------- */
/* ********************************************************************************************** */

PROC RANK DATA=derived_vars GROUP=4 OUT=exp_groups;
	VAR total_expenditure;
	RANKS exp_group;
run;
/*  */
/* proc print data=income_groups; */
/* run; */
/*  */
/* proc sort data=income_groups; */
/* by income_group; */
/* run; */
/*  */
/* proc gchart data=income_groups; */
/* vbar income_group / type=percent */
/* subgroup=gender1; */
/* run; */


proc summary data=exp_groups;
class exp_group;
var total_expenditure;
OUTPUT OUT=exp_category(drop=_type_ _freq_) 
MIN=min_exp 
MAX=max_exp 
MEAN=average_exp 
N=num_peoples sum=total_exp;
run;


data exp_category;
set exp_category;
if exp_group ne "";
by exp_group;
if exp_group=0 then do;
Groups="group_1";
output;
end ;
else if exp_group=1 then do;
Groups="group_2";
output;
end ;
else if exp_group=2 then do;
Groups="group_3";
output;
end ;
else if exp_group=3 then do;
Groups="group_4";
output;
end ;
drop exp_group;
format total_exp average_exp dollar15.2;
run;

title "Summary of Total Expenditure";
proc print data=exp_category;
run;
title;
/* proc sgplot data=x; */
/* vbarparm category=groups response=total_income / discreteoffset=-0.17 barwidth=0.3; */
/* vbarparm category=groups response=total_income / discreteoffset=0.17 barwidth=0.3; */
/* run; */



proc summary data=derived_vars;
class region_name;
var  
age
tenure
/*  total_expenditure */
/*  total_transaction */
/*  expenditure_per_year */
/*  expenditure_per_trans */
/*  transaction_per_year */
/*  ptc */
 ;
 output out=summary_1(drop = _type_ _freq_)
 min=age_min tenure_min 
 max=age_max tenure_max 
 mean=age_mean tenure_mean 
 median=age_med tenure_med
 stddev=age_std tenure_std ;
 run;
 
 title "Summary of age, tenure by regions";
 proc print data=summary_1;
 run;
 title;
 
 
 
 
 
proc summary data=derived_vars;
class region_name;
var  
/* age */
/* tenure */
 total_expenditure
 total_transaction
/*  expenditure_per_year */
/*  expenditure_per_trans */
/*  transaction_per_year */
/*  ptc */
 ;
 output out=summary_2(drop = _type_ _freq_)
 min=totalExp_min totalTrans_min 
 max=totalExp_max totalTrans_max 
 mean=totalExp_mean totalTrans_mean 
 median=totalExp_med totalTrans_med
 stddev=totalExp_std totalTrans_std ;
 run;
 
 title "Summary of Total expenditure and Total Transaction by regions";
 proc print data=summary_2;
 run;
 title;



proc summary data=derived_vars;
class region_name;
var  
/* age */
/* tenure */
/*  total_expenditure */
/*  total_transaction */
 expenditure_per_year
 expenditure_per_trans
/*  transaction_per_year */
/*  ptc */
 ;
 output out=summary_3(drop = _type_ _freq_)
 min=Exp_PY_min Exp_PT_min 
 max=Exp_PY_max Exp_PT_max 
 mean=Exp_PY_mean Exp_PT_mean 
 median=Exp_PY_med Exp_PT_med
 stddev=Exp_PY_std Exp_PT_std ;
 run;
 
 title "Summary of Expenditure Per Year and Expenditure Per Transaction by regions";
 footnote"Exp_PY = Expenditure Per Year";
 footnote2"Exp_PT = Expenditure Per Transaction";
 proc print data=summary_3;
 run;
 title;
 footnote;
 footnote2;




proc summary data=derived_vars;
class region_name;
var  
/* age */
/* tenure */
/*  total_expenditure */
/*  total_transaction */
/*  expenditure_per_year */
/*  expenditure_per_trans */
 transaction_per_year
 ptc
 ;
 output out=summary_4(drop = _type_ _freq_)
 min=Trans_PY_min PTC_min 
 max=Trans_PY_max PTC_max 
 mean=Trans_PY_mean PTC_mean 
 median=Trans_PY_med PTC_med
 stddev=Trans_PY_std PTC_std ;
 run;
 
 title "Summary of Transaction Per Year and Propensity To Consume by regions";
 footnote"Trans_PY = Transaction Per Year";
 footnote2"PTC = Propensity To Consume";
 proc print data=summary_4;
 run;
 title;
 footnote;
 footnote2;


/*   */
/*  length region_name $15; */
/* set derived_vars; */
/* if  (compress(region_name))=" "  then region_name="All Regions"; */
/*  else if (compress(region_name)) in ('K') then region_name="EASTONT";  */
/*  else if (compress(region_name)) in ('L') then region_name= "OUTSIDEGTA"; */
/*  else if (compress(region_name)) in ('M') then region_name="TORONTO"; */
/*  else if (compress(region_name)) in ('N') then region_name="SOUTHWESTONT"; */
/*  else if (compress(region_name)) in ('P') then region_name="NORTHONT"; */
/*  else region_name="Other"; */
/*   */
/*  proc sql; */
/*     alter table my_data */
/*     modify team char(4); */
/* quit; */

/* or define length before the set statements */
 
 

/* PROC SUMMARY DATA=CUST NWAY MISSING; */
/* CLASS REGION_OF_COUNTRY1; */
/* VAR INCOME CREDIT_SCORE EDUCATION NUMBER_IN_HOUSE AGE TENURE; */
/* OUTPUT OUT=TESY MEAN=; */
/* ODS HTML RS=NONE; */
/*  */
/* PROC PRINT DATA=TESY; */
/* ID REGION_OF_COUNTRY1; */
/* RUN; */
/* ODS HTML CLOSE; */
/*  */


/* ****************************************Project End****************************** */

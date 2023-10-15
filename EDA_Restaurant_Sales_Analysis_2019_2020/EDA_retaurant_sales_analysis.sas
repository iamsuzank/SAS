/* loading the data */
proc import datafile='/home/u63049952/Projects/Top250.csv' out=restaurant_ranks 
		replace dbms=csv;
	getnames=yes;

		/* information about the data features */
proc contents data=restaurant_ranks;
run;

/* printing the first 10 data */
	proc print data=restaurant_ranks(obs=10);
	run;


title "Data Cleaning";
data data_cleaning;
/* removing the column contents */
	set restaurant_ranks(drop=content);
	category=strip(scan(segment_category, -1, '&/'));

	if find(segment_category, '&') or find(segment_category, '&') then
		do;
			segment=scan(segment_category, 1, '&/');
		end;
	else
		do;
			segment='Other';
		end;

	/* 		converting character column to numerical column */
	sales_by_yoy=input(compress(YOY_Sales, '%'), 4.2);
	units_by_yoy=input(compress(YOY_Units, '%'), 4.2);
	sales_19=ceil(sales - (sales_by_yoy/100*sales));
	units_19=ceil(units - (units_by_yoy/100*units));
	format sales sales_19 dollar11.;
run;

title;

/* top 10 restaurant based on segment category */
proc sort data=data_cleaning out=sorted_data nodupkey;
	by segment_category;
run;

proc freq data=sorted_data order=freq noprint;
	table segment_category / out=top_category(keep=segment_category count);
run;

/* top 10 restaurant based on category alone  */
/* 1. split the segment_category into category */
/* eg: Quick Service & Burger => Burger */
proc freq data=sorted_data(keep=category) order=freq noprint;
	table category / out=top_cat(keep=category count percent);
run;

title "Top 10 Most Popular Categories in Restaurnat";

proc sgplot data=top_cat(obs=10);
	hbar category / response=percent categoryorder=respdesc nostatlabel;
	xaxis label="No of Restaurant";
	yaxis label="Restaurant Categories";
run;

title;

/* displaying top 10 least pupular restaurant based on category */
data _null_;
	set top_cat nobs=total_obs;
	least_10=total_obs-10;
	call symputx('N', least_10);
run;

title "Top 10 Least Pupular Categories in Restaurant";

proc sgplot data=top_cat(firstobs=&N);
	hbar category / response=count categoryorder=respdesc colorstat=freq nostatlabel;
		xaxis label="No of Restaurant";
	yaxis label="Restaurant Categories";

run;

/* Top 10 restaurant based on the sale */
data restaurant_sales;
	set restaurant_ranks(keep=restaurant sales);
	format sales dollar11.;
run;

proc sort data=restaurant_sales out=ranks_by_sale;
	by descending sales;
run;

title "Top 10 Largest Restaurant based on their Sales Amount";

proc sgplot data=ranks_by_sale(obs=10);
	vbar restaurant / response=sales dataskin=matte datalabel 
		categoryorder=respdesc nostatlabel colorstat=freq;
	xaxis grid display=(nolabel);
	yaxis grid discreteorder=data display=(nolabel);
	xaxis label="Restaurant Name";
	yaxis label="Sales(K)";
run;

title;

/* title "Buttom 10 Smallest Restaurant based on their Sale"; */
proc sort data=ranks_by_sale;
	by sales;
run;

title "Bottom 10 Resaurant Based on their Sales Amount";

proc sgplot data=ranks_by_sale(obs=10);
	vbar restaurant / response=sales dataskin=matte datalabel 
		categoryorder=respdesc nostatlabel colorstat=freq;
	xaxis grid display=(nolabel);
	yaxis grid discreteorder=data display=(nolabel);
	xaxis label="Restaurant Name";
	yaxis label="Sales(K)";
run;

title;

/* top 10 restaurant based on the value of sales per units */
data sales_per_units;
	set data_cleaning(keep=restaurant sales units);
	sales_per_chain=sales/units;
	format sales_per_chain dollar15.2;
run;

proc sort data=sales_per_units out=top_10;
	by descending sales_per_chain;
run;

title "Top 10 Restaurant Based on Sales Per Unit";
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=top_10(obs=10);
	bubble x=Restaurant y=sales_per_chain size=sales_per_chain/ 
		colorresponse=Units colormodel=(CX00ff91 CXfafaff CXff0000) bradiusmin=7 
		bradiusmax=14;
	xaxis grid;
	yaxis grid;
	gradlegend / position=bottom;
run;

ods graphics / reset;
title "Bottom 10 Restaurant Based on Sales Per Unit";
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=sales_per_units out=buttom_10;
	by sales_per_chain;
run;

proc sgplot data=buttom_10(obs=10);
	bubble x=Restaurant y=sales_per_chain size=sales_per_chain/ 
		colorresponse=Units colormodel=(CX00ff91 CXfafaff CXff0000) bradiusmin=7 
		bradiusmax=14;
	xaxis grid;
	yaxis grid;
	gradlegend / position=bottom;
run;

ods graphics / reset;

/* Sales Amount by Segment */
proc freq data=data_cleaning order=freq;
	table segment / nocum nopercent;
run;

/* use PROC SQL to calculate the total sales by segment */
proc sql;
	create table combined_sales_by_segment as select segment, sum(sales) as 
		total_sales from data_cleaning group by segment;
quit;

/* display the output */
title"Total Sales Amount By each Segment";
proc print data=combined_sales_by_segment;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=COMBINED_SALES_BY_SEGMENT;
	by segment;
run;

ods graphics / reset;
title "Combined Sales of Restaurants by Segment";

proc sgplot data=COMBINED_SALES_BY_SEGMENT;
	series x=segment y=total_sales / lineattrs=(thickness=5 color=CX50df50) 
		transparency=0.5;
	xaxis grid;
	yaxis grid;
	xaxis label="Restaurant Segment";
	yaxis label="Combined Sales Amount(K)";
run;

ods graphics / reset;

proc freq data=COMBINED_SALES_BY_SEGMENT;
	table segment;
run;

data Quick_Service Casual_Dining Other Family_Dining Fast_Casual Fine_Dining;
	set data_cleaning(keep=restaurant sales segment sales_by_yoy units_by_yoy);

	if segment="Quick Service" then
		output Quick_Service;
	else if segment="Casual Dining" then
		output Casual_Dining;
	else if segment="Other" then
		output Other;
	else if segment="Family Dining" then
		output Family_Dining;
	else if segment="Fast Casual" then
		output Fast_Casual;
	else if segment="Fine Dining" then
		output Fine_Dining;
run;

/* Most popular  restaurant in quick service segment */
proc sort data=quick_service out=top_quick_service;
	by descending sales;
	FORMAT sales dollar15.2;
run;

title "Restaurant with Highest Sale in Quick Service Segment";

proc sgplot data=top_quick_service(obs=10);
	vbar restaurant / response=sales dataskin=MATTE datalabel 
		categoryorder=respdesc nostatlabel;
	xaxis grid display=(nolabel);
	yaxis grid discreteorder=data display=(nolabel);
	xaxis label="Restaurant Name";
	yaxis label="Sales(K)";
run;



/* printing the top restaurant name in quick service */
/* proc sort data=top_quick_service out=top_restaurant_quick_service; */
/* 	by descending sales; */
/* run; */
/*  */
/* title"Top 10 Restaurant Under Quick Service Segment"; */
/* proc print data=top_restaurant_quick_service(obs=10); */
/* run; */

/* comparing sales of 2019 vs 2020		 */
data stat_20;
	set data_cleaning(keep=restaurant units sales);
	year=2020;
run;

data stat_19;
	set data_cleaning(keep=restaurant units_19 sales_19);
	year=2019;
run;

data stat_comparison;
	set stat_19 stat_20;

	if (sales) then
		do;
			franchise_name=restaurant;
			total_sales=sales;
			year=2020;
			no_of_franchise=units;
		end;
	else if (sales_19) then
		do;
			franchise_name=restaurant;
			total_sales=sales_19;
			year=2019;
			no_of_franchise=units_19;
		end;
	drop sales units sales_19 units_19;
run;




data sales_19_vs_20;
	set stat_comparison;

	if franchise_name in ("McDonald's", "Starbucks", "Chick-fil-A", "Taco Bell", 
		"Burger King", "Subway", "Wendy's", "Dunkin'", "Domino's", "Pizza Hut") then
			output;
	format total_sales dollar11.2;
run;

proc sort data=sales_19_vs_20;
	by franchise_name;
run;

/* plotting the sales in 2019 vs 2020 of top quick service restaurants*/
title "Comparision of Sales in 2019 vs 2020 of Quick Service Top Restaurant";

proc sgplot data=sales_19_vs_20;
	vbar franchise_name / response=total_sales group=Year groupdisplay=cluster 
		categoryorder=respdesc;
	xaxis display=(nolabel);
	yaxis grid;
	xaxis label="Years";
	yaxis label="Sales Amount(K)";
run;

title;
title"No fo Franchise in 2019 vs 2020 of Quick Service Restaurant";

proc sgplot data=sales_19_vs_20;
	vbar franchise_name / response=no_of_franchise group=Year groupdisplay=cluster 
		categoryorder=respdesc;
	xaxis display=(nolabel);
	yaxis grid;
	xaxis label="Years";
	yaxis label="No of Frachise";
run;

title;

/* ------------------------------------------------------------------------------ */
title "Units vs Sale of Top Restaurant In Quick Service";

data units_vs_sales;
	set top_quick_service;
run;

/* use PROC SGPLOT to create the line graph */
proc sgplot data=units_vs_sales(obs=10);
	scatter x=sales_by_yoy y=units_by_yoy / datalabel=restaurant 
		markerattrs=(symbol=diamondfilled color=red);
	xaxis label='sales_by_yoy ';
	yaxis label='units_by_yoy';
run;

ods graphics / reset;

/* proc print data=data_cleaning(obs=10); */
/* run; */
/* Restaurant With Highest Year On Year Sales Increment */
title "Restaurant With Highest Year On Year Sales Increment";

proc sort data=data_cleaning out=yoy_restaurant_sales;
	by descending sales_by_yoy;
run;

title" Restaurant With Highest Year On Year Sales Increment In 2020";

proc sgplot data=yoy_restaurant_sales(obs=10);
	hbar restaurant / response=sales_by_yoy dataskin=matte datalabel 
		categoryorder=respdesc nostatlabel;
	xaxis grid display=(nolabel);
	yaxis grid discreteorder=data display=(nolabel);
	xaxis label="Year on year Increments in Sales %";
	yaxis label="Restaurant Name";
run;

/* Fastest Growing Restaurant with highesr Year on Year units Increment */
title"Restaurant with Highest Year On Year Units Increment";

proc sort data=data_cleaning out=yoy_chains;
	by descending units_by_yoy;
run;

title"Fastest Growing Restaurant In 2020";

proc sgplot data=yoy_restaurant_sales(obs=10);
	hbar restaurant / response=units_by_yoy dataskin=matte datalabel 
		categoryorder=respdesc nostatlabel;
	xaxis grid display=(nolabel);
	yaxis grid discreteorder=data display=(nolabel);
	xaxis label="Year on year Increments in Chains(Units) %";
	yaxis label="Restaurant Name";
run;

title;

/* Correlation between Units and Sales */
data sales_units_corr;
	set data_cleaning(keep=restaurant sales UNITS sales_by_yoy units_by_yoy);
	where sales_by_yoy is not missing and units_by_yoy is not missing;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
title "Correlation between Units and Sales";

proc sgplot data=SALES_UNITS_CORR;
	reg x=sales_by_yoy y=units_by_yoy / nomarkers cli alpha=0.10;
	pbspline x=sales_by_yoy y=units_by_yoy / nomarkers;
	scatter x=sales_by_yoy y=units_by_yoy / markerattrs=(symbol=diamond 
		color=CX47f811);
	xaxis grid;
	yaxis grid;
run;

title;
ods graphics / reset;
ods noproctitle;
ods graphics / imagemap=on;

proc corr data=SALES_UNITS_CORR pearson nosimple noprob plots=none;
	var sales;
	with units;
run;

/* -------------------------------------------------------------------------- */
proc import datafile='/home/u63049952/Projects/Future50.csv' out=future_50_orig 
		dbms=csv replace;
	getnames=yes;
run;

proc print data=future_50_orig(obs=10);
run;

proc contents data=future_50_orig;
run;

data future_50;
	set future_50_orig;
	sales_inc_pct=input(compress(yoy_sales, '%'), 8.);
	units_inc_pct=input(compress(yoy_units, '%'), 8.);
	num_of_chains=input(units, 8.);
	city=lowcase(scan(strip(location), 1, ','));
	state=lowcase(scan(strip(location), -1, ','));
run;

proc freq data=future_50 noprint;
	table Franchising / out=franchising_stat nocum nopercent missing;
run;

title1 ls=1.5 "Franchising ?";
pattern1 v=s color=cxFFCCCC;
pattern2 v=s color=cx4DBD33;
ods graphics on;

proc gchart data=franchising_stat;
	pie franchising / type=sum sumvar=percent noheader slice=outside value=inside 
		coutline=gray77 explode='No';
	run;
	ods graphics off;
	ods noproctitle;
	ods graphics / imagemap=on;

proc sort data=FUTURE_50 out=SortTempTableSorted;
	by Franchising;
run;

title "Distribution of Sales with or without Franchasing";

/* Exploring Data */
proc univariate data=Work.SortTempTableSorted;
	ods select Histogram;
	var Sales;
	histogram Sales / normal kernel;
	by Franchising;
run;

title;

proc sort data=future_50;
	by franchising;
run;

data sales_franchise;
	set future_50(keep=sales franchising);
	by franchising;

	/* setting the total sales to 0 for every different value of franchising */
	if first.franchising then
		total_sales=0;
	total_sales+sales;

	/* displaying the sales for yes and no category */
	if last.franchising then
		output;
	drop sales;
	format total_sales dollar11.2;
run;

title "Sales Amount(k) of Franchise Vs Non Franchise";

proc sgplot data=sales_franchise;
	vbar franchising / response=total_sales group=franchising 
		categoryorder=respdesc;
	yaxis grid;
	xaxis label="Franchising?";
	yaxis label="Total Sales(K)";
run;

proc print data=future_50(obs=10);
run;

/* Scatter plots of all the variables */
title "Scatter Plot Matrix";

proc sgscatter data=future_50;
	matrix Sales num_of_chains Unit_Volume sales_inc_pct units_inc_pct / 
		diagonal=(histogram kernel);
run;

/* Calculating the correlation matrix */
proc corr data=future_50 out=corr_matrix;
	var rank Sales num_of_chains Unit_Volume sales_inc_pct units_inc_pct;
run;

proc sort data=future_50 out=restaurant_state;
	by state;
run;

data good_location;
	set restaurant_state;
	by state;

	/* retain  total_sales; */
	if first.state then
		do;
			num_franchise=0;
			total_sales=0;
		end;
	num_franchise+1;
	total_sales+sales;

	if last.state then
		output;
	keep location state num_franchise total_sales;
run;

proc sort data=good_location;
	by descending total_sales num_franchise;
run;

title "Top 10 Location for Opening New Restaurant in terms of Sales";
proc print data=good_location(obs=10);
run;

data map;
	set good_location(obs=10);

	if strip(state)="n.c." then
		do;
			state_name="North Carolina";
			latitude=35.7596;
			longitude=-80.793457;
		end;

	if strip(state)="n.y." then
		do;
			state_name="New York";
			latitude=40.672250312;
			longitude=-73.870176252;
		end;

	if strip(state)="calif." then
		do;
			state_name="California";
			latitude=36.7783;
			longitude=-119.4179;
		end;

	if strip(state)="ohio" then
		do;
			state_name="Ohio";
			latitude=40.4173;
			longitude=-82.9071;
		end;

	if strip(state)="fla." then
		do;
			state_name="Florida";
			latitude=27.7663;
			longitude=-81.6868;
		end;

	if strip(state)="ga." then
		do;
			state_name="Georgia";
			latitude=33.247875;
			longitude=-83.441162;
		end;

	if strip(state)="texas" then
		do;
			state_name="Texas";
			latitude=31.000000;
			longitude=-100.000000;
		end;

	if strip(state)="ore." then
		do;
			state_name="Oregon";
			latitude=44.000000;
			longitude=-120.500000;
		end;

	if strip(state)="neb." then
		do;
			state_name="Nebraska";
			latitude=41.500000;
			longitude=-100.000000;
		end;

	if strip(state)="pa." then
		do;
			state_name="Pennsylvania";
			latitude=41.203323;
			longitude=-77.194527;
		end;
run;

/* display top 10 location for opening new restaurants */
proc sql;
select state_name,num_franchise,total_sales from map;
quit;

ods graphics / reset width=6.4in height=4.8in;
title "Top 10 Location for Opening New Restaurant in terms of Sales";

proc sgmap plotdata=MAP;
	openstreetmap;
	bubble x=longitude y=latitude size=total_sales/;
run;

title;
/* ----------------------------------------------------------------- */

proc import datafile='/home/u63049952/Projects/Independence100.csv' out=independence_orig replace
dbms=csv;
getnames=yes;

proc print data=independence_orig(obs=10);
run;
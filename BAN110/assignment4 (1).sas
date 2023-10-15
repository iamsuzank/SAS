/* path to file */
/* filename database '/home/u63049952/BAN110ZAA/Assignment4/Superstore.xlsx'; */
/*  */
/* importing dataset orders */
/* proc import datafile=database out=orders dbms=xlsx replace; */
/* 	SHEET="Orders"; */
/* 	GETNAMES=YES; */
/*  */
/* 	importing dataset returns */
/* proc import datafile=database out=returns dbms=xlsx replace; */
/* 	SHEET="Returns"; */
/* 	GETNAMES=YES; */
/*  */
/* 	proc print data=returns(obs=10); */
/* 		Get only the records for the orders that have been returned by joining Orders */
/* 		and Returns datasets.  */
/* proc sql; */
/* 	create table combined as select odr.*, rtn.* from orders as odr inner join  */
/* 		returns as rtn on odr.'Order ID'n=rtn.'Order ID'n; */
/* quit; */
/*  */
/* Print only the returned orders from California under Technology category */
/* with Quantity greater than 5. */
/* title "Final Output"; */
/*  */
/* proc sql; */
/* 	select 'Order Date'n, 'Customer Name'n, City, 'Postal Code'n, 'Product Name'n,  */
/* 		sales, quantity from combined where state='California' and  */
/* 		category='Technology' and quantity > 5 order by 'Order Date'n asc; */
/* quit; */

/* ----------------------------------------------------------------- */
/* libname learn '/home/u63049952/BAN110ZAA/Assignment4/Superstore.xlsx'; */

/* importing sheet - order */
proc import datafile='/home/u63049952/BAN110ZAA/Assignment4/Superstore.xlsx'
	out=Orders
	dbms=xlsx
	replace;
	sheet='Orders';
run;

/* importing sheet - returns */
proc import datafile='/home/u63049952/BAN110ZAA/Assignment4/Superstore.xlsx'
	out=Returns
	dbms=xlsx
	replace;
	sheet='Returns';
run;

/* creating a combined dataset */
proc sql;
    Create Table ReturnedOrders as
    Select od.*,rt.*
    from Orders as od inner join Returns as rt
    ON od.'Order ID'n = rt.'Order ID'n;
quit;

/* printing dataset based on the given conditions */
title "-----OUTPUT------";
proc sql;
	Select ro.'Order Date'n, ro.'Customer Name'n, City, ro.'Postal Code'n, ro.'Product Name'n, 
		ro.Sales, ro.Quantity from ReturnedOrders as ro where ro.State='California' and 
		ro.Category='Technology' and ro.Quantity > 5 Order by ro.'Order Date'n ASC;
quit;






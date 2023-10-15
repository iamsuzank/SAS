/* refrencing the excel file */
filename database '/home/u63049952/BAN110ZAA/Assignment 1/Superstore.xlsx';

/* importing Orders sheet */
proc import datafile=database out=Orders dbms=xlsx replace;
	sheet='Orders';
run;

/* importing Returns sheet */
proc import datafile=database out=Returns dbms=xlsx replace;
	sheet='Returns';
run;

/* Copying Orders data */
options validvarname=Any;

data Orders;
	/* renaming the column name having space */
	/* renaming the column */
	attrib 'Order Date'n length=8;

	/* The length of numeric variables is 3-8. */
	rename 'Order Date'n=Order_Date;
	attrib 'Order ID'n length=$20;
	rename 'Order ID'n=Order_ID;
	attrib 'Customer Name'n length=$20;
	rename 'Customer Name'n=Customer_Name;
	attrib 'Postal Code'n length=$7;
	rename 'Postal Code'n=Postal_Code;
	attrib 'Product Name'n length=$50;
	rename 'Product Name'n=Product_Name;
	set Orders;
run;

/*  */
/* proc print data=Orders; */
/* var State City Customer_Name Order_Date Postal_Code Product_Name; */
/* run; */
/* copying Returns data */
data Returns;
	/* renaming order ID as Order_ID */
	attrib 'Order ID'n length=$20;
	rename 'Order ID'n=Order_ID;
	set Returns;
run;

/* sorting before merging */
proc sort data=Orders;
	by Order_ID;
run;

proc sort data=Returns;
	by Order_ID;
run;

/* merging two sheets */
data Orders_Returned;
	merge Orders(IN=inOrders) Returns(IN=inReturned);
	by Order_ID;

	if inOrders=1 and inReturned=1;
run;

/* create a report which only prints the returned orders from
California under Technology category with Quantity greater than 5 */
proc print data=Orders_Returned noobs;
	var Order_Date Customer_Name City Postal_Code Product_Name Sales Quantity;

	/* 	defining the condition */
	where State="California" and Category="Technology" and Quantity > 5;
	title "Final Table";
run;
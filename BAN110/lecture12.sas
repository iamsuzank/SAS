/* 1. Proc SQL is used for running SQL like queries */

proc sql;
	select * from Learn.Health where Height > 65;
quit;

/* 2. We can perform queries on Patient dataset as well to find all the females */

data Patients;
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

proc sql;
	select * from Patients where Gender = 'F';
quit;

/* 3. Find all the female patients who visited after year 2012 */

proc sql;
	select * from Patients where Gender = 'F' and year(VisitDate) > 2012;
quit;

/* 4. The results are by default sent for reporting. However a dataset can be created. */

proc sql;
	Create Table Height65 as
	select * from Learn.Health where Height > 65;
quit;

/* 5. Create a dataset from Patients using proc sql where Patients are only females */

proc sql;
	Create Table Female_Patients as
	select * from Patients where Gender IN ('F');
quit;

/* 6. Data can be joined using Proc SQL from various tables. */

proc sql;
	select Health.Subj, Demographic.Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health, Learn.Demographic;
quit;

/* 7. Names of the same columns can be renamed using as clause */

proc sql;
	select Health.Subj as Health_Subj, Demographic.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health, Learn.Demographic;
quit;

/* 8. Normally when joining we join by a common column with common value called Inner join */

proc sql;
	select Health.Subj as Health_Subj, Demographic.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health, Learn.Demographic
	where Health.Subj = Demographic.Subj;
quit;

/* 9. As statement can be used to provide aliases to the table names */

proc sql;
	select H.Subj as Health_Subj, D.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health as H, Learn.Demographic as D
	where H.Subj = D.Subj;
quit;

/* 10. Another way of inner join is through inner join keyword */

proc sql;
	select H.Subj as Health_Subj, D.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health as H inner join Learn.Demographic as D 
	on H.Subj = D.Subj;
quit;

/* 11. Left joins include everything from left table plus map them to the right ones */

proc sql;
	select H.Subj as Health_Subj, D.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health as H left join Learn.Demographic as D 
	on H.Subj = D.Subj;
quit;

/* 12. right joins include everything from right table plus map them to the left ones */

proc sql;
	select H.Subj as Health_Subj, D.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health as H right join Learn.Demographic as D 
	on H.Subj = D.Subj;
quit;

/* 13. Full join brings in everything from both the tables. */

proc sql;
	select H.Subj as Health_Subj, D.Subj as Demo_Subj,
	Height, Weight, DOB, Gender, Name 
	from Learn.Health as H full join Learn.Demographic as D 
	on H.Subj = D.Subj;
quit;


data orders;
infile datalines dlm='';
length Order_ID 4. Customer_ID 4.  ;
input Order_ID Customer_ID Order_Date mmddyy10.;
format Order_Date mmddyy10.;
datalines;

1 1 01-01-2022
2 2 02-01-2022
3 3 03-01-2022
4 1 04-01-2022
5 2 05-01-2022
;
run;


data Customers;
infile datalines dlm='';
length Customer_ID 3. Customer_Name $ 10. Customer_Email $ 15.;
input Customer_ID Customer_Name Customer_Email;
datalines ;
1 Alice alice@email.com
2 Bob bob@email.com
3 Charlie charlie@email.com
4 David david@email.com
;

run;

proc sort data=orders;
by customer_id;
run;

proc sort data=customers;
by customer_id;
run;


data final;
merge orders(in=a) customers(in=b);
by  customer_id;

if a and b;
run;

proc sql;
create table placed_orders as 
select o.* ,c.*from orders as o right join customers as c
on o.customer_id = c.customer_id where missing(o.order_id) ;
quit;


/* 14. Find Customers that have placed orders */

data orders;
	input order_id customer_id order_date ddmmyy10.;
	Format order_date mmddyy10.;
datalines;
1 1 01-01-2022 
2 2 02-01-2022
3 3 03-01-2022
4 1 04-01-2022
5 2 05-01-2022
;


data customers;
input customer_id customer_name $ customer_email $30.;
datalines;
1 Alice alice@email.com
2 Bob bob@email.com
3 Charlie charlie@email.com
4 David david@email.com
;

proc sql;
  select o.order_id, o.order_date, c.customer_name
  from orders o
  inner join customers c on o.customer_id = c.customer_id;
quit;



/* 15.Find Customers that have not placed orders */

data orders;
	input order_id customer_id order_date ddmmyy10.;
	Format order_date mmddyy10.;
datalines;
1 1 01-01-2022
2 2 02-01-2022
3 3 03-01-2022
4 1 04-01-2022
5 2 05-01-2022
;


data customers;
input customer_id customer_name $ customer_email $30.;
datalines;
1 Alice alice@email.com
2 Bob bob@email.com
3 Charlie charlie@email.com
4 David david@email.com
;

proc sql;
  select c.customer_name
  from orders o
  right join customers c on o.customer_id = c.customer_id 
  where o.order_id is missing;
quit;


/* 16. Finding Invalid Character or Numeric Values using Proc SQL is easy */

proc SQL;
	select Patno, Gender, DX, AE from Patients
	where Gender NOT IN ('F', 'M', ' ') or
	AE NOT IN (0,1);
quit;

/* 17. Where clause can be used for finding outliers */

proc SQL;
	select Patno, HR, SBP, DBP from Patients
	where HR not between 40 and 100 and HR is not missing or
	SBP not between 80 and 200 and SBP is not missing or
	DBP not between 60 and 120 and DBP is not missing;
quit;


/* 18. Finding all the patients that have HR > average */

proc SQL;
	select Patno, HR from Patients having HR > mean(HR);
quit;

/* 19. A having clause is used if range is checked using aggregate functions */
	proc SQL;
		select Patno, SBP from Patients
		having SBP not between mean(SBP) - 2* std(SBP) and
		mean(SBP) + 2* std(SBP) and SBP is not missing;
	quit;

/* 20. Find the count of A grades */

data students;
input student_id course $ grade $;
datalines;
1 Math A
1 English B
1 Science A
2 Literature A
2 Geography C
2 Physics A
3 Calculus B
;

proc sql;
	select count(grade) as A_Count from students where grade = 'A';
quit;


/* proc sql; */
/* select count(student_id) as id_count from students where student_id =1; */
/* quit; */

/* 21. Missing statement can be used for finding out missing values for columns in PROC SQL */

proc SQL;
	select Patno, HR, DX, AE, DBP, SBP from Patients
	where Patno is missing or
	AE is missing or
	HR is missing or
	DX is missing or
	DBP is missing or
	SBP is missing
	;
quit;

/* 22. Find total sales for each product */

data sales;
	input product_id product_name  $ sales_date : mmddyy10. sales_amount;
	format sales_date date9.;
	datalines;
1 ProductA 01-01-2022 100
2 ProductB 01-02-2022 200
3 ProductC 01-03-2022 300
4 ProductA 01-04-2022 400
5 ProductB 01-05-2022 500
6 ProductC 01-06-2022 600
;
run;

proc sql;
	Select product_name, sum(sales_amount) as total from sales
	group by product_name;
quit;

/* 23. Find all the unique patnos from Patient dataset */

proc sql;
	Select distinct(patno) from Patients where patno is not missing;
quit;

/* 24. Count function with having clause and group by can help in finding duplicates */
	proc SQL;
		select Patno, HR, DX, AE, DBP, SBP, Count(Patno) as Count 
		from Patients group by Patno having Count gt 1;
	quit;

/* 25. To show only the duplicate patno without showing their count */

proc sql;
	Select Patno from patients
	group by patno having count(patno) gt 1;
quit;
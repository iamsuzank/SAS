libname mylib '/home/u63049952/BAN110_Project/library/';
/* filename audiodata '/home/u63049952/BAN110_Project/library/Audible_Dataset.xlsx'; */
filename audio '/home/u63049952/BAN110_Project/library/audible_data.xlsx';
/* filename audio1 '/home/u63049952/BAN110_Project/library/new_audible.xlsx'; */
filename book  '/home/u63049952/BAN110_Project/library/Books_Rating_Record.xlsx';

/* importing data from xlsx file */
proc import datafile=book out=mylib.books dbms=xlsx replace;
run;

/* proc print data=mylib.books(obs=100); */
/* run; */



/* importing data from xlsx file */
/* proc import datafile=audio out=mylib.audible dbms=xlsx replace; */
/* run; */


/* importing data from xlsx file */
proc import datafile=audio out=mylib.audible dbms=xlsx replace;
run;

/* proc print data=mylib.audible(obs=10); */
/* run; */

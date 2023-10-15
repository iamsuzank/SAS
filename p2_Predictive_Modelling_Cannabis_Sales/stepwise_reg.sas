

libname lib2 'C:\Users\Richard01\Documents\Richard Documents\richard\SENECA\winter2020\ban240\datasets';

libname lib2 'C:\Users\Richard01\Documents\Richard Documents\richard\SENECA\winter2020\ban240\datasets';
*Run one stepwise to get variable importance and to illustrate its use as a filter.Keep in mind that we run series of multiple regressions
on all variables that are statistically sign.with response from the correlation in order to reduce the variables and to obtain a final model that is
optimal for our prediction.Use 95% statistical threshold as statistical filter. Use forward stepwise and backward stepwise routines(SLS and SLE)
to determine which variables survive;
ods html rs=none;
proc stepwise data=lib2.devass;
model response=
JOINGROUPTENURE
PAYCASHDRAWEROTHR
PC_PAYCASHDRAWEROTHR
TENURE
LTVGROUPDESC1
clubjoindate1
PC_PAYCASHDRAWERMS96
TOT12ERSBASICCOST
TotalERSLTV
PAYBILLADJ
TOTERSBASICCOST
PCPAY12
TotalLTV
PCERSCALL12
PAYCASHDRAWERMS96
TOT6ERSBASICCOST
totalerscount1
PCERSCALL6
PAYSOURCEPHONE
PC_PAYSOURCEMAIL
 PC_PAYBILLADJ         
 Prior3LTV             
 AGE                   
 PCERSBASICCOST12      
 TOT12ERSCALLS         
 PC_PRMMSINSUR         
 birthdate1            
 PC_PAYSOURCEPHONE     
/sls=.05 sle=.05;
run;
ods html close;

*end of stepwise; 




















*run stepwise on final model variables in order to create final model report;  

ods html rs=none;
proc stepwise data=lib2.devass;
model response=
JOINGROUPTENURE     
 PAYCASHDRAWEROTHR 
 TOT12ERSBASICCOST 
 PC_PRMMSINSUR     
 LTVGROUPDESC1     
 PAYBILLADJ  
 PCPAY12     
 totalerscount1    
 AGE/sls=.05 sle=.05;
run;
ods html close; 
*end of final stepwise;


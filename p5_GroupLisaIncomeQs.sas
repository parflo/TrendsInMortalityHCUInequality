/*
-Script calculate moving average, and create rank. Former groupLisaIncomeQs280322

In:
	-lisa_n_fodelse_4Q
	
Out:
	-lisa_4Qr2
	


*sourcepath = X, Y, Z...;
*/

libname sos 	'T:\sourcepath'; 
libname scb 	'T:\sourcepath'; 
libname lisa 	'T:\sourcepath'; 
libname dest 	'T:\sourcepath'; 


data lisa_4Q_inc; set   dest.lisa_n_fodelse_4Q; * lisa_4Q_inc2print from "prepLisaDemo.sas;
run;




*lista variabler; 
proc contents data= lisa_4Q_inc;
run;

proc sort data = lisa_4Q_inc; 
by LopNr ar; 
run; 

*coppa  lisa_4Q_inc; 
data lisa_4Q; 
    set lisa_4Q_inc;
run;

* remove non taxers ; 
data lisa_4Q;
  set lisa_4Q;
  if DispInkFam > 0;
run;  




* shifting ; 
data lisa_4Q (drop=i count) ;*(drop=i count);
  set lisa_4Q;

  by LopNr;

  array x(*) DispInkFamLag1-DispInkFamLag5;
  DispInkFamLag1=lag1(DispInkFam);
  DispInkFamLag2=lag2(DispInkFam);
  DispInkFamLag3=lag3(DispInkFam);
  DispInkFamLag4=lag4(DispInkFam);
  DispInkFamLag5=lag5(DispInkFam);
 
  if first.LopNr then count=1;

  do i=count to dim(x);
    x(i)=.;
  end;
  count + 1;
run;



*rolling average; 
data lisa_4Q (drop= DispInkFamLag1 DispInkFamLag2 DispInkFamLag3 DispInkFamLag4 DispInkFamLag5);*(drop=i count);
  set lisa_4Q;
DispInkFamLag5_1 = mean(DispInkFamLag1,DispInkFamLag2,DispInkFamLag3,DispInkFamLag4,DispInkFamLag5);
run;


* remove missing values;
data lisa_4Q;
  set lisa_4Q;
if DispInkFamLag5_1 = . then delete;
run;


*rank DispInkFamLag5_1, by birthyear, sex, ar;
proc sort data = lisa_4Q; 
by  ar Kon FoddAr; 
run; 

proc rank data=lisa_4Q out=lisa_4Qr2 ties=low groups=5;
   by ar Kon FoddAr;
   var DispInkFamLag5_1 ;
   ranks DispInkFamLag5_1_r ;
run;

proc sql;
create table myTable as
    select DispInkFamLag5_1_r,
        count(*) as N
    from lisa_4Qr2
    group by DispInkFamLag5_1_r;
quit;


proc means data=lisa_4Qr2 n mean max min range std fw=8;
 var DispInkFamLag5_1_r;
 run; 



proc freq data = lisa_4Qr2;
tables DispInkFamLag5_1_r;
run;

*rolling average; *[edit, change lisa_4Q1000r2 to better name in future];
data dest.lisa_4Qr2 (drop= DispInkFam FoddAr Kon );
  set lisa_4Qr2;
run;

proc means data=lisa_4Qr2 nway mean;
   class DispInkFamLag5_1_r ar Kon;
   var DispInkFamLag5_1;
run;



///////////////////////








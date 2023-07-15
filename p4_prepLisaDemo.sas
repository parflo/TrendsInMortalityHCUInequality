


/*script for comparing data in register, looking at only certain ages and certain diagnoses
In:
	-agardh_lev_lisa_&ar
	-agardh_lev_fodelseuppg
Out: 
	-lisa_n_fodelse_4Q

*sourcepath = X, Y, Z...;
*/

	
libname scb		'T:\sourcepath'; 
libname lisa	'T:\sourcepath'; 
libname dest	'T:\sourcepath'; 




*\\\\\\\\\\\\\\\ Preppa LISA \\\\\\\\\\\\\\\;


%Macro trim_n_name_lisa_90_03;
	%do ar= 1990 %to 2003;
		data lisa_4Q_&ar; set lisa.agardh_lev_lisa_&ar;
			ar =&ar;
			keep LopNr DispInkFam ar;
			/*(if ar > 2004 then keep LopNr Sun2000niva DispInk04; funkadde inte;
			*if ar > 2004 then rename DispInk = DispInk04 ; */
		run; 
	
	%end;
%Mend;

%trim_n_name_lisa_90_03;




%Macro trim_n_name_lisa_04_19;
	%do ar= 2004 %to 2019;
		data lisa_4Q_&ar; set lisa.agardh_lev_lisa_&ar;
			ar =&ar;
			keep LopNr DispInkFam04 ar;
			rename DispInkFam04 = DispInkFam;
		run; 	
	%end;
%Mend;

%trim_n_name_lisa_04_19;






data dest.lisa_4Q_inc; 
set   lisa_4Q_1990
lisa_4Q_1991
lisa_4Q_1992
lisa_4Q_1993
lisa_4Q_1994
lisa_4Q_1995
lisa_4Q_1996
lisa_4Q_1997
lisa_4Q_1998
lisa_4Q_1999
lisa_4Q_2000
lisa_4Q_2001
lisa_4Q_2002
lisa_4Q_2003
lisa_4Q_2004
lisa_4Q_2005
lisa_4Q_2006
lisa_4Q_2007
lisa_4Q_2008
lisa_4Q_2009
lisa_4Q_2010
lisa_4Q_2011
lisa_4Q_2012
lisa_4Q_2013
lisa_4Q_2014
lisa_4Q_2015
lisa_4Q_2016
lisa_4Q_2017
lisa_4Q_2018
lisa_4Q_2019;
run; 


data fodelse; set   scb.agardh_lev_fodelseuppg; 
	keep LopNr SenPNr Indexpop Kon FoddAr;
	if SenPNr = 1 and Indexpop =1 then output fodelse; 
run;


proc sort data = fodelse; 
	by LopNr; 
run;  

data lisa_4Q_inc; set   dest.lisa_4Q_inc; run; 
proc sort data =  lisa_4Q_inc; 
	by LopNr; 
run;  


data lisa_n_fodelse_4Q; 
	merge lisa_4Q_inc(in=lis) fodelse (in=fod) ;
 		by LopNr;
	if lis =1 and fod =1; 
	drop Indexpop SenPNr;
run; 

data dest.lisa_n_fodelse_4Q; set   lisa_n_fodelse_4Q; run;


*^//////// END PREPPA LISA /////

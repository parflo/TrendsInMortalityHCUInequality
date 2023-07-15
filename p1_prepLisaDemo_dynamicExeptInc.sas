/*
Script for extracting LopNr * year -specific demographics,
In: 
	- agardh_lev_fodelseuppg
	- agardh_lev_lisa_&ar
	- agardh_lev_deso&year
Out: 
	-lisa_dynDemog

*/
*sourcepath =...;
libname sos 	'T:\sourcepath';
libname scb 	'T:\sourcepath';
libname lisa 	'T:\sourcepath';
libname dest 	'T:\sourcepath';
libname destOld 'T:\sourcepath'; 
libname desoso 	'T:\sourcepath'; 



data fodelse; set   scb.agardh_lev_fodelseuppg; 
	keep LopNr SenPNr Indexpop Kon FoddAr;
	if SenPNr = 1 and Indexpop =1 then output fodelse; 
run;

proc sort data = fodelse; 
	by LopNr; 
run;  



%Macro trim_dynDemog_90_19;
	%do ar= 1990 %to 2018;
		data lisa_dynDemog_&ar; set lisa.agardh_lev_lisa_&ar;
			ar =&ar;
			keep LopNr ar Lan civil Sun2000niva;
			/*(if ar > 2004 then keep LopNr Sun2000niva DispInk04; funkadde inte;
			*if ar > 2004 then rename DispInk = DispInk04 ; */
		run; 
	%end;
%Mend;


%trim_dynDemog_90_19;
data lisa_dynDemog_2019; set lisa.agardh_lev_lisa_2019;
	rename Sun2020niva=Sun2000niva;
run; 


dm log "clear";
dm output "clear";


data lisa_dynDemog ; set destOld.lisa_dynDemog; run; 
proc sort data = lisa_dynDemog; 
	by LopNr; 
run;  


%Macro koppla_deso;
	%do year= 1995 %to 2019;  *only exist for 95->
		* först sortera by år; 
		*load desodata; 

		data agardh_lev_deso&year.; set desoso.agardh_lev_deso&year.;
			Desoletter =  substr(DeSO, 5, 1);
			keep LopNr Desoletter;
		run;

		proc sort data = agardh_lev_deso&year.; 
			by LopNr; 
		run;  

		*bryt upp lisa_dynDemog i år igen; 
		data lisa_dynDemog_&year. ; set lisa_dynDemog; 	
			if ar = &year. ;
		run; 

		*gör ny lisa_dynDemog_&year.; 
		data  lisa_dynDemog_&year.;
			merge lisa_dynDemog_&year. (in = inlisa) agardh_lev_deso&year. (in = indeso);
			by LopNr;
			if inlisa =1; 
			keep LopNr ar Lan civil Sun2000niva Desoletter;
		run; 
	%end;
%Mend;

%koppla_deso;



%Macro bryt_upp_lisa_preDeso;
	%do year= 1990 %to 1995 ; 
		data lisa_dynDemog_&year. ; set lisa_dynDemog; 	
			if ar = &year. ;
			Desoletter = "";
		run; 
	%end;
%Mend;
%bryt_upp_lisa_preDeso;


data dest.lisa_dynDemog; 
set   lisa_dynDemog_1990
lisa_dynDemog_1991
lisa_dynDemog_1992
lisa_dynDemog_1993
lisa_dynDemog_1994
lisa_dynDemog_1995
lisa_dynDemog_1996
lisa_dynDemog_1997
lisa_dynDemog_1998
lisa_dynDemog_1999
lisa_dynDemog_2000
lisa_dynDemog_2001
lisa_dynDemog_2002
lisa_dynDemog_2003
lisa_dynDemog_2004
lisa_dynDemog_2005
lisa_dynDemog_2006
lisa_dynDemog_2007
lisa_dynDemog_2008
lisa_dynDemog_2009
lisa_dynDemog_2010
lisa_dynDemog_2011
lisa_dynDemog_2012
lisa_dynDemog_2013
lisa_dynDemog_2014
lisa_dynDemog_2015
lisa_dynDemog_2016
lisa_dynDemog_2017
lisa_dynDemog_2018
lisa_dynDemog_2019;
run; 

data lisa_dynDemog2; 
set   dest.lisa_dynDemog; run; 







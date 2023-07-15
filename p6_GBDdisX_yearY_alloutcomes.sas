/* create GBDdis_X_yearY (GBDdisX_yearY_alloutcomes) file, for
In:
	-Pc_gbd[dixX]
	-So_gbd[dixX]
	-Si_gbd[dixX]
	-Cod_gbd[dixX]
	-lisa_4Qr2
	-lisa_dyndemog
	-staticdemog
Out:
	-GBDdis_[disX]_[yearY]



*sourcepath = X, Y, Z...;
*/



libname sos      'T:\sourcepath'; 
libname dest     'T:\sourcepath';  
libname pcDest   'T:\sourcepath'; 
libname nprDest  'T:\sourcepath';  
libname codDest  'T:\sourcepath'; 
libname dest_out 'T:\sourcepath';  


* prep for moving PC_GBDX files; 
%let dis_nr1=8; *neoplasm;
%let dis_nr2=9; *CVD;
%let dis_nr3=10; *chronic resp dis;
%let dis_nr4=12; *neuro;
%let dis_nr6=15; *diabetes§1	;
%let dis_nr7=100; *all;


* sort everything by LopNr; 
%Macro sort_pc_by_lopnr;
 	%do I=1 %to 8;
		proc sort data =  pcDest.Pc_gbd&&dis_nr&I.; 
			by LopNr; 
		run;   	
	%end;
%mend;
%sort_pc_by_lopnr;

%Macro sort_is_by_lopnr;
 	%do I=1 %to 8;
		proc sort data =  nprDest.si_gbd&&dis_nr&I.; 
			by LopNr; 
		run;   	
	%end;
%mend;
%sort_is_by_lopnr;


%Macro sort_os_by_lopnr;
 	%do I=1 %to 8;
		proc sort data =  nprDest.so_gbd&&dis_nr&I. ; 
			by LopNr; 
		run;   	
	%end;
%mend;
%sort_os_by_lopnr;

%Macro sort_cod_by_lopnr;
 	%do I=1 %to 8;
		proc sort data =  codDest.cod_gbd&&dis_nr&I.  ; 
			by LopNr; 
		run;   	
	%end;
%mend;
%sort_cod_by_lopnr;


* Merge to GBDdisX_yearY files; 


/*// vvvvvvv efter helge, lägg till demografi (konstant, dynamisk), merge med GBDdis_&&dis_nr&I.._&year. ... vvvvvvv;*/

* Load demog data
* income Q;  
data lisa_4q1000r2; set dest.lisa_4Qr2 ; *don't mind change the original strange name "lisa_4q1000r2" ; 
run;
/*data lisa_4q1000r2; set dest.lisa_4q1000r2;
run;*/
proc sort data =  lisa_4q1000r2 NODUPKEY ; 
by LopNr ar; 
run;
* lisa_dyndemog; 
data lisa_dyndemog; set dest.lisa_dyndemog;
run;
proc sort data =  lisa_dyndemog NODUPKEY ; 
by LopNr ar; 
run;
* lisa_static; 
data staticdemog; set dest.staticdemog;
run;
proc sort data =  staticdemog (drop = SenPNr Indexpop FodelselandGrp) NODUPKEY; 
by LopNr; 
run;


%Macro megrgeDisSpecificOutcomesByYear;
 	%do I=1 %to 8;
		%do year= 2000 %to 2019; /* orginially "%do year= 1990 %to 2019;" But since all prior to 2000 unaffected by lacking income 2003 in original run, and I'll likely only look at 2000-> due to ICD9 before, I'll run from here /Pär, 28 03 2022  */

		*begin extract year for each file; 
		data PC_GBDdis_&&dis_nr&I.._&year. ; set pcDest.Pc_gbd&&dis_nr&I.. (keep= LopNr ar PC_u PC_e);
			if ar = &year. ;* then output  PC_GBDdis_&&dis_nr&I.._&year. ;
		run;
		data SI_GBDdis_&&dis_nr&I.._&year. ; set nprDest.si_gbd&&dis_nr&I.. (keep= LopNr ar SI_u SI_e);
			if ar = &year.;
		run;
		data SO_GBDdis_&&dis_nr&I.._&year. ; set nprDest.so_gbd&&dis_nr&I.. (keep= LopNr ar SO_u SO_e);
			if ar = &year.;
		run;
		data CoD_GBDdis_&&dis_nr&I.._&year. ; set codDest.cod_gbd&&dis_nr&I.. (keep= LopNr ar Death);
			if ar = &year. +1; *ar = &year. +1; * we only have SES and demo data on year prior to death ;
			ar = &year.;
		run;

		*select correct demogr; 
		data Q_&year. ; set lisa_4q1000r2;
			if ar = &year. ;
			drop ar;  *DispInkFamLag5_1; 
		run;
		data lisa_dyndemog_&year. ; set lisa_dyndemog;
			if ar = &year. ;
		run;


		
		*merging part; 
		data dest_out.GBDdis_&&dis_nr&I.._&year. ; merge staticdemog (in = lisastat) lisa_dyndemog_&year. (in = lisdyn)  Q_&year. PC_GBDdis_&&dis_nr&I.._&year. SO_GBDdis_&&dis_nr&I.._&year.  SI_GBDdis_&&dis_nr&I.._&year.  CoD_GBDdis_&&dis_nr&I.._&year. ; *CoD_GBDdis_&&dis_nr&I.._&year1. (this change &year. instead of &year1.) done 1/11-2022;
			by LopNr;
			if lisdyn =1 and lisastat = 1; * only subjects with complete demographics (dynamic and static); 
		run;
		%end;
	%end;
%mend;

%megrgeDisSpecificOutcomesByYear;






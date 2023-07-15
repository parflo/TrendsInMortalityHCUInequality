/*  
Script for preparing SO_GBDX /SI_GBDX, the SO and SI data used for target file GBDdisX_yearY files, i.e disease specific, year specific care consumtion, eventeually containing variables: 

In:
	-t_t_r_par_sv_39035_2019
	-t_t_r_par_ov_39035_2019
	-lisa_dynDemog
	-agardh_lev_fodelseuppg
Out: 
	-SO_GBD[x]
	-SI_GBD[x]


*sourcepath = X, Y, Z...;
*/

libname sos 		'T:\sourcepath'; 
libname dest 		'T:\sourcepath'; 
libname sbdddest 	'T:\sourcepath'; 



*load HCU, ; 
data npr_svT; set sos.t_t_r_par_sv_39035_2019; 
	keep LopNr hdia AR; * INDAioner_3216_2019;
	rename hdia=dia1; *eller hdia1;
	rename AR = ar;
run; 
 

data npr_ovT; set sos.t_t_r_par_ov_39035_2019;
	keep LopNr hdia AR;
	rename hdia=dia1 ;
	rename AR = ar;
run;




* sort; 
proc sort data = npr_svT;
	by LopNr ar dia1; 
run; 

proc sort data = npr_ovT;
	by LopNr ar dia1; 
run;


*(remove all ev labels);
proc datasets  memtype=data;
   modify npr_svT;
     attrib _all_ label=' ';
     attrib _all_ format=;
contents data=npr_svT;
run;

proc datasets  memtype=data;
   modify npr_ovT;
     attrib _all_ label=' ';
     attrib _all_ format=;
contents data=npr_ovT;
run;



*///////// define 6 macros to select ICD codes for and flag disease; 
%macro macro_selec_dis_8;
	%DO i=1 %to 1;
		*B.1 N Neoplasms;
		if (dia&i  => 'C00' and dia&i <='C07') or
			(dia&i => 'C08' and dia&i <='C190') or
			(dia&i =  'C20') or
			(dia&i => 'C21' and dia&i  <='C218') or
			(dia&i => 'C22' and dia&i  <='C224') or
			(dia&i => 'C227' and dia&i <='C23') or
			(dia&i => 'C24' and dia&i  <='C261') or
			(dia&i => 'C268' and dia&i <='C269') or
			(dia&i => 'C30' and dia&i <='C301') or
			(dia&i => 'C31' and dia&i <='C33') or
			(dia&i => 'C34' and dia&i <='C3492') or
			(dia&i => 'C37' and dia&i <='C370') or
			(dia&i => 'C38' and dia&i <='C399') or
			(dia&i => 'C40' and dia&i <='C414') or
			(dia&i => 'C418' and dia&i <='C419') or
			(dia&i => 'C43' and dia&i <='C452') or
			(dia&i =  'C457') or
			(dia&i =  'C459') or
			(dia&i => 'C47' and dia&i <='C4A') or
			(dia&i => 'C50' and dia&i <='C50629') or
			(dia&i => 'C508' and dia&i <='C52') or
			(dia&i => 'C53' and dia&i <='C543') or
			(dia&i => 'C548' and dia&i <='C562') or
			(dia&i => 'C569' and dia&i <='C580') or
			(dia&i => 'C60' and dia&i <='C642') or 
			(dia&i => 'C649' and dia&i <='C6992') or
			(dia&i => 'C70' and dia&i <='C701') or
			(dia&i => 'C709' and dia&i <='C73') or
			(dia&i => 'C74' and dia&i <='C755') or
			(dia&i => 'C758' and dia&i <='C799') or
			(dia&i => 'C80' and dia&i <='C8149') or
			(dia&i => 'C817' and dia&i <='C8179') or
			(dia&i => 'C819' and dia&i <='C8529') or
			(dia&i => 'C857' and dia&i <='C866') or
			(dia&i => 'C88' and dia&i <='C9032') or
			(dia&i => 'C91' and dia&i <='C937') or
			(dia&i => 'C939' and dia&i <='C952') or
			(dia&i => 'C957' and dia&i <='C979') or
			(dia&i => 'D00' and dia&i <='D249') or
			(dia&i => 'D260' and dia&i <='D399') or
			(dia&i => 'D4' and dia&i <='D499') or
			(dia&i =  'E340') or
			(dia&i => 'K514' and dia&i <='K51419') or
			(dia&i => 'K620' and dia&i <='K623') or
			(dia&i =  'K635') or 
			(dia&i => 'N60' and dia&i <='N6099') or 
			(dia&i => 'N840' and dia&i <='N841') or 
			(dia&i => 'N87' and dia&i <='N879') or
			(dia&i =  'Z031') or
			(dia&i => 'Z08' and dia&i <='Z099') or
			(dia&i => 'Z12' and dia&i <='Z129') or 
			(dia&i => 'Z80' and dia&i <='Z809') or 
			(dia&i => 'Z85' and dia&i <='Z859') or 
			(dia&i => 'Z860' and dia&i <='Z8603')
		then DisIsHere = 1;
	%END;
%mend;


%macro macro_selec_dis_9;
	%DO i=1 %to 1;
	*B.2 CD Cardiovascular diseases; 
	if (dia&i => 'B332' and dia&i  <='B3324') or
	  (dia&i =  'D8685') or 
	  (dia&i => 'G45' and dia&i  <='G468') or
	  (dia&i => 'I01' and dia&i  <='I019') or
	  (dia&i =  'I020') or
	  (dia&i => 'I05' and dia&i  <='I099') or
	  (dia&i => 'I11' and dia&i  <='I112') or
	  (dia&i =  'I119') or 
	  (dia&i => 'I20' and dia&i  <='I216') or
	  (dia&i => 'I219' and dia&i  <='I270') or
	  (dia&i => 'I272' and dia&i  <='I289') or
	  (dia&i => 'I30' and dia&i  <='I380') or
	  (dia&i => 'I39' and dia&i  <='I418') or
	  (dia&i => 'I42' and dia&i  <='I438') or
	  (dia&i => 'I44' and dia&i  <='I448') or
	  (dia&i => 'I45' and dia&i  <='I528') or
	  (dia&i => 'I60' and dia&i  <='I64') or
	  (dia&i =  'I641') or 
	  (dia&i => 'I65' and dia&i  <='I8393') or
	  (dia&i => 'I86' and dia&i  <='I890') or
	  (dia&i =  'I899') or 
	  (dia&i => 'I950' and dia&i  <='I951') or
	  (dia&i =  'I98') or 
	  (dia&i => 'I988' and dia&i  <='I999') or
	  (dia&i =  'K751') or 
	  (dia&i => 'R00' and dia&i  <='R012') or
	  (dia&i => 'Z013' and dia&i  <='Z0131') or
	  (dia&i => 'Z034' and dia&i  <='Z035') or
	  (dia&i =  'Z136') or 
	  (dia&i =  'Z527') or
	  (dia&i => 'Z823' and dia&i  <='Z8249') or
	  (dia&i => 'Z867' and dia&i  <='Z8679') or
	  (dia&i => 'Z941' and dia&i  <='Z943') or
	  (dia&i => 'Z95' and dia&i  <='Z959') 
	then DisIsHere = 1;
	%END;
%mend;


%macro macro_selec_dis_10;
	%DO i=1 %to 1;
	*B.3 CRD Chronic respiratory diseases; 
	if (dia&i => 'D86' and dia&i  <='D862') or
	  (dia&i = 'D869') or 
	  (dia&i => 'G473' and dia&i <'G4739') or
	  (dia&i => 'J30' and dia&i <= 'J359') or
	  (dia&i => 'J37' and dia&i <= 'J399') or
	  (dia&i => 'J41' and dia&i <= 'J424') or
	  (dia&i => 'J43' and dia&i <= 'J46') or
	  (dia&i => 'J47' and dia&i <= 'J479') or
	  (dia&i => 'J60' and dia&i <= 'J689') or
	  (dia&i => 'J708' and dia&i <= 'J709') or
	  (dia&i => 'J80' and dia&i <= 'J809') or
	  (dia&i = 'J82') or 
	  (dia&i => 'J84' and dia&i <= 'J849') or
	  (dia&i => 'J90' and dia&i <= 'J900') or
	  (dia&i = 'J91') or 
	  (dia&i => 'J918' and dia&i <= 'J9312') or
	  (dia&i => 'J938' and dia&i <= 'J949') or
	  (dia&i => 'J96' and dia&i <= 'J9692') or
	  (dia&i => 'J98' and dia&i <= 'J998') or
	  (dia&i => 'R050' and dia&i <= 'R069') or
	  (dia&i => 'R09' and dia&i <= 'R0989') or
	  (dia&i => 'R84' and dia&i <= 'R849') or
	  (dia&i => 'R91' and dia&i <= 'R918') or
	  (dia&i = 'Z825')
	then DisIsHere = 1;
	%END;
%mend;


%macro macro_selec_dis_12;
	%DO i=1 %to 1;
	*B.5 ND Neurological disorders;
	if (dia&i => 'F00' and dia&i <='F020') or
		(dia&i => 'F022' and dia&i <='F023') or
		(dia&i => 'F028' and dia&i <='F0391') or
		(dia&i = 'F062') or 
		(dia&i => 'G10' and dia&i <='G100') or
		(dia&i => 'G11' and dia&i <='G138') or
		(dia&i => 'G20' and dia&i <='G21') or
		(dia&i => 'G212' and dia&i <='G24') or 
		(dia&i => 'G241' and dia&i <='G250') or 
		(dia&i => 'G252' and dia&i <='G253') or 
		(dia&i = 'G255') or
		(dia&i => 'G258' and dia&i <='G260') or
		(dia&i => 'G30' and dia&i <='G311') or 
		(dia&i => 'G318' and dia&i <='G3289') or 
		(dia&i => 'G35' and dia&i <='G350') or 
		(dia&i => 'G36' and dia&i <='G379') or 
		(dia&i => 'G40' and dia&i <='G419') or 
		(dia&i => 'G43' and dia&i <='G4489') or 
		(dia&i => 'G50' and dia&i <='G541') or
		(dia&i => 'G545' and dia&i <='G62') or 
		(dia&i => 'G622' and dia&i <='G652') or
		(dia&i => 'G70' and dia&i <='G7119') or
		(dia&i => 'G713' and dia&i <='G72') or
		(dia&i => 'G721' and dia&i <='G737') or
		(dia&i => 'G80' and dia&i <='G839') or
		(dia&i => 'G89' and dia&i <='G936') or
		(dia&i => 'G938' and dia&i <='G9529') or 
		(dia&i => 'G958' and dia&i <='G96') or
		(dia&i = 'G961') or
		(dia&i => 'G9612' and dia&i <='G969') or
		(dia&i => 'G98' and dia&i <='G998') or
		(dia&i => 'M33' and dia&i <='M3399') or
		(dia&i => 'M60' and dia&i <='M6019') or
		(dia&i => 'M608' and dia&i <='M609') or
		(dia&i = 'M797') or
		(dia&i => 'R25' and dia&i <='R279') or
		(dia&i => 'R29' and dia&i <='R2991') or
		(dia&i => 'R41' and dia&i <='R420') or 
		(dia&i => 'R56' and dia&i <='R569') or 
		(dia&i => 'R90' and dia&i <='R9089') or
		(dia&i = 'Z033') or
		(dia&i = 'Z1385') or
		(dia&i = 'Z13858') or
		(dia&i = 'Z820') or 
		(dia&i => 'Z866' and dia&i <='Z8669')
		then DisIsHere = 1;
	%END;
%mend;


%macro macro_selec_dis_15;
	%DO i=1 %to 1;
	*B.8 DKD Diabetes and kidney diseases;
 	if (dia&i = 'D631') or
      (dia&i => 'E08' and dia&i  <='E089') or
      (dia&i => 'E10' and dia&i  <='E149') or
      (dia&i => 'I12' and dia&i  <='I139') or
      (dia&i => 'N00' and dia&i  <='N088') or
      (dia&i = 'N150') or
      (dia&i => 'N17' and dia&i  <='N19') or
      (dia&i => 'Q60' and dia&i  <='Q632') or
      (dia&i => 'Q638' and dia&i  <='Q639') or
      (dia&i => 'Q642' and dia&i  <='Q649') or
      (dia&i => 'R73' and dia&i  <='R739') or
      (dia&i = 'Z131') or
      (dia&i => 'Z49' and dia&i  <='Z4932') or
      (dia&i = 'Z524') or
      (dia&i = 'Z833') or
      (dia&i = 'Z992')
	then DisIsHere = 1;
	%END;
%mend;



%macro macro_selec_dis_100;
	* Any healch care encounter;
	%DO i=1 %to 1; *5; * kolla igenom 5 första diagnoserna 21; *look only at hdia1;
		if (dia&i => '-') 
		then DisIsHere = 1;
	%END;
%mend;


*/////// end 6 macros selecting ICDs; 

* ; 
%let dis_nr1=8; *neoplasm;
%let dis_nr2=9; *CVD;
%let dis_nr3=10; *chronic resp dis;
%let dis_nr4=12; *neuro;
%let dis_nr6=15; *diabetes§1	;
%let dis_nr7=100; *all;



%let in_data_set = npr_svT; *npr_svT;
%Macro SelectNCreateDisFilesIS; *DoDisFileUnikEnc;  *(Edu- det går att ha flera data/proc steg (dvs fler 'run') i samma mackro; 
	%do I=1 %to 7;
		%let dis = &&dis_nr1&I.;
		data SI_GBD&dis. ; set &in_data_set.; *npr_svT;
			%macro_selec_dis_&dis.;
			if DisIsHere = 1 then output SI_GBD&dis.;
		run;

		*prep for unik individ; 
		proc sort data = SI_GBD&dis.; 
			by LopNr  ar; 
		run; 

		*unika individer, SI_u; 
		data SI_GBD&dis.; set SI_GBD&dis.;
			by LopNr ar ; *dvs markera unika kombinationer av id*år*(diagnos);
			if first.ar=1  then SI_u = 1;
			else  SI_u = "";
		run; 

		*encounters, SI_e; 
		proc sql;
			create table SI_GBD&dis. as
		    select  *, sum(DisIsHere) as SI_e
		    from SI_GBD&dis.
		    group by LopNr, ar;
		quit;
		
		* Make sure only 1 obseravation per person and year; 
		data SI_GBD&dis. ;set  SI_GBD&dis. ( drop= DisIsHere); 
			if SI_u = 1 then output SI_GBD&dis.;
		run;
	%end;
%mend;

*MAIN macro: createDisFiles by run macro; 
%SelectNCreateDisFilesIS; 



%let in_data_set = npr_ovT; *npr_svT;
%Macro SelectNCreateDisFilesOS; *DoDisFileUnikEnc;  *(Edu- det går att ha flera data/proc steg (dvs fler 'run') i samma mackro; 
	%do I=1 %to 7;
		%let dis = &&dis_nr1&I.;
		data SO_GBD&dis. ; set &in_data_set.; *npr_svT;
			%macro_selec_dis_&dis.;
			if DisIsHere = 1 then output SO_GBD&dis.;
		run;

		*prep for unik individ; 
		proc sort data = SO_GBD&dis.; 
			by LopNr  ar; 
		run; 

		*unika individer, SO_u; 
		data SO_GBD&dis.; set SO_GBD&dis.;
			by LopNr ar ; *dvs markera unika kombinationer av id*år*(diagnos);
			if first.ar=1  then SO_u = 1;
			else  SO_u = "";
		run; 

		*encounters, SO_e; 
		proc sql;
			create table SO_GBD&dis. as
		    select  *, sum(DisIsHere) as SO_e
		    from SO_GBD&dis.
		    group by LopNr, ar;
		quit;
		
		* Make sure only 1 obseravation per person and year; 
		data SO_GBD&dis. ;set  SO_GBD&dis. ( drop= DisIsHere); 
			if SO_u = 1 then output SO_GBD&dis.;
		run;
	%end;
%mend;

*MAIN macro: createDisFiles by run macro; 
%SelectNCreateDisFilesOS;





%Macro sendtodest;
 	%do I=1 %to 7;
	data sbdddest.SO_GBD&&dis_nr&I. ; set SO_GBD&&dis_nr&I; 
	run;
	%end;
%mend;
%sendtodest;

%Macro sendtodest;
 	%do I=1 %to 7;
	data sbdddest.SI_GBD&&dis_nr&I. ; set SI_GBD&&dis_nr&I; 
	run;
	%end;
%mend;
%sendtodest;



















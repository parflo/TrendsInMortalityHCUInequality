/*  

Script for preparing StaticDemo files.

In: 
	- agardh_lev_fodelseuppg

Out: 
	- staticdemog
		-LopNr
		-BirthYear
		-Sex
		-CountryOfOrigin
*/
*sourcepath = X, Y, Z...;
libname sos 	'T:\sourcepath'; 
libname dest 	'T:\sourcepath'; 
libname scb 	'T:\sourcepath'; 

*to get senPNR and indexpop, for merge later on ; 
data fodelse; set   scb.agardh_lev_fodelseuppg; 
	keep LopNr SenPNr Indexpop Kon FoddAr FodelselandGrp;
	if SenPNr = 1 and Indexpop =1 then output fodelse; 
run;





* lista alla värden dia har, och outputta till excel; 
proc freq data=fodelse;
    table FodelselandGrp / nopercent nocum NOPRINT OUT=fodelse2;
run;

*define new variable for födelseland; 
data dest.staticdemog; set   fodelse; 
	if (FodelselandGrp = 'Sverige' ) then FodelseLandG = 1;  *sweden; 
	if  (FodelselandGrp = 'Norden utom Sverige') or 
		(FodelselandGrp = 'EU utom Norden') or
		(FodelselandGrp = 'Europa utom EU och Norden')
		then FodelseLandG = 2; *Europe; 

	if (FodelselandGrp = 'Afrika' ) or 
	(FodelselandGrp =  'Asien') or 
	(FodelselandGrp =  'Nordamerika') or 
	(FodelselandGrp =  'Sovjetunionen') or 
	(FodelselandGrp =  'Oceanien' ) or 
	(FodelselandGrp =  'Okänt' ) or 
	(FodelselandGrp =  'Statslös') or 
	(FodelselandGrp =  'Sydamerika') then FodelseLandG = 3; *non europe;  
	run; 


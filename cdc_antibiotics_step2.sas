
*************************************************************************************************;
* Antibiotics - track route of administration (IV or PO);
*
* NOTE 
*	First run antibiotics_step1.sql to create tables to read into this program;
*
* INPUTS 
*	SQL Tables
* 	[ORD_Iwashyna_201108021D].[temp].[antibiotic1_040716]
*	[ORD_Iwashyna_201108021D].[temp].[antibiotic2_040716]
*	[ORD_Iwashyna_201108021D].[temp].[antibiotic3_040716]
*	SAS Data files
*	cdc.basic (inpatient daily file)
*
* OUTPUTS - sas7bdat
*	files - can be deleted:
*	main.temp_antibiotics1_040716
*	main.temp_antibiotics2_040716
*	main.temp_antibiotics3_040716
*	final file of antibiotics:
*	cdc.antibiotics
*;
*************************************************************************************************;

/* This is the syntax for a Windows SAS session where the OLEDB module is licensed. */
libname  cdw  oledb  provider=sqloledb  datasource="vhacdwrb02.vha.med.va.gov"
 properties=('Initial Catalog'=CDWwork 'Integrated Security'=SSPI)  
 readbuff=5000  cursor_type=static  utilconn_transient=yes   /* <-- these options help with the record download into final SAS table. */
 connection=global    /* <-- this option is the trick to making temporary table persist in remote SQL Server. */
 ;
options nofmterr;
libname main "I:\VA Sepsis\V. Identifiable Data\CDW Data";
libname cdc "I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\data";

%let path=I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\CDC National Sepsis Surveillance Project_VA\CDC_VA_DataPrep\;
%let pass=1;

*************************************************************************************************;
* these are antibiotics found in the bcmadispenseddrug table;
* ;
*************************************************************************************************;

PROC SQL ;
CONNECT TO OLEDB  AS CDW1 ( PROVIDER=SQLOLEDB  DATASOURCE="vhacdwrb02.vha.med.va.gov"
   PROPERTIES=('INITIAL CATALOG'=CDWWORK 'INTEGRATED SECURITY'=SSPI)
   READBUFF=5000  CURSOR_TYPE=STATIC  defer=yes  utilconn_transient=yes
   CONNECTION=GLOBAL ) ; 
create table temp1a as 
  select t1.*
FROM CONNECTION TO CDW1 (
SELECT t1.[localdrugsid]
      ,t1.[drugnamewithoutdose]
	  ,t1.[LocalDrugNameWithDose]
      ,t1.[vaclassification]
      ,t1.[unitdosemedicationroute]
      ,t1.[patientsid]
      ,t1.[actiondatetime]
FROM [ORD_Iwashyna_201108021D].[temp].[antibiotic1_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;
proc freq data=temp1a;
tables unitdosemedicationroute/missing;
run;
data temp1b baddrug1 badroute1 baddate1;
set temp1a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='ACYCLOVIR/HYDROCORTISONE' or drugnamewithoutdose='ALLERGENIC EXTRACT,PENICILLIN' or drugnamewithoutdose='AMOXICILLIN/CLARITHROMYCIN/LANSOPRAZOLE' or 
drugnamewithoutdose='BACITRACIN/HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/POLYMYXIN B' or 
drugnamewithoutdose='BENZOYL PEROXIDE/CLINDAMYCIN' or drugnamewithoutdose='BISMUTH SUBSALICYLATE/METRONIDAZOLE/TETRACYCLINE' or drugnamewithoutdose='BISMUTH/METRONIDAZOLE/TETRACYCLINE' or 
drugnamewithoutdose='CIPROFLOXACIN/DEXAMETHASONE' or drugnamewithoutdose='CIPROFLOXACIN/HYDROCORTISONE' or drugnamewithoutdose='CLINDAMYCIN PHOSPHATE/TRETINOIN' or 
drugnamewithoutdose='COLISTIN/HYDROCORTISONE/NEOMYCIN/THONZONIUM' or drugnamewithoutdose='DEXAMETHASONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='DEXAMETHASONE/TOBRAMYCIN' or 
drugnamewithoutdose='DIPHENHYDRAMINE/HYDROCORTISONE/NYSTATIN/TETRACYCLINE' or drugnamewithoutdose='ERYTHROMYCIN/SULFISOXAZOLE' or drugnamewithoutdose='GENTAMICIN/PREDNISOLONE' or 
drugnamewithoutdose='GRAMICIDIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='LOTEPREDNOL/TOBRAMYCIN' or 
drugnamewithoutdose='NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='NEOMYCIN/POLYMYXIN B/PREDNISOLONE' or drugnamewithoutdose='OXYTETRACYCLINE' or drugnamewithoutdose='OXYTETRACYCLINE/POLYMYXIN B' or 
drugnamewithoutdose='POLYMYXIN B/TRIMETHOPRIM' or drugnamewithoutdose='SILVER SULFADIAZINE' 
then output baddrug1;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EXTERNAL' or 
unitdosemedicationroute='EXTERNALLY' or unitdosemedicationroute='G TUBE' or unitdosemedicationroute='NASAL' or
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or 
unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPHTHALMIC (OINT)' or
unitdosemedicationroute='OPHTHALMIC BOTH' or unitdosemedicationroute='OPHTHALMIC TOPICAL' or
unitdosemedicationroute='OPHTHALMIC TOPICAL (BOTH)' or unitdosemedicationroute='OPTHALMIC' or
unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC OINTMENT' or
unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPHTHALMIC TOPICAL' or
unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZOPTHALMIC' 
then output badroute1;
else if dt2=. then output baddate1;
else output temp1b;
run;
proc freq data=temp1b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "antibiotics - dispensed drug table";
run;
data main.temp_antibiotics1_040716;
set temp1b;
run;
proc datasets lib=work; delete baddrug1 badroute1 baddate1; run;
quit;

*************************************************************************************************;
* these are antibiotics found in the bcmaadditive table;
* ;
*************************************************************************************************;

PROC SQL ;
CONNECT TO OLEDB  AS CDW1 ( PROVIDER=SQLOLEDB  DATASOURCE="vhacdwrb02.vha.med.va.gov"
   PROPERTIES=('INITIAL CATALOG'=CDWWORK 'INTEGRATED SECURITY'=SSPI)
   READBUFF=5000  CURSOR_TYPE=STATIC  defer=yes  utilconn_transient=yes
   CONNECTION=GLOBAL ) ; 
create table temp2a as 
  select t1.*
FROM CONNECTION TO CDW1 (
SELECT t1.[localdrugsid]
      ,t1.[drugnamewithoutdose]
	  ,t1.[LocalDrugNameWithDose]
      ,t1.[vaclassification]
      ,t1.[unitdosemedicationroute]
      ,t1.[IVAdditiveIngredientSID]
      ,t1.[IVAdditiveIngredientPrintName]
      ,t1.[PrimaryDrug]
      ,t1.[PrimaryDrugSID]
      ,t1.[ActionDateTime]
      ,t1.[patientsid]
      ,t1.[actiondatetime]
FROM [ORD_Iwashyna_201108021D].[temp].[antibiotic2_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;

proc freq data=temp2a;
tables unitdosemedicationroute/missing;
run;
data temp2b baddrug2 badroute2 baddate2;
set temp2a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='ACYCLOVIR/HYDROCORTISONE' or drugnamewithoutdose='ALLERGENIC EXTRACT,PENICILLIN' or drugnamewithoutdose='AMOXICILLIN/CLARITHROMYCIN/LANSOPRAZOLE' or 
drugnamewithoutdose='BACITRACIN/HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/POLYMYXIN B' or 
drugnamewithoutdose='BENZOYL PEROXIDE/CLINDAMYCIN' or drugnamewithoutdose='BISMUTH SUBSALICYLATE/METRONIDAZOLE/TETRACYCLINE' or drugnamewithoutdose='BISMUTH/METRONIDAZOLE/TETRACYCLINE' or 
drugnamewithoutdose='CIPROFLOXACIN/DEXAMETHASONE' or drugnamewithoutdose='CIPROFLOXACIN/HYDROCORTISONE' or drugnamewithoutdose='CLINDAMYCIN PHOSPHATE/TRETINOIN' or 
drugnamewithoutdose='COLISTIN/HYDROCORTISONE/NEOMYCIN/THONZONIUM' or drugnamewithoutdose='DEXAMETHASONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='DEXAMETHASONE/TOBRAMYCIN' or 
drugnamewithoutdose='DIPHENHYDRAMINE/HYDROCORTISONE/NYSTATIN/TETRACYCLINE' or drugnamewithoutdose='ERYTHROMYCIN/SULFISOXAZOLE' or drugnamewithoutdose='GENTAMICIN/PREDNISOLONE' or 
drugnamewithoutdose='GRAMICIDIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='LOTEPREDNOL/TOBRAMYCIN' or 
drugnamewithoutdose='NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='NEOMYCIN/POLYMYXIN B/PREDNISOLONE' or drugnamewithoutdose='OXYTETRACYCLINE' or drugnamewithoutdose='OXYTETRACYCLINE/POLYMYXIN B' or 
drugnamewithoutdose='POLYMYXIN B/TRIMETHOPRIM' or drugnamewithoutdose='SILVER SULFADIAZINE' 
then output baddrug2;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EXTERNAL' or 
unitdosemedicationroute='EXTERNALLY' or unitdosemedicationroute='G TUBE' or unitdosemedicationroute='NASAL' or
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or 
unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPHTHALMIC (OINT)' or
unitdosemedicationroute='OPHTHALMIC BOTH' or unitdosemedicationroute='OPHTHALMIC TOPICAL' or
unitdosemedicationroute='OPHTHALMIC TOPICAL (BOTH)' or unitdosemedicationroute='OPTHALMIC' or
unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC OINTMENT' or
unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPHTHALMIC TOPICAL' or
unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZOPTHALMIC' 
then output badroute2;
else if dt2=. then output baddate2;
else output temp2b;
run;
proc freq data=temp2b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "antibiotics - additive table";
run;

data main.temp_antibiotics2_040716;
set temp2b;
run;
proc datasets lib=work; delete baddrug2 badroute2 baddate2; run;
quit;

*************************************************************************************************;
* these are antibiotics found in the bcmasolution table;
* ;
*************************************************************************************************;

PROC SQL ;
CONNECT TO OLEDB  AS CDW1 ( PROVIDER=SQLOLEDB  DATASOURCE="vhacdwrb02.vha.med.va.gov"
   PROPERTIES=('INITIAL CATALOG'=CDWWORK 'INTEGRATED SECURITY'=SSPI)
   READBUFF=5000  CURSOR_TYPE=STATIC  defer=yes  utilconn_transient=yes
   CONNECTION=GLOBAL ) ; 
create table temp3a as 
  select t1.*
FROM CONNECTION TO CDW1 (
SELECT t1.[localdrugsid]
		,t1.[drugnamewithoutdose]
	    ,t1.[LocalDrugNameWithDose]
		,t1.[vaclassification]
		,t1.[unitdosemedicationroute]
		,t1.[IVSolutionIngredientSID]
		,t1.[PrimaryDrug]
		,t1.[PrimaryDrugSID]
		,t1.[ActionDateTime]
		,t1.[bcmamedicationlogsid]
		,t1.[patientsid]
FROM [ORD_Iwashyna_201108021D].[temp].[antibiotic3_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;

proc freq data=temp3a;
tables unitdosemedicationroute/missing;
run;

data temp3b baddrug3 badroute3 baddate3;
set temp3a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='ACYCLOVIR/HYDROCORTISONE' or drugnamewithoutdose='ALLERGENIC EXTRACT,PENICILLIN' or drugnamewithoutdose='AMOXICILLIN/CLARITHROMYCIN/LANSOPRAZOLE' or 
drugnamewithoutdose='BACITRACIN/HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='BACITRACIN/POLYMYXIN B' or 
drugnamewithoutdose='BENZOYL PEROXIDE/CLINDAMYCIN' or drugnamewithoutdose='BISMUTH SUBSALICYLATE/METRONIDAZOLE/TETRACYCLINE' or drugnamewithoutdose='BISMUTH/METRONIDAZOLE/TETRACYCLINE' or 
drugnamewithoutdose='CIPROFLOXACIN/DEXAMETHASONE' or drugnamewithoutdose='CIPROFLOXACIN/HYDROCORTISONE' or drugnamewithoutdose='CLINDAMYCIN PHOSPHATE/TRETINOIN' or 
drugnamewithoutdose='COLISTIN/HYDROCORTISONE/NEOMYCIN/THONZONIUM' or drugnamewithoutdose='DEXAMETHASONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='DEXAMETHASONE/TOBRAMYCIN' or 
drugnamewithoutdose='DIPHENHYDRAMINE/HYDROCORTISONE/NYSTATIN/TETRACYCLINE' or drugnamewithoutdose='ERYTHROMYCIN/SULFISOXAZOLE' or drugnamewithoutdose='GENTAMICIN/PREDNISOLONE' or 
drugnamewithoutdose='GRAMICIDIN/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='HYDROCORTISONE/NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='LOTEPREDNOL/TOBRAMYCIN' or 
drugnamewithoutdose='NEOMYCIN/POLYMYXIN B' or drugnamewithoutdose='NEOMYCIN/POLYMYXIN B/PREDNISOLONE' or drugnamewithoutdose='OXYTETRACYCLINE' or drugnamewithoutdose='OXYTETRACYCLINE/POLYMYXIN B' or 
drugnamewithoutdose='POLYMYXIN B/TRIMETHOPRIM' or drugnamewithoutdose='SILVER SULFADIAZINE' 
then output baddrug3;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EXTERNAL' or 
unitdosemedicationroute='EXTERNALLY' or unitdosemedicationroute='G TUBE' or unitdosemedicationroute='NASAL' or
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or 
unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPHTHALMIC (OINT)' or
unitdosemedicationroute='OPHTHALMIC BOTH' or unitdosemedicationroute='OPHTHALMIC TOPICAL' or
unitdosemedicationroute='OPHTHALMIC TOPICAL (BOTH)' or unitdosemedicationroute='OPTHALMIC' or
unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC OINTMENT' or
unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPHTHALMIC TOPICAL' or
unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZOPTHALMIC' 
then output badroute3;
else if dt2=. then output baddate3;
else output temp3b;
run;
proc freq data=temp3b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "antibiotics - solution table";
run;
data main.temp_antibiotics3_040716;
set temp3b;
run;
proc datasets lib=work; delete baddrug3 badroute3 baddate3; run;
quit;

******************************************************************************************************************;
* Now put together files, do additional cleaning, create route, etc;
******************************************************************************************************************;

data all1 bad;
set main.temp_antibiotics1_040716 (in=a)
	main.temp_antibiotics2_040716 (in=b)
	main.temp_antibiotics3_040716 (in=c);
if a then type=1;
else if b then type=2;
else if c then type=3;

if index(unitdosemedicationroute,"IV")>0 then route=1;
else if index(localdrugnamewithdose,"VI")>0 then route=1;
else if index(unitdosemedicationroute,"INTRAVENOUS")>0 then route=1;
else if index(localdrugnamewithdose,"IV") > 0 then route=1;
else if index(localdrugnamewithdose,"INJ") > 0 then route=1;
else if index(localdrugnamewithdose,"inj") > 0 then route=1;
else if index(localdrugnamewithdose,"premix") > 0 then route=1;
else if index(localdrugnamewithdose,"PREMIX") > 0 then route=1;
else if index(localdrugnamewithdose,"PRE-MIX") > 0 then route=1;
else if index(localdrugnamewithdose,"D5W") > 0 then route=1;
else if index(localdrugnamewithdose,"NSS") > 0 then route=1;
else if index(localdrugnamewithdose,"BAG") > 0 then route=1;
else if index(localdrugnamewithdose,"CPC") > 0 then route=1;
else if index(localdrugnamewithdose,"vial") > 0 then route=1;
else if index(localdrugnamewithdose,"VIAL") > 0 then route=1;
else if index(localdrugnamewithdose,"VL") > 0 then route=1;
else if index(localdrugnamewithdose,"SYRINGE") > 0 then route=1;
else if index(localdrugnamewithdose,"SYR") > 0 then route=1;
else if index(localdrugnamewithdose,"TUBEX") > 0 then route=1;
else if index(localdrugnamewithdose,"PIGYBK") > 0 then route=1;
else if index(localdrugnamewithdose,"PIGGYBACK") > 0 then route=1;
else if index(localdrugnamewithdose,"MINISPIKE") > 0 then route=1;
else if index(localdrugnamewithdose,"PMIX") > 0 then route=1;
else if index(unitdosemedicationroute,"ORAL") then route=2;
else if index(unitdosemedicationroute,"PO") then route=2;
else if index(localdrugnamewithdose,"TAB") > 0 then route=2;
else if index(localdrugnamewithdose,"tab") > 0 then route=2;
else if index(localdrugnamewithdose,"ORAL") > 0 then route=2;
else if index(localdrugnamewithdose,"CAP") > 0 then route=2;
else if index(localdrugnamewithdose,"cap") > 0 then route=2;
else if index(localdrugnamewithdose,"SUSP") > 0 then route=2;
else if index(localdrugnamewithdose,"susp") > 0 then route=2;

if index(localdrugnamewithdose,"OPH SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OINT") > 0 then output bad;
else if index(localdrugnamewithdose,"OPHTHALMIC SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPHTH SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"GEL") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP. SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP.SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP. SOL.") > 0 then output bad;
else if index(localdrugnamewithdose,"TOPICAL SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"TOPICAL SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"TOPICAL SWAB") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP PLEDGET") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP SWAB") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP WIPE") > 0 then output bad;
else if index(localdrugnamewithdose,"SOLN TOP") > 0 then output bad;
else if index(localdrugnamewithdose,"SWAB") > 0 then output bad;
else if index(localdrugnamewithdose,"CREAM") > 0 then output bad;
else if index(localdrugnamewithdose,"cream") > 0 then output bad;
else if index(localdrugnamewithdose,"SOLN,OPH") > 0 then output bad;
else if index(localdrugnamewithdose,"EYE DROP")>0 then output bad;
else if index(localdrugnamewithdose,"EYE SOLN")>0 then output bad;
else if index(localdrugnamewithdose,"LOTION")>0 then output bad;
else if index(localdrugnamewithdose,"CR,TOP")>0 then output bad;
else if index(localdrugnamewithdose,"CR")>0 then output bad;
else if index(localdrugnamewithdose,"CRM,TOP")>0 then output bad;
else if index(localdrugnamewithdose,"CRM")>0 then output bad;
else if index(localdrugnamewithdose,"JELLY")>0 then output bad;
else if index(localdrugnamewithdose,"VAG CR")>0 then output bad;
else if index(localdrugnamewithdose,"VAGINAL CR")>0 then output bad;
else if index(localdrugnamewithdose,"OPHTH SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPTH SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPTH. SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"OPHTH") > 0 then output bad;
else if index(localdrugnamewithdose,"OPTHAL DROPS") > 0 then output bad;
else if index(localdrugnamewithdose,"SOL,OPH") > 0 then output bad;
else if index(localdrugnamewithdose,"EAR SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPH") > 0 then output bad;
else if index(localdrugnamewithdose,"OPH SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"OPH/OTIC SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPHT SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OPHT SOL") > 0 then output bad;
else if index(localdrugnamewithdose,"OTIC SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"otic soln") > 0 then output bad;
else if index(localdrugnamewithdose,"OTIC SOLUTION") > 0 then output bad;
else if index(localdrugnamewithdose,"SOLN,OTIC") > 0 then output bad;
else if index(localdrugnamewithdose,"SOLN F/EYE") > 0 then output bad;
else if index(localdrugnamewithdose,"OPTHAL SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"EYE SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"OTIC") > 0 then output bad;
else if index(localdrugnamewithdose,"otic") > 0 then output bad;
else if index(localdrugnamewithdose,"TOP") > 0 then output bad;
else if index(localdrugnamewithdose,"top") > 0 then output bad;
else if index(localdrugnamewithdose,"opth") > 0 then output bad;
else if index(localdrugnamewithdose,"OPTH") > 0 then output bad;
else if index(localdrugnamewithdose," OS ") > 0 then output bad;
else if index(localdrugnamewithdose," OD ") > 0 then output bad;
else if index(localdrugnamewithdose,"MOUTHWASH") > 0 then output bad;
else if index(localdrugnamewithdose,"WATER IRRG") > 0 then output bad;
else if index(localdrugnamewithdose,"INHALATION") > 0 then output bad;
else if index(localdrugnamewithdose,"INHL SOLN") > 0 then output bad;
else if index(localdrugnamewithdose,"PROSTATE BIOPSY") > 0 then output bad;
else output all1;
run;

data all2;
set all1;
if index(localdrugnamewithdose,"AMIKACIN")>0 and route=. and route=. then route=1;
else if index(localdrugnamewithdose,"AMPHOTERICIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"AMPHOTERCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"Amphotericin")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"AMPICIL")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"AMPICILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"AZITHROMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"AZTREONAM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"aztreonam")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFAZOLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"ceFAZolin")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CASPOFUNGIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFEPIME")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"cefepime")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFOTAXIME")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFOTETAN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFOXITIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFTAROLINE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFTAZIDIME")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFTRIAXONE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CHLORAMPHENICOL")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CILASTATIN/IMIPENEM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CIPROFLOXACIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CLINDAMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CefTRIAXone")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CEFTRIAZONE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"COLISTIMETHATE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"COLISTIMETHATE SOD")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"CO-TRIMOXAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"DAPTOMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"DOXYCYCLINE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"ERTAPENEM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"FLUCONAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"FOSCARNET")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"GENTAMICIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"IMIPENEM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"IMIPEN-CILASTAT")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"IMIPEN-CILISTAT")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"ITRACONAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"LEVOFLOXACIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"LEVOFOXACIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"LINEZOLID")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"METRONIDAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"MEROPENEM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"MICAFUNGIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"MINOCYCLINE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"MOXIFLOXACIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"NAFICILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"NAFCILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"OXACILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"oxacillin")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PENICILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN-G BENZA")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN G BENZA")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN G BENZ")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN-G POTASSIUM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN-G PROCAINE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"pen-g procaine")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN-G SODIUM")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PEN-V POTAS")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPERACILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"piperacillin")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPERACIL/TAZO")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPERACILLIN/TAZO")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPERCILLIN/TAZO")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPERACILL")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PIPRACILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"POLYMIXIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"POLYMYXIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"POLYMYXIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"POSACONAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"PRIMAXIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"QUINUPRISTIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"SMX")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"SMZ")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"STREPTOMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"TICARCILLIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"TOBRAMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"TRIMETH")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"TRIMOXAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"TIMENTIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"VANCOMYCIN")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"VORICONAZOLE")>0 and route=. then route=1;
else if index(localdrugnamewithdose,"ZOSYN")>0 and route=. then route=1;

else if index(localdrugnamewithdose,"BACTRIM")>0 then route=2;
else if index(localdrugnamewithdose,"AMOX")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"AMOXICILLIN")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"CEFIXIME")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"CEFPODOXIME")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"CEFUROXIME")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"CEPHALEXIN")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"DICLOXACILLIN")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"FOSFOMYCIN")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"NITROFURANTOIN")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"SUFLAMETH")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"TETRACYCLINE")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"SULFADIAZINE")>0 and route=. then route=2;
else if index(localdrugnamewithdose,"SULFAMETH")>0 and route=. then route=2;
run;

/*
proc freq data=bad ;
tables localdrugnamewithdose;
title "excluded drugs";
run;
*/

data all3 (keep=patientsid dt2 localdrugnamewithdose primarydrug type route routeflag actiondatetime);
set all2;
if route=. then routeflag=1;
if type=2 or type=3 and route=. then route=1 ;
run;

data all4;
set all3;
length drug $ 40;
drugname=upcase(localdrugnamewithdose);
if index(drugname,'ACYCLOVIR')>0 and route=1 then drug='Acyclovir';
if index(drugname,'AMIKACIN')>0 and route=1 then drug='Amikacin';
if index(drugname,'AMPHOTERICIN B')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPHOTERCIN')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPHO B')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPHOTERECIN')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPHOTERICIN')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPHOTER')>0 and route=1 then drug='Amphotericin B';
if index(drugname,'AMPICILLIN')>0 and route=1 then drug='Ampicillin';
if index(drugname,'AMPICIL')>0 and route=1 then drug='Ampicillin';
if index(drugname,'AMPICIL')>0 and index(drugname,'SULB')>0 and route=1 then drug='Ampicillin/Sulbactam';
if index(drugname,'UNASYN')>0 and route=1 then drug='Ampicillin/Sulbactam';
if index(drugname,'ANIDULAFUNGIN')>0 and route=1 then drug='Anidulafungin';
if index(drugname,'ANIDULOFUNGIN')>0 and route=1 then drug='Anidulafungin';
if index(drugname,'AZITHROMYCIN')>0 and route=1 then drug='Azithromycin';
if index(drugname,'AZTREONAM')>0 and route=1 then drug='Aztreonam';
if index(drugname,'AZTREOMAN')>0 and route=1 then drug='Aztreonam';
if index(drugname,'CASPOFUNGIN')>0 and route=1 then drug='Caspofungin';
if index(drugname,'CASPOFUNJIN')>0 and route=1 then drug='Caspofungin';
if index(drugname,'CEFAMANDOLE')>0 and route=1 then drug='Cefamandole';
if index(drugname,'CEFAZOLIN')>0 and route=1 then drug='Cefazolin';
if index(drugname,'CEFAZOLN')>0 and route=1 then drug='Cefazolin';
if index(drugname,'CEFEPIME')>0 and route=1 then drug='Cefepime';
if index(drugname,'CEFMETAZOLE')>0 and route=1 then drug='Cefmetazole';
if index(drugname,'CEFONICID')>0 and route=1 then drug='Cefonicid';
if index(drugname,'CEFOPERAZONE')>0 and route=1 then drug='Cefoperazone';
if index(drugname,'CEFOTAXIME')>0 and route=1 then drug='Cefotaxime';
if index(drugname,'CEFOTETAN')>0 and route=1 then drug='Cefotetan';
if index(drugname,'CEFOXITIN')>0 and route=1 then drug='Cefoxitin';
if index(drugname,'CEFTAROLINE')>0 and route=1 then drug='Ceftaroline';
if index(drugname,'CEFTAZIDIME')>0 and route=1 then drug='Ceftazidime';
if index(drugname,'CEFTAZIDIME')>0 and index(drugname,'AVIBACTAM')>0 and route=1 then drug='Ceftazidime/Avibactam';
if index(drugname,'CEFTIZOXIME')>0 and route=1 then drug='Ceftizoxime';
if index(drugname,'CEFTOLOZANE/TAZOBACTAM')>0 and route=1 then drug='Ceftolozane/Tazobactam';
if index(drugname,'CEFTOLAZONE/TAZOBACTAM')>0 and route=1 then drug='Ceftolozane/Tazobactam';
if index(drugname,'CEFTOLOZANE')>0 and route=1 then drug='Ceftolozane/Tazobactam';
if index(drugname,'CEFTRIAXONE')>0 and route=1 then drug='Ceftriaxone';
if index(drugname,'CEPHALOTHIN')>0 and route=1 then drug='Cephalothin';
if index(drugname,'CEPHAPIRIN')>0 and route=1 then drug='Cephapirin';
if index(drugname,'CHLORAMPHENICOL')>0 and route=1 then drug='Chloramphenicol';
if index(drugname,'CIDOFOVIR')>0 and route=1 then drug='Cidofovir';
if index(drugname,'CIPROFLOXACIN')>0 and route=1 then drug='Ciprofloxacin';
if index(drugname,'CIPRO')>0 and route=1 then drug='Ciprofloxacin';
if index(drugname,'CLINDAMYCIN')>0 and route=1 then drug='Clindamycin';
if index(drugname,'CLINDAMY')>0 and route=1 then drug='Clindamycin';
if index(drugname,'CLOXACILLIN')>0 and route=1 then drug='Cloxacillin';
if index(drugname,'COLISTIN')>0 and route=1 then drug='Colistin (Colistimethate Sodium)';
if index(drugname,'COLISTIMETHATE')>0 and route=1 then drug='Colistin (Colistimethate Sodium)';
if index(drugname,'DALBAVANCIN')>0 and route=1 then drug='Dalbavancin';
if index(drugname,'DAPTOMYCIN')>0 and route=1 then drug='Daptomycin';
if index(drugname,'DORIPENEM')>0 and route=1 then drug='Doripenem';
if index(drugname,'DOXYCYCLINE')>0 and route=1 then drug='Doxycycline';
if index(drugname,'ERTAPENEM')>0 and route=1 then drug='Ertapenem';
if index(drugname,'FLUCONAZOLE')>0 and route=1 then drug='Fluconazole';
if index(drugname,'FOSCARNET')>0 and route=1 then drug='Foscarnet';
if index(drugname,'GANCICLOVILR')>0 and route=1 then drug='Ganciclovir';
if index(drugname,'GANCYCLOVIR')>0 and route=1 then drug='Ganciclovir';
if index(drugname,'GANCICLOVIR')>0 and route=1 then drug='Ganciclovir';
if index(drugname,'GATIFLOXACIN')>0 and route=1 then drug='Gatifloxacin';
if index(drugname,'GENTAMICIN')>0 and route=1 then drug='Gentamicin';
if index(drugname,'GENTAMYCIN')>0 and route=1 then drug='Gentamicin';
if index(drugname,'IMIPENEM')>0 and route=1 then drug='Imipenem';
if index(drugname,'IMIPENUM')>0 and route=1 then drug='Imipenem';
if index(drugname,'IMIPEN-CIL')>0 and route=1 then drug='Imipenem';
if index(drugname,'ITRACONAZOLE')>0 and route=1 then drug='Itraconazole';
if index(drugname,'KANAMYCIN')>0 and route=1 then drug='Kanamycin';
if index(drugname,'LEVOFLOXACIN')>0 and route=1 then drug='Levofloxacin';
if index(drugname,'LEVOFLOXAC')>0 and route=1 then drug='Levofloxacin';
if index(drugname,'LEVOFOXACIN')>0 and route=1 then drug='Levofloxacin';
if index(drugname,'LINCOMYCIN')>0 and route=1 then drug='Lincomycin';
if index(drugname,'LINEZOLID')>0 and route=1 then drug='Linezolid';
if index(drugname,'MEROPENEM')>0 and route=1 then drug='Meropenem';
if index(drugname,'METHICILLIN')>0 and route=1 then drug='Methicillin';
if index(drugname,'METRONIDAZOLE')>0 and route=1 then drug='Metronidazole';
if index(drugname,'METRONIDAZ')>0 and route=1 then drug='Metronidazole';
if index(drugname,'MEZLOCILLIN')>0 and route=1 then drug='Mezlocillin';
if index(drugname,'MICAFUNGIN')>0 and route=1 then drug='Micafungin';
if index(drugname,'MINOCYCLINE')>0 and route=1 then drug='Minocycline';
if index(drugname,'MOXIFLOXACIN')>0 and route=1 then drug='Moxifloxacin';
if index(drugname,'NAFCILLIN')>0 and route=1 then drug='Nafcillin';
if index(drugname,'ORITAVANCIN')>0 and route=1 then drug='Oritavancin';
if index(drugname,'OXACILLIN')>0 and route=1 then drug='Oxacillin';
if index(drugname,'PENICILLIN')>0 and route=1 then drug='Penicillin';
if index(drugname,'PEN-G')>0 and route=1 then drug='Penicillin';
if index(drugname,'PEN G')>0 and route=1 then drug='Penicillin';
if index(drugname,'PEN-V')>0 and route=1 then drug='Penicillin';
if index(drugname,'PCN-G')>0 and route=1 then drug='Penicillin';
if index(drugname,'PEN')>0 and route=1 then drug='Penicillin';
if index(drugname,'BICILLIN')>0 and route=1 then drug='Penicillin';
if index(drugname,'WYCILLIN')>0 and route=1 then drug='Penicillin';
if index(drugname,'PERAMIVIR')>0 and route=1 then drug='Peramivir';
if index(drugname,'PIPERACILLIN')>0 and route=1 then drug='Piperacillin';
if index(drugname,'PIPERACIL')>0 and route=1 then drug='Piperacillin';
if index(drugname,'PIPERCIL')>0 and route=1 then drug='Piperacillin';
if index(drugname,'PIPERACIL')>0 and index(drugname,'TAZO')>0 and route=1 then drug='Piperacillin/Tazobactam';
if index(drugname,'PIPERAC')>0 and index(drugname,'TAZO')>0 and route=1 then drug='Piperacillin/Tazobactam';
if index(drugname,'ZOSYN')>0 and route=1 then drug='Piperacillin/Tazobactam';
if index(drugname,'POLYMYXIN B')>0 and route=1 then drug='Polymyxin B';
if index(drugname,'POLYMIXIN')>0 and route=1 then drug='Polymyxin B';
if index(drugname,'POLYMYXIN')>0 and route=1 then drug='Polymyxin B';
if index(drugname,'POSACONAZOLE')>0 and route=1 then drug='Posaconazole';
if index(drugname,'PRIMAXIN')>0 and route=1 then drug='Imipenem';
if index(drugname,'QUINUPRISTIN')>0 and route=1 then drug='Quinupristin/Dalfopristin';
if index(drugname,'SYNERCID')>0 and route=1 then drug='Quinupristin/Dalfopristin';
if index(drugname,'DALFOPISTIN')>0 and index(drugname,'QUINUPRIS')>0 and route=1 then drug='Quinupristin/Dalfopristin';
if index(drugname,'DALFOPRIS')>0 and index(drugname,'QUINUPRIS')>0 and route=1 then drug='Quinupristin/Dalfopristin';
if index(drugname,'STREPTOMYCIN')>0 and route=1 then drug='Streptomycin';
if index(drugname,'TEDIZOLID')>0 and route=1 then drug='Tedizolid';
if index(drugname,'TELAVANCIN')>0 and route=1 then drug='Telavancin';
if index(drugname,'TICARCILLIN')>0 and route=1 then drug='Ticarcillin';
if index(drugname,'TICARCILLIN/CLAVULANATE')>0 and route=1 then drug='Ticarcillin/Clavulanate';
if index(drugname,'TICAR')>0 and index(drugname,'CLAV')>0  and route=1 then drug='Ticarcillin/Clavulanate';
if index(drugname,'TIMENTIN')>0 and route=1 then drug='Ticarcillin/Clavulanate';
if index(drugname,'TIGECYCLINE')>0 and route=1 then drug='Tigecycline';
if index(drugname,'TOBRAMYCIN')>0 and route=1 then drug='Tobramycin';
if index(drugname,'TRIMOXAZOLE')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'CO-TRIMOXAZOLE')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'SMX')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'SMZ')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'TRIMETH')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'TRIM')>0 and index(drugname,'SULFA')>0 and route=1 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'VANCOMYCIN')>0 and route=1 then drug='Vancomycin';
if index(drugname,'VAMCOMYCIN')>0 and route=1 then drug='Vancomycin';
if index(drugname,'VANCOMYCN')>0 and route=1 then drug='Vancomycin';
if index(drugname,'VORICONAZOLE')>0 and route=1 then drug='Voriconazole';

if index(drugname,'AMOXICILLIN')>0 and route=2 then drug='Amoxicillin';
if index(drugname,'AMOX')>0 and route=2 then drug='Amoxicillin';
if index(drugname,'AMOX')>0 and index(drugname,'CLAV')>0 and route=2 then drug='Amoxicillin/Clavulanate';
if index(drugname,'AUGMENTIN')>0 and route=2 then drug='Amoxicillin/Clavulanate';
if index(drugname,'AMPICILLIN')>0 and route=2 then drug='Ampicillin';
if index(drugname,'AZITHROMYCIN')>0 and route=2 then drug='Azithromycin';
if index(drugname,'CEFACLOR')>0 and route=2 then drug='Cefaclor';
if index(drugname,'CEFADROXIL')>0 and route=2 then drug='Cefadroxil';
if index(drugname,'CEFDINIR')>0 and route=2 then drug='Cefdinir';
if index(drugname,'CEFDITOREN')>0 and route=2 then drug='Cefditoren';
if index(drugname,'CEFIXIME')>0 and route=2 then drug='Cefixime';
if index(drugname,'CEFPODOXIME')>0 and route=2 then drug='Cefpodoxime';
if index(drugname,'CEFPROZIL')>0 and route=2 then drug='Cefprozil';
if index(drugname,'CEFTIBUTEN')>0 and route=2 then drug='Ceftibuten';
if index(drugname,'CEFUROXIME')>0 and route=2 then drug='Cefuroxime';
if index(drugname,'CEPHALEXIN')>0 and route=2 then drug='Cephalexin';
if index(drugname,'CEPHALEX')>0 and route=2 then drug='Cephalexin';
if index(drugname,'CEPHRADINE')>0 and route=2 then drug='Cephradine';
if index(drugname,'CHLORAMPHENICOL')>0 and route=2 then drug='Chloramphenicol';
if index(drugname,'CINOXACIN')>0 and route=2 then drug='Cinoxacin';
if index(drugname,'CIPROFLOXACIN')>0 and route=2 then drug='Ciprofloxacin';
if index(drugname,'CLINDAMYCIN')>0 and route=2 then drug='Clindamycin';
if index(drugname,'CLOXACILLIN')>0 and route=2 then drug='Cloxacillin';
if index(drugname,'DICLOXACILLIN')>0 and route=2 then drug='Dicloxacillin';
if index(drugname,'DOXYCYCLINE')>0 and route=2 then drug='Doxycycline';
if index(drugname,'FIDAXOMICIN')>0 and route=2 then drug='Fidaxomicin';
if index(drugname,'FLUCONAZOLE')>0 and route=2 then drug='Fluconazole';
if index(drugname,'FOSFOMYCIN')>0 and route=2 then drug='Fosfomycin';
if index(drugname,'GATIFLOXACIN')>0 and route=2 then drug='Gatifloxacin';
if index(drugname,'ITRACONAZOLE')>0 and route=2 then drug='Itraconazole';
if index(drugname,'LEVOFLOXACIN')>0 and route=2 then drug='Levofloxacin';
if index(drugname,'LINCOMYCIN')>0 and route=2 then drug='Lincomycin';
if index(drugname,'LINEZOLID')>0 and route=2 then drug='Linezolid';
if index(drugname,'METRONIDAZOLE')>0 and route=2 then drug='Metronidazole';
if index(drugname,'MINOCYCLINE')>0 and route=2 then drug='Minocycline';
if index(drugname,'MOXIFLOXACIN')>0 and route=2 then drug='Moxifloxacin';
if index(drugname,'NITROFURANTOIN')>0 and route=2 then drug='Nitrofurantoin';
if index(drugname,'NORFLOXACIN')>0 and route=2 then drug='Norfloxacin';
if index(drugname,'OFLOXACIN')>0 and route=2 then drug='Ofloxacin';
if index(drugname,'OSELTAMIVIR')>0 and route=2 then drug='Oseltamivir';
if index(drugname,'PENICILLIN')>0 and route=2 then drug='Penicillin';
if index(drugname,'PIVAMPICILLIN')>0 and route=2 then drug='Pivampicillin';
if index(drugname,'POSACONAZOLE')>0 and route=2 then drug='Posaconazole';
if index(drugname,'SULFADIAZINE')>0 and route=2 then drug='Sulfadiazine';
if index(drugname,'SULFADIAZINE')>0 and index(drugname,'TRIMETH')>0 and route=2 then drug='Sulfadiazine-trimethoprim';
if index(drugname,'SULFAMETHOXAZOLE')>0 and route=2 then drug='Sulfamethoxazole';
if index(drugname,'SUFLAMETH')>0 and route=2 then drug='Sulfamethoxazole';
if index(drugname,'SULFISOXAZOLE')>0 and route=2 then drug='Sulfisoxazole';
if index(drugname,'TEDIZOLID')>0 and route=2 then drug='Tedizolid';
if index(drugname,'TELITHROMYCIN')>0 and route=2 then drug='Telithromycin';
if index(drugname,'TETRACYCLINE')>0 and route=2 then drug='Tetracycline';
if index(drugname,'TRIMETHOPRIM')>0 and route=2 then drug='Trimethoprim';
if index(drugname,'TRIMETHOPRIM')>0 and index(drugname,'SULFA')>0 and route=2 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'BACTRIM')>0 and route=2 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'SEPTRA DS')>0 and route=2 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'SULFA')>0 and index(drugname,'TMP')>0 and route=2 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'SULFA')>0 and index(drugname,'TRIM')>0 and route=2 then drug='Trimethoprim/Sulfamethoxazole';
if index(drugname,'VANCOMYCIN')>0 and route=2 then drug='Vancomycin';
if index(drugname,'VORICONAZOLE')>0 and route=2 then drug='Voriconazole';
run;

data all5;
set all4;
abx=1;
if drugname="CEPHALEXIN 500MG CAP" then do;
	route=2;
	drug="Cephalexin";
	end;
if index(drugname,"AMOX")>0 and index(drugname,"ORAL")>0 and index(drugname,"CLAV")>0 then do;
	route=2;
	drug="Amoxicillin/Clavulanate";
	end;
else if index(drugname,"AMOX")>0 and index(drugname,"ORAL")>0 then do;
	route=2;
	drug="Amoxicillin";
	end;
else if index(drugname,"AUGMENTIN")>0  then do;
	route=2;
	drug="Amoxicillin/Clavulanate";
	end;
if index(drugname,"BACTRIM")>0  then do;
	route=2;
	drug="Trimethoprim/Sulfamethoxazole";
	end;
if index(drugname,"CEFDITOREN")>0  then do;
	route=2;
	drug="Cefditoren";
	end;
if index(drugname,"CEPHALEXIN")>0  then do;
	route=2;
	drug="Cephalexin";
	end;
else if drug="" and route=. then delete;
run;

proc freq data=all5 noprint;
tables route*drug*drugname*localdrugnamewithdose/list missing out=look;
run;

data all6;
set all5;
if drug="" then delete;
run;

proc sort data=all6 out=all7 nodupkey; by patientsid dt2 drug; run;

******************************************************************************************************************;
* Match to Inpatient Daily file and save out file;
******************************************************************************************************************;

*now get days;
data basic1 (keep=patient_id admission_id hospital_id day dv1) ;
set cdc.basic;
run;
proc sort nodupkey data=basic1 out=basic2; by patient_id admission_id hospital_id day dv1; run;

proc sql;
create table abx1 as
select a.*,b.* 
from basic2 a inner join all7 b
on a.patient_ID=b.patientsid and
a.dv1=b.dt2;
quit;

proc contents data=abx1;
run;
proc freq data=abx1;
tables drug route day type/missing;
run;
proc freq data=abx1;
tables route*drug/list missing;
run;

data abx2 (keep=Admission_ID Hospital_ID route route2 Patient_ID day med med_type dv1 year);
set abx1;
year=year(dv1);
med=drug;
med_type="ANTIBIOTIC";
if route=1 then route2="IV";
else if route=2 then route2="PO";
run;

proc freq data=abx2;
tables year/missing;
run;

data abx3 (keep=Admission_ID Hospital_ID route Patient_ID day med med_type dv1 );
set abx2 (drop=route);
route=route2;
run;
proc sort data=abx3; by patient_id hospital_id admission_id dv1 day; run;

data cdc.antibiotics;
set abx3;
run;


dm "log; file '&path.cdc_antibiotics_step2_&pass..log'";
dm "output; file '&path.cdc_antibiotics_step2__&pass..lst'";

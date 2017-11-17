
*************************************************************************************************;
* Vasopressors - All are either IV or injection, never via mouth (PO);
*	DEXTROSE/DOPAMINE 
*	NOREPINEPHRINE
*	EPINEPHRINE
*	PHENYLEPHRINE
*	VASOPRESSIN
*	DOPAMINE ;
*
* NOTE
*	first run cdc_pressors_step1.sql to create the tables to read into this sas program;
*
* INPUTS 
*	SQL Tables
* 	[ORD_Iwashyna_201108021D].[temp].[pressors1_040716]
*	[ORD_Iwashyna_201108021D].[temp].[pressors2_040716]
*	[ORD_Iwashyna_201108021D].[temp].[pressors3_040716]
*	SAS Data files
*	cdc.basic (inpatient daily file)
*
* OUTPUTS - sas7bdat
*	files - can be deleted:
*	main.temp_pressors1_040716
*	main.temp_pressors2_040716
*	main.temp_pressors3_040716
*	final file of pressors:
*	cdc.pressors
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
* these are pressors found in the bcmadispenseddrug table;
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
FROM [ORD_Iwashyna_201108021D].[temp].[pressors1_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;
proc freq data=temp1a;
tables unitdosemedicationroute/missing;
run;
data temp1b baddrug1 badroute1;
set temp1a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='EPINEPHRINE/PRILOCAINE' or drugnamewithoutdose='CODEINE/PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='IBUPROFEN/PHENYLEPHRINE' or drugnamewithoutdose='ARTICAINE/EPINEPHRINE' or
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE/LIDOCAINE' or drugnamewithoutdose='ACETAMINOPHEN/CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='CYCLOPENTOLATE/PHENYLEPHRINE' or drugnamewithoutdose='BUPIVACAINE/EPINEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/DIPHENHYDRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE,RACEMIC' or drugnamewithoutdose='CHLORPHENIRAMINE/METHSCOPOLAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXBROMPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or 
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CARBETAPENTANE/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='CARBETAPENTANE/CHLORPHENIRAMINE/EPHEDRINE/PHENYLEPHRINE' or
drugnamewithoutdose='KETOROLAC/PHENYLEPHRINE' or drugnamewithoutdose='BROMPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='ACETAMINOPHEN/PHENYLEPHRINE' 
then output baddrug1;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EACH NOSTRIL' or unitdosemedicationroute='INFILTRATION' or unitdosemedicationroute='INHALATION' or 
unitdosemedicationroute='INTRANASAL' or unitdosemedicationroute='IRRIGATION TOPICAL' or unitdosemedicationroute='MISCELLANEOUS' or unitdosemedicationroute='NA' or unitdosemedicationroute='NASAL' or 
unitdosemedicationroute='NASAL (NOSE)' or unitdosemedicationroute='NASAL ALT' or unitdosemedicationroute='NASAL EACH' or unitdosemedicationroute='NASAL(NASALLY)' or unitdosemedicationroute='NASAL-INHALATION' or 
unitdosemedicationroute='NASALLY' or unitdosemedicationroute='NEBULIZED' or unitdosemedicationroute='NEBULIZER,INHALATION' or unitdosemedicationroute='NOSE' or unitdosemedicationroute='NOSTRIL' or 
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPTHALMIC' or 
unitdosemedicationroute='RECTAL' or unitdosemedicationroute='RECTALLY' or unitdosemedicationroute='TOPICAL' or unitdosemedicationroute='TOPICAL OPHTHALMIC' or unitdosemedicationroute='ZNASAL' or 
unitdosemedicationroute='ZZNAS' or unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZIM SUBCUTANEOUS' or 
unitdosemedicationroute='ZZZNASAL' or unitdosemedicationroute='ZZZOPTHALMIC'  
then output badroute1;
else output temp1b;
run;
proc freq data=temp1b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "pressors - dispensed drug table";
run;
data main.temp_pressors1_040716;
set temp1b;
run;

*************************************************************************************************;
* these are pressors found in the bcmaadditive table;
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
FROM [ORD_Iwashyna_201108021D].[temp].[pressors2_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;

proc freq data=temp2a;
tables unitdosemedicationroute/missing;
run;
data temp2b baddrug2 badroute2;
set temp2a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='EPINEPHRINE/PRILOCAINE' or drugnamewithoutdose='CODEINE/PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='IBUPROFEN/PHENYLEPHRINE' or drugnamewithoutdose='ARTICAINE/EPINEPHRINE' or
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE/LIDOCAINE' or drugnamewithoutdose='ACETAMINOPHEN/CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='CYCLOPENTOLATE/PHENYLEPHRINE' or drugnamewithoutdose='BUPIVACAINE/EPINEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/DIPHENHYDRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE,RACEMIC' or drugnamewithoutdose='CHLORPHENIRAMINE/METHSCOPOLAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXBROMPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or 
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CARBETAPENTANE/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='CARBETAPENTANE/CHLORPHENIRAMINE/EPHEDRINE/PHENYLEPHRINE' or
drugnamewithoutdose='KETOROLAC/PHENYLEPHRINE' or drugnamewithoutdose='BROMPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='ACETAMINOPHEN/PHENYLEPHRINE' 
then output baddrug2;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EACH NOSTRIL' or unitdosemedicationroute='INFILTRATION' or unitdosemedicationroute='INHALATION' or 
unitdosemedicationroute='INTRANASAL' or unitdosemedicationroute='IRRIGATION TOPICAL' or unitdosemedicationroute='MISCELLANEOUS' or unitdosemedicationroute='NA' or unitdosemedicationroute='NASAL' or 
unitdosemedicationroute='NASAL (NOSE)' or unitdosemedicationroute='NASAL ALT' or unitdosemedicationroute='NASAL EACH' or unitdosemedicationroute='NASAL(NASALLY)' or unitdosemedicationroute='NASAL-INHALATION' or 
unitdosemedicationroute='NASALLY' or unitdosemedicationroute='NEBULIZED' or unitdosemedicationroute='NEBULIZER,INHALATION' or unitdosemedicationroute='NOSE' or unitdosemedicationroute='NOSTRIL' or 
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPTHALMIC' or 
unitdosemedicationroute='RECTAL' or unitdosemedicationroute='RECTALLY' or unitdosemedicationroute='TOPICAL' or unitdosemedicationroute='TOPICAL OPHTHALMIC' or unitdosemedicationroute='ZNASAL' or 
unitdosemedicationroute='ZZNAS' or unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZIM SUBCUTANEOUS' or 
unitdosemedicationroute='ZZZNASAL' or unitdosemedicationroute='ZZZOPTHALMIC'  
then output badroute2;
else output temp2b;
run;
proc freq data=temp2b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "pressors - additive table";
run;

data main.temp_pressors2_040716;
set temp2b;
run;

*************************************************************************************************;
* these are pressors found in the bcmasolution table;
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
FROM [ORD_Iwashyna_201108021D].[temp].[pressors3_040716] as t1) as t1;
DISCONNECT FROM CDW1 ;
quit;

proc freq data=temp3a;
tables unitdosemedicationroute/missing;
run;
data temp3b baddrug3 badroute3;
set temp3a;
dt2=input(actiondatetime,anydtdte10.);
format dt2 date10.;
year=year(dt2);
if drugnamewithoutdose='EPINEPHRINE/PRILOCAINE' or drugnamewithoutdose='CODEINE/PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='IBUPROFEN/PHENYLEPHRINE' or drugnamewithoutdose='ARTICAINE/EPINEPHRINE' or
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE/LIDOCAINE' or drugnamewithoutdose='ACETAMINOPHEN/CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='CYCLOPENTOLATE/PHENYLEPHRINE' or drugnamewithoutdose='BUPIVACAINE/EPINEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/DIPHENHYDRAMINE/PHENYLEPHRINE' or drugnamewithoutdose='EPINEPHRINE,RACEMIC' or drugnamewithoutdose='CHLORPHENIRAMINE/METHSCOPOLAMINE/PHENYLEPHRINE' or drugnamewithoutdose='DEXBROMPHENIRAMINE/PHENYLEPHRINE' or
drugnamewithoutdose='PHENYLEPHRINE/PROMETHAZINE' or drugnamewithoutdose='PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or 
drugnamewithoutdose='ASPIRIN/CHLORPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='CARBETAPENTANE/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='CARBETAPENTANE/CHLORPHENIRAMINE/EPHEDRINE/PHENYLEPHRINE' or
drugnamewithoutdose='KETOROLAC/PHENYLEPHRINE' or drugnamewithoutdose='BROMPHENIRAMINE/DEXTROMETHORPHAN/PHENYLEPHRINE' or drugnamewithoutdose='ACETAMINOPHEN/DEXTROMETHORPHAN/GUAIFENESIN/PHENYLEPHRINE' or
drugnamewithoutdose='ACETAMINOPHEN/GUAIFENESIN/PHENYLEPHRINE' or drugnamewithoutdose='DEXTROMETHORPHAN/PHENYLEPHRINE/PYRILAMINE' or drugnamewithoutdose='ACETAMINOPHEN/PHENYLEPHRINE' 
then output baddrug3;
else if unitdosemedicationroute='BOTH EYES' or unitdosemedicationroute='EACH EYE' or unitdosemedicationroute='EACH NOSTRIL' or unitdosemedicationroute='INFILTRATION' or unitdosemedicationroute='INHALATION' or 
unitdosemedicationroute='INTRANASAL' or unitdosemedicationroute='IRRIGATION TOPICAL' or unitdosemedicationroute='MISCELLANEOUS' or unitdosemedicationroute='NA' or unitdosemedicationroute='NASAL' or 
unitdosemedicationroute='NASAL (NOSE)' or unitdosemedicationroute='NASAL ALT' or unitdosemedicationroute='NASAL EACH' or unitdosemedicationroute='NASAL(NASALLY)' or unitdosemedicationroute='NASAL-INHALATION' or 
unitdosemedicationroute='NASALLY' or unitdosemedicationroute='NEBULIZED' or unitdosemedicationroute='NEBULIZER,INHALATION' or unitdosemedicationroute='NOSE' or unitdosemedicationroute='NOSTRIL' or 
unitdosemedicationroute='OPHTHALMIC' or unitdosemedicationroute='OPHTHALMIC (BOTH)' or unitdosemedicationroute='OPHTHALMIC (DROPS)' or unitdosemedicationroute='OPTHALMIC' or 
unitdosemedicationroute='RECTAL' or unitdosemedicationroute='RECTALLY' or unitdosemedicationroute='TOPICAL' or unitdosemedicationroute='TOPICAL OPHTHALMIC' or unitdosemedicationroute='ZNASAL' or 
unitdosemedicationroute='ZZNAS' or unitdosemedicationroute='ZZOPHTHALMIC' or unitdosemedicationroute='ZZOPHTHALMIC SPACE' or unitdosemedicationroute='ZZOPTHALMIC' or unitdosemedicationroute='ZZZIM SUBCUTANEOUS' or 
unitdosemedicationroute='ZZZNASAL' or unitdosemedicationroute='ZZZOPTHALMIC'  
then output badroute3;
else output temp3b;
run;
proc freq data=temp3b;
tables unitdosemedicationroute/missing;
tables drugnamewithoutdose/missing;
tables year/missing;
title "pressors - solution table";
run;
data main.temp_pressors3_040716;
set temp3b;
run;

******************************************************************************************************************;
* Now put together files, do additional cleaning, create route, etc;
******************************************************************************************************************;

data all1 bad;
set main.temp_pressors1_040716 (in=a)
	main.temp_pressors2_040716 (in=b)
	main.temp_pressors3_040716 (in=c);
if a then ftype=1;
else if b then ftype=2;
else if c then ftype=3;

if unitdosemedicationroute ne "*Missing*" then route=1;
else if index(localdrugnamewithdose,"IV") > 0 then route=1;
else if index(localdrugnamewithdose,"VI")>0 then route=1;
else if index(localdrugnamewithdose,"INJ") > 0 then route=1;
else if index(localdrugnamewithdose,"inj") > 0 then route=1;
else if index(localdrugnamewithdose,"SUSP") > 0 then route=1;
else if index(localdrugnamewithdose,"susp") > 0 then route=1;
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
else if index(localdrugnamewithdose,"BRISTOJECT") > 0 then route=1;
else if index(localdrugnamewithdose,"JET") > 0 then route=1;
else if index(localdrugnamewithdose,"LEVOPHED BITARTRATE") > 0 then route=1;
else if index(localdrugnamewithdose,"MDV") > 0 then route=1;
else if index(localdrugnamewithdose,"SDV") > 0 then route=1;
else if index(localdrugnamewithdose,"CARTRIDGE") > 0 then route=1;
else if index(localdrugnamewithdose,"CART") > 0 then route=1;
else if index(localdrugnamewithdose,"PREFILLED") > 0 then route=1;
else if index(localdrugnamewithdose,"DRIP") > 0 then route=1;
else if index(localdrugnamewithdose,"IJ") > 0 then route=1;

if index(localdrugnamewithdose,"TAB") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"tab") > 0  and route=. then output bad;
else if index(localdrugnamewithdose,"ORAL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"SPRAY") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"SUPP") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"NASAL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"NSL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"nasal") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"NAS SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"NAS SPR") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"NOSE DROPS") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INH SOL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INHL SOL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INHL SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INHAL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"SOLN,INHL") > 0 then output bad;
else if index(localdrugnamewithdose,"INHL,SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INHL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"INHAL") > 0  and route=. then output bad;
else if index(localdrugnamewithdose,"INHALATION") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"HEMORRHOIDAL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"OPH SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"OINT") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"OPHTHALMIC SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"OPHTH SOL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"GEL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP. SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP.SOLN") > 0  and route=. then output bad;
else if index(localdrugnamewithdose,"TOP SOL") > 0  and route=. then output bad;
else if index(localdrugnamewithdose,"TOP. SOL.") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOPICAL SOL") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOPICAL SOLN") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOPICAL SWAB") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP PLEDGET") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP SWAB") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"TOP WIPE") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"SOLN TOP") > 0 and route=.  then output bad;
else if index(localdrugnamewithdose,"SWAB") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"CREAM") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"cream") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"SOLN,OPH") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"EYE DROP")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"EYE SOLN")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"LOTION")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"CR,TOP")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"CR")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"CRM,TOP")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"CRM")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"JELLY")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"VAG CR")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"VAGINAL CR")>0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPHTH SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPTH SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPTH. SOL") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPHTH") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPTHAL DROPS") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"SOL,OPH") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"EAR SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPH") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPH SOL") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPH/OTIC SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPHT SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPHT SOL") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OTIC SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"otic soln") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OTIC SOLUTION") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"SOLN,OTIC") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"SOLN F/EYE") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPTHAL SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"EYE SOLN") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OTIC") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"otic") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"TOP") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"top") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"opth") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"OPTH") > 0 and route=. then output bad;
else if index(localdrugnamewithdose," OS ") > 0 and route=. then output bad;
else if index(localdrugnamewithdose," OD ") > 0 and route=. then output bad;
else if index(localdrugnamewithdose,"INHL") > 0 and route=. then output bad;
else output all1;
run;
/*
proc freq data=bad;
tables localdrugnamewithdose;
title "excluded drugs";
run;
*/

proc freq data=bad noprint;
tables localdrugnamewithdose*drugnamewithoutdose/list missing out=badlook1;
run;

data all2 (keep=patientsid dt2 localdrugnamewithdose primarydrug type route routeflag actiondatetime drug drugname drugnamewithoutdose) bad2;
set all1;
length drug $ 40;
drugname=upcase(localdrugnamewithdose);
if route=. then routeflag=1;
if route=. then route=1;

if index(drugname,"NOREPINEPHRINE")>0 then drug="Norepinephrine";
else if index(drugname,"NOREPHINEPHRINE")>0 then drug="Norepinephrine";
else if index(drugname,"LEVOPHED BITARTRATE")>0 then drug="Norepinephrine";
else if index(drugname,"EPINEPHRINE")>0 then drug="Epinephrine";
else if index(drugname,"BUPIVACAINE")>0 and index(drugname,"EPI")>0 then drug="Epinephrine";
else if index(drugname,"BUPIVACAINE")>0 then drug="Epinephrine";
else if index(drugname,"EPI")>0 then drug="Epinephrine";
else if index(drugname,"PHENYLEPHRINE")>0 then drug="Phenylephrine";
else if index(drugname,"PHENYLEPH")>0 then drug="Phenylephrine";
else if index(drugname,"DOPAMINE")>0 then drug="Dopamine";
else if index(drugname,"VASOPRESSIN")>0 then drug="Vasopressin";
else if index(drugname,"VASPORESSIN")>0 then drug="Vasopressin";

if index(drugname,"RACEMIC EPINEPHRINE")>0 then output bad2;
else if index(drugname,"EPINEPHRINE")>0 and index(drugname,"RACEMIC")>0 then output bad2;
else if index(drugnamewithoutdose,"EPINEPHRINE")>0 and index(drugnamewithoutdose,"RACEMIC")>0 then output bad2;
else if index(drugname,"RACEPINEPHRINE")>0 then output bad2;
else if index(drugname,"PROMETHAZINE")>0 then output bad2;
else if drugname="ZZEPINEPHRINE 1MG/10ML PFS, 3.5IN NEEDLE" then output bad2;
else if drugname="PHENERGAN EXPECTORANT W/CODEINE,OZ" then output bad2;
else if index(drugname,"LIDOCAINE")>0 then output bad2;
else if drugname="EPINEPHRINE(EPIPEN) 0.3MG/0.3ML" then output bad2;
else if drugname="EPINEPHRINE (EPI-PEN) 2-PAK 0.3MG/0.3ML" then output bad2;
else if drugname="EPINEPHRINE 1:10,000 (0.1MG/ML)" then output bad2;
else if drugname="EPINEPHRINE 1:10,000 (0.1MG/ML),SYG 10ML" then output bad2;
else if drugname="EPINEPHRINE 1:1000 (1MG/ML) AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000 1MG/ML AMPS" then output bad2;
else if drugname="EPINEPHRINE 1:1000 1ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000 P/F 1 ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000 PF 1ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000 SOL 1 ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000, 1MG/ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1:1000, 1ML" then output bad2;
else if drugname="EPINEPHRINE 1MG/ML" then output bad2;
else if drugname="EPINEPHRINE 1MG/ML (1:1000) 1ML AMP" then output bad2;
else if drugname="EPINEPHRINE 1MG/ML (1:1000) PF AMP 1ML" then output bad2;
else if drugname="EPINEPHRINE 1MG/ML 1ML AMP" then output bad2;
else if drugname="EPINEPHRINE HCL 1:1000 1ML *ADRENALIN*" then output bad2;
else if drugname="EPINEPHRINE HCL 1:1000 1ML AMP" then output bad2;
else output all2;
run;

proc freq data=all2 noprint;
tables route*drug*drugname*drugnamewithoutdose/list missing out=look;
run;
proc contents data=all2;
run;

data all3 (keep=patientsid dt2 route2 med med_type drugtime pressor);
set all2;
length med_type $ 10;
length med $ 15;
format dt2 date10.;
med=drug;
med_type="Pressor";
drugtime=actiondatetime;
if route=1 then route2="IV";
pressor=1;
run;

proc sort data=all3 out=all4 nodupkey; by patientsid dt2 med ; run;

******************************************************************************************************************;
* Match to Inpatient Daily file and save out file;
******************************************************************************************************************;

*now get days;
data basic1 (keep=patient_id admission_id hospital_id day dv1 year) ;
set cdc.basic;
run;
proc sort nodupkey data=basic1 out=basic2; by patient_id admission_id hospital_id day dv1; run;

proc sql;
create table pr1 as
select a.*,b.* 
from basic2 a inner join all4 b
on a.patient_ID=b.patientsid and
a.dv1=b.dt2;
quit;

proc freq data=pr1;
tables med route2 med_type/missing;
tables year/missing;
run;

proc contents data=pr1;
run;

data cdc.pressors (keep=Admission_ID Hospital_ID  Patient_ID dv1 day med_type med route );
set pr1 ;
route=route2;
run;

dm "log; file '&path.cdc_pressors_step2_&pass..log'";
dm "output; file '&path.cdc_pressors_step2__&pass..lst'";

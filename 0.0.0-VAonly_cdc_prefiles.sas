**************************************************************************************************;
* check structure of CDC files and modify as necessary ;
* use I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\CDC National Sepsis Surveillance Project_VA ;
*	Data Spec Summary and Data Dictionary - 20160803.xlsx ;
**************************************************************************************************;

options nofmterr;
libname cdc "I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\data";
libname cdcinput "I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\CDC National Sepsis Surveillance Project_VA\Input Datasets";

*pass=2 update blood_culture and clincial_culture datasets;
%let pass=2;

%let path=I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\CDC National Sepsis Surveillance Project_VA\Input Datasets\;
%let pathlog=I:\VA Sepsis\V. Identifiable Data\CDCworkgroup\CDC National Sepsis Surveillance Project_VA\VAlogs\;

***********************************************************************************************************************************;
* Medication table;
***********************************************************************************************************************************;

data abx1 (drop=hospital_id dv1 med_type);
set cdc.antibiotics;
med=upcase(med);
if med_type="ANTIBIOTIC" then med_type1=2;
if med = "AMOXICILLIN/CLAVULANATE" then med = "AMOXICILLIN_CLAVULANTE";
else if med = "AMOXICILLINCLAVULAN" then med = "AMOXICILLIN_CLA";
else if med =: "AMPHOTERICIN B" then med = "AMPHOTERICIN_B";
else if med = "AMPICILLIN-SULBACTAM" then med = "AMPICILLIN_SULBACTAM";
else if med = "CEFTAZIDIME-AVIBACTAM" then med = "CEFTAZIDIME_AVIBACTAM";
else if med = "CEFTOLOZANE-TAZOBACTAM" then med = "CEFTOLOZANE_TAZOBACTAM";
else if med = "IMIPENEM-CILASTATIN" then med = "IMIPENEM_CILASTATIN";
else if med = "PIPERACILLIN-TAZOBACTAM" then med = "PIPERACILLIN_TAZOBACTAM";
else if med = "PIPERACILLIN-TAZOBAC" then med = "PIPERACILLIN_TAZOBAC";
else if med = "POLYMYXIN B SULFATE" then med = "POLYMYXIN_B";
else if med = "POLYMYXIN-B" then med = "POLYMYXIN_B";
else if med = "QUINUPRISTIN/DALFOPRISTIN" then med = "QUINUPRISTIN_DAL";
else if med = "QUINUPRISTIN/DALFOPR" then med = "QUINUPRISTIN_DAL";
else if med = "SULFADIAZINE-TRIMETHOPRIM" then med = "SULFADIAZINE_TRI";
else if med = "SULFAMETHOXAZOLE-TRIMETHOPRIM" then med = "SULFAMETHOXAZOLE_TRI";
else if med = "TICARCILLIN-CLAVULANATE" then med = "TICARCILLIN_CLAVULANATE";
else if med = "AMPICILLIN/SULBACTAM" then med = "AMPICILLIN_SULBACTAM";
else if med= "COLISTIN (COLISTIMETHATE SODIUM)" then med="COLISTIN";
else if med = "PIPERACILLIN/TAZOBACTAM" then med = "PIPERACILLIN_TAZOBACTAM";
else if med = "TICARCILLIN/CLAVULANATE" then med = "TICARCILLIN_CLAVULANATE";
else if med = "TRIMETHOPRIM/SULFAMETHOXAZOLE" then med = "TRIMETHOPRIM_SULFAMETHOXAZOLE";
run;

proc freq data=abx1;
tables med med_type1 route/missing;
run;

data pre1 (drop=hospital_id dv1 med_type);
set cdc.pressors;
med=upcase(med);
if med_type="Pressor" then med_type1=1;
run;

proc freq data=pre1;
tables med med_type1 route/missing;
run;

data meds1 (drop=med_type1);
set abx1
	pre1;
med_type=med_type1;
run;

proc freq data=meds1;
tables med med_type route/missing;
run;

data cdcinput.medication;
set meds1;
run;

***********************************************************************************************************************************;
* blood_culture table;
***********************************************************************************************************************************;

data bc1 (drop=patientsid dv1 day hasmicro);
set cdc.has_bloodcult;
patient_id=patientsid;
bcx_drawn_day=day;
run;

data cdcinput.blood_culture;
retain patient_id admission_id bcx_drawn_day;
set bc1;
run;

***********************************************************************************************************************************;
* clinical_culture table;
* put together had_bloodcult & has_oth_micro;
* remove duplicates ;
***********************************************************************************************************************************;

data cc1 (drop=patientsid dv1 day hasmicro);
set cdc.has_bloodcult
	cdc.has_oth_micro;
patient_id=patientsid;
bcx_drawn_day=day;
dupe=compress(patient_id||dv1||hasmicro||day);
run;

proc sort data=cc1 nodupkey; by dupe; run;

data cdcinput.clinical_culture (drop=dupe);
retain patient_id admission_id bcx_drawn_day;
set cc1;
run;

dm "log; file '&pathlog.cdc_prefiles.&pass..log'";
dm "output; file '&pathlog.cdc_prefiles.&pass..lst'";

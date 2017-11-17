

 select localdrugsid,drugnamewithoutdose,LocalDrugNameWithDose,VAClassification,UnitDoseMedicationRoute, UnitDoseMedicationRouteSID, SourceOfSupply
  into #ab1
  from cdwwork.dim.localdrug where drugnamewithoutdose like ('%Acyclovir%') or 
drugnamewithoutdose like ('%Amikacin%') or 
drugnamewithoutdose like ('%Amoxicillin%') or 
drugnamewithoutdose like ('%Clavulanate%') or 
drugnamewithoutdose like ('%Amphotericin B%') or 
drugnamewithoutdose like ('%Ampicillin%') or 
drugnamewithoutdose like ('%Sulbactam%') or 
drugnamewithoutdose like ('%Anidulafungin%') or 
drugnamewithoutdose like ('%Azithromycin%') or 
drugnamewithoutdose like ('%Aztreonam%') or 
drugnamewithoutdose like ('%Caspofungin%') or 
drugnamewithoutdose like ('%Cefaclor%') or 
drugnamewithoutdose like ('%Cefadroxil%') or 
drugnamewithoutdose like ('%Cefamandole%') or 
drugnamewithoutdose like ('%Cefazolin%') or 
drugnamewithoutdose like ('%Cefdinir%') or 
drugnamewithoutdose like ('%Cefditoren%') or 
drugnamewithoutdose like ('%Cefepime%') or 
drugnamewithoutdose like ('%Cefixime%') or 
drugnamewithoutdose like ('%Cefmetazole%') or 
drugnamewithoutdose like ('%Cefonicid%') or 
drugnamewithoutdose like ('%Cefoperazone%') or 
drugnamewithoutdose like ('%Cefotaxime%') or 
drugnamewithoutdose like ('%Cefotetan%') or 
drugnamewithoutdose like ('%Cefoxitin%') or 
drugnamewithoutdose like ('%Cefpodoxime%') or 
drugnamewithoutdose like ('%Cefprozil%') or 
drugnamewithoutdose like ('%Ceftaroline%') or 
drugnamewithoutdose like ('%Ceftazidime%') or 
drugnamewithoutdose like ('%Avibactam%') or 
drugnamewithoutdose like ('%Ceftibuten%') or 
drugnamewithoutdose like ('%Ceftizoxime%') or 
drugnamewithoutdose like ('%Tazobactam%') or 
drugnamewithoutdose like ('%Ceftriaxone%') or 
drugnamewithoutdose like ('%Cefuroxime%') or 
drugnamewithoutdose like ('%Cephalexin%') or 
drugnamewithoutdose like ('%Cephalothin%') or 
drugnamewithoutdose like ('%Cephapirin%') or 
drugnamewithoutdose like ('%Cephradine%') or 
drugnamewithoutdose like ('%Chloramphenicol%') or 
drugnamewithoutdose like ('%Cidofovir%') or 
drugnamewithoutdose like ('%Cinoxacin%') or 
drugnamewithoutdose like ('%Ciprofloxacin%') or 
drugnamewithoutdose like ('%Clindamycin%') or 
drugnamewithoutdose like ('%Cloxacillin%') or 
drugnamewithoutdose like ('%Colistin%') or 
drugnamewithoutdose like ('%Colistimethate%') or 
drugnamewithoutdose like ('%Dalbavancin%') or 
drugnamewithoutdose like ('%Daptomycin%') or 
drugnamewithoutdose like ('%Dicloxacillin%') or 
drugnamewithoutdose like ('%Doripenem%') or 
drugnamewithoutdose like ('%Doxycycline%') or 
drugnamewithoutdose like ('%Ertapenem%') or 
drugnamewithoutdose like ('%Fidaxomicin%') or 
drugnamewithoutdose like ('%Fluconazole%') or 
drugnamewithoutdose like ('%Foscarnet%') or 
drugnamewithoutdose like ('%Fosfomycin%') or 
drugnamewithoutdose like ('%Ganciclovir%') or 
drugnamewithoutdose like ('%Gatifloxacin%') or 
drugnamewithoutdose like ('%Gentamicin%') or 
drugnamewithoutdose like ('%Imipenem%') or 
drugnamewithoutdose like ('%Itraconazole%') or 
drugnamewithoutdose like ('%Kanamycin%') or 
drugnamewithoutdose like ('%Levofloxacin%') or 
drugnamewithoutdose like ('%Lincomycin%') or 
drugnamewithoutdose like ('%Linezolid%') or 
drugnamewithoutdose like ('%Meropenem%') or 
drugnamewithoutdose like ('%Methicillin%') or 
drugnamewithoutdose like ('%Metronidazole%') or 
drugnamewithoutdose like ('%Mezlocillin%') or 
drugnamewithoutdose like ('%Micafungin%') or 
drugnamewithoutdose like ('%Minocycline%') or 
drugnamewithoutdose like ('%Moxifloxacin%') or 
drugnamewithoutdose like ('%Nafcillin%') or 
drugnamewithoutdose like ('%Nitrofurantoin%') or 
drugnamewithoutdose like ('%Norfloxacin%') or 
drugnamewithoutdose like ('%Ofloxacin%') or 
drugnamewithoutdose like ('%Oritavancin%') or 
drugnamewithoutdose like ('%Oxacillin%') or 
drugnamewithoutdose like ('%Penicillin%') or 
drugnamewithoutdose like ('%Peramivir%') or 
drugnamewithoutdose like ('%Piperacillin%') or 
drugnamewithoutdose like ('%Tazobactam%') or 
drugnamewithoutdose like ('%Pivampicillin%') or 
drugnamewithoutdose like ('%Polymyxin B%') or 
drugnamewithoutdose like ('%Posaconazole%') or 
drugnamewithoutdose like ('%Quinupristin%') or 
drugnamewithoutdose like ('%Dalfopristin%') or 
drugnamewithoutdose like ('%Streptomycin%') or 
drugnamewithoutdose like ('%Sulfadiazine%') or 
drugnamewithoutdose like ('%trimethoprim%') or 
drugnamewithoutdose like ('%Sulfamethoxazole%') or 
drugnamewithoutdose like ('%Sulfisoxazole%') or 
drugnamewithoutdose like ('%Tedizolid%') or 
drugnamewithoutdose like ('%Telavancin%') or 
drugnamewithoutdose like ('%Telithromycin%') or 
drugnamewithoutdose like ('%Tetracycline%') or 
drugnamewithoutdose like ('%Ticarcillin%') or 
drugnamewithoutdose like ('%Clavulanate%') or 
drugnamewithoutdose like ('%Tigecycline%') or 
drugnamewithoutdose like ('%Tobramycin%') or 
drugnamewithoutdose like ('%Trimethoprim%') or 
drugnamewithoutdose like ('%Sulfamethoxazole%') or 
drugnamewithoutdose like ('%Vancomycin%') or 
drugnamewithoutdose like ('%Voriconazole%') 


--select drugnames of interest from the BCMADispensedDrug table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,t2.patientsid,t2.actiondatetime
into [ORD_Iwashyna_201108021D].[temp].antibiotic1_040716
  from #ab1 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMADispensedDrug t2
  on t1.LocalDrugSID=t2.LocalDrugSID


--select drugnames of interest from the dim.IVadditiveIngredient table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
       t2.IVAdditiveIngredientSID,t2.IVAdditiveIngredientPrintName,t2.PrimaryDrug,t2.PrimaryDrugSID
  into #ab2
  from #ab1 t1
  inner join [CDWWork].[Dim].[IVAdditiveIngredient] t2
  on t1.LocalDrugSID=t2.LocalDrugSID

--now get drug use for our patient cohort by linking to bcmaAdditive, link using IVAdditiveIngredientSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
       t1.IVAdditiveIngredientSID,t1.IVAdditiveIngredientPrintName,t1.PrimaryDrug,t1.PrimaryDrugSID,
       t2.ActionDateTime,t2.BCMAMedicationLogSID
  into #ab3
  from #ab2 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAAdditive t2
  on t1.IVAdditiveIngredientSID=t2.IVAdditiveIngredientSID

drop table #ab2

--now we need to get patientSID. get this by linking to bcmaMedicationLog, link using BCMAMedicationLogSID
--save temp file so we can read into SAS
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
       t1.IVAdditiveIngredientSID,t1.IVAdditiveIngredientPrintName,t1.PrimaryDrug,t1.PrimaryDrugSID,
       t1.ActionDateTime,t1.bcmamedicationlogsid,
       t2.patientsid
  into [ORD_Iwashyna_201108021D].[temp].antibiotic2_040716
  from #ab3 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAMedicationLog t2
  on t1.[BCMAMedicationLogSID]=t2.[BCMAMedicationLogSID]

--drop temp tables
drop table #ab2
drop table #ab3


--select drugnames of interest from the dim.IVSolutionIngredient table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
       t2.IVSolutionIngredientSID,t2.IVSolutionFirstIngredientPrintName,
       t2.IVSolutionSecondIngredientPrintName,t2.PrimaryDrug,t2.PrimaryDrugSID
  into #ab2
  from #ab1 t1
  inner join [CDWWork].[Dim].[IVSolutionIngredient] t2
  on t1.LocalDrugSID=t2.LocalDrugSID


--now get drug use for our patient cohort by linking to bcmaSolution, link using IVSolutionIngredientSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
	   t1.IVSolutionIngredientSID,t1.PrimaryDrug,t1.PrimaryDrugSID,
	   t2.ActionDateTime,t2.bcmamedicationlogsid
  into #ab3
  from #ab2 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMASolution t2
  on t1.IVSolutionIngredientSID=t2.IVSolutionIngredientSID


--now we need to get patientSID. get this by linking to bcmaMedicationLog, link using BCMAMedicationLogSID
--save temp file so we can read into SAS
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
	   t1.IVSolutionIngredientSID,t1.PrimaryDrug,t1.PrimaryDrugSID,t1.ActionDateTime,t1.bcmamedicationlogsid,
	   t2.patientsid
  into [ORD_Iwashyna_201108021D].[temp].antibiotic3_040716
  from #ab3 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAMedicationLog t2
  on t1.[BCMAMedicationLogSID]=t2.[BCMAMedicationLogSID]

drop table #ab2
drop table #ab3

drop table [ORD_Iwashyna_201108021D].[temp].antibiotic2_040716
drop table [ORD_Iwashyna_201108021D].[temp].antibiotic1_040716
drop table [ORD_Iwashyna_201108021D].[temp].antibiotic3_040716
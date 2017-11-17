
--4762
select localdrugsid,drugnamewithoutdose,LocalDrugNameWithDose,VAClassification,UnitDoseMedicationRoute,UnitDoseMedicationRouteSID,SourceOfSupply
into #pressors1  
from cdwwork.dim.localdrug where drugnamewithoutdose like ('%norepinephrine%') or 
drugnamewithoutdose like ('%epinephrine%') or 
drugnamewithoutdose like ('%phenylephrine%') or 
drugnamewithoutdose like ('%dopamine%') or 
drugnamewithoutdose like ('%vasopressin%')


--select drugnames of interest from the BCMADispensedDrug table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
	   t2.patientsid,t2.actiondatetime
into [ORD_Iwashyna_201108021D].[temp].pressors1_040716
  from #pressors1 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMADispensedDrug t2
  on t1.LocalDrugSID=t2.LocalDrugSID  
    
--select drugnames of interest from the dim.IVadditiveIngredient table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
	   t2.IVAdditiveIngredientSID,t2.IVAdditiveIngredientPrintName,t2.PrimaryDrug,t2.PrimaryDrugSID
  into #pressors2
  from #pressors1 t1
  inner join [CDWWork].[Dim].[IVAdditiveIngredient] t2
  on t1.LocalDrugSID=t2.LocalDrugSID
  
--now get drug use for our patient cohort by linking to bcmaAdditive, link using IVAdditiveIngredientSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,
	   t1.IVAdditiveIngredientSID,t1.IVAdditiveIngredientPrintName,t1.PrimaryDrug,t1.PrimaryDrugSID,
	   t2.ActionDateTime,t2.bcmamedicationlogsid
  into #pressors3
  from #pressors2 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAAdditive t2
  on t1.IVAdditiveIngredientSID=t2.IVAdditiveIngredientSID

  --now we need to get patientSID. get this by linking to bcmaMedicationLog, link using BCMAMedicationLogSID
--save temp file so we can read into SAS  
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,t1.IVAdditiveIngredientSID,t1.IVAdditiveIngredientPrintName,t1.PrimaryDrug,t1.PrimaryDrugSID,t1.ActionDateTime,t1.bcmamedicationlogsid,t2.patientsid
  into  [ORD_Iwashyna_201108021D].[temp].pressors2_040716
  from #pressors3 t1
  left join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAMedicationLog t2
  on t1.[BCMAMedicationLogSID]=t2.[BCMAMedicationLogSID]  
    
--select drugnames of interest from the dim.IVSolutionIngredient table, link using localdrugSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,t2.IVSolutionIngredientSID,t2.PrimaryDrug,t2.PrimaryDrugSID
  into #pressors4
  from #pressors1 t1
  inner join [CDWWork].[Dim].[IVSolutionIngredient] t2
  on t1.LocalDrugSID=t2.LocalDrugSID

--now get drug use for our patient cohort by linking to bcmaSolution, link using IVSolutionIngredientSID
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,t1.IVSolutionIngredientSID,t1.PrimaryDrug,t1.PrimaryDrugSID,t2.ActionDateTime,t2.bcmamedicationlogsid
  into #pressors5
  from #pressors4 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMASolution t2
  on t1.IVSolutionIngredientSID=t2.IVSolutionIngredientSID
  
--now we need to get patientSID. get this by linking to bcmaMedicationLog, link using BCMAMedicationLogSID
--save temp file so we can read into SAS  
select t1.localdrugsid,t1.drugnamewithoutdose,t1.LocalDrugNameWithDose,t1.vaclassification,t1.unitdosemedicationroute,t1.IVSolutionIngredientSID,t1.PrimaryDrug,t1.PrimaryDrugSID,t1.ActionDateTime,t1.bcmamedicationlogsid,t2.patientsid
  into  [ORD_Iwashyna_201108021D].[temp].pressors3_040716
  from #pressors5 t1
  inner join [ORD_Iwashyna_201108021D].[src].BCMA_BCMAMedicationLog t2
  on t1.[BCMAMedicationLogSID]=t2.[BCMAMedicationLogSID]  

 

select drugnamewithoutdose,count(*)
from #pressors4
  group by drugnamewithoutdose
  
select drugnamewithoutdose,count(*)
from #pressors5
  group by drugnamewithoutdose
  
select drugnamewithoutdose,count(*)
from [ORD_Iwashyna_201108021D].[temp].pressors3_040716
  group by drugnamewithoutdose

drop table #pressors1 
drop table #pressors2 
drop table #pressors3 
drop table #pressors4 
drop table #pressors5 
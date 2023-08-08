-------Associations among resistances in gram-positive bacteria 

select Rule_type, Association
, max(Support_Before2010) as Support_Before2010
, max(Support_After2010) as Support_After2010
, max(Sup_Difference) as Difference_in_Support_After2010
, max(Confidence_Before2010) as Confidence_Before2010
, max(Confidence_After2010) as Confidence_After2010
, max(Conf_Difference) as Difference_in_Confidence_After2010
, max(Lift_Before2010) as Lift_Before2010
, max(Lift_After2010) as Lift_After2010
, max(Lift_Difference) as Difference_in_Lift_After2010
 
from
(select Rule_type 
,replace(Association, ':resistant','') as Association
, Support_Before2010
, Support_After2010
, Confidence_Before2010
, Confidence_After2010
, Lift_Before2010
, Lift_After2010
, Sup_Difference,Conf_Difference,Lift_Difference
 
from
(select t.*
, case when abs(Supp_Def_Per) = 0 then 'None'
       when abs(Supp_Def_Per) <=25 then 'Minor'
	   else 'Major'
  end + ' ('+cast(cast( (Supp_Def_Per) as int) as varchar(5))+'%)' as Sup_Difference
, case when abs(Conf_Def_Per) = 0 then 'None'
       when abs(Conf_Def_Per) <=10 then 'Minor'
	   else 'Major'
  end + ' ('+cast(cast( (Conf_Def_Per) as int) as varchar(5))+'%)' as Conf_Difference
, case when abs(Lift_Def_Per) = 0 then 'None'
       when abs(Lift_Def_Per) <=25 then 'Minor'
	   else 'Major'
  end  + ' ('+cast(cast( (Lift_Def_Per) as int) as varchar(5))+'%)' as Lift_Difference
 
from
(
select a.ruleid,a.association

, a.real_support as Support_Before2010
, b.real_support as Support_After2010
,(b.real_support - a.real_support)*100.0/ a.real_support    as Supp_Def_Per 
 
, a.confidence as Confidence_Before2010
, b.confidence as Confidence_After2010
,(b.confidence - a.confidence)*100.0/ a.confidence    as Conf_Def_Per
 
, a.lift as Lift_Before2010
, b.lift as Lift_After2010
,(b.lift - a.lift)*100.0/  a.lift    as Lift_Def_Per 
 
 
from
(
SELECT distinct substring(a.ruleid,1,19) as group_id, a.*
  FROM [AssociationRule] a
  inner join
  Attribute b
  on a.ruleid = b.ruleid
     where a.sampling_condition like '%2000%'
	 and a.sampling_condition like '%pos%'
	 and a.real_support >= 0.1
	 and a.support >= 0.05
	 and a.confidence >= 0.8
	 and a.lift >= 1.5
   ) a
   inner join
   (
SELECT distinct substring(a.ruleid,1,19) as group_id, a.*
  FROM [AssociationRule] a
  inner join
  Attribute b
  on a.ruleid = b.ruleid
     where a.sampling_condition like '%2010%'
	   and a.sampling_condition like '%pos%'
   ) b
   on a.association = b.association

   ) t
 ) kk 
 inner join
 (select ruleid , case when max(class) is null then 'Intra_Class' when max(class) = min(class) then  'Intra_Class' else 'Cross_Class' end as rule_type
   from Attribute a
   left join
   (select drug , case when class in    ('Cephalosporins','Penicillins', 'Beta lactam','Carbapenems' )  then 'Beta Lactam' else Class end as Class from drug) d
   on d.drug = a.attribute
   group by ruleid
 
 ) bb
 on kk.ruleid = bb.ruleid


 union all

 select Rule_type 
, replace(Association, ':resistant','') as Association
, Support_Before2010
, Support_After2010
, Confidence_Before2010
, Confidence_After2010
, Lift_Before2010
, Lift_After2010
, Sup_Difference,Conf_Difference,Lift_Difference
 
from
(select t.*
, case when abs(Supp_Def_Per) = 0 then 'None'
       when abs(Supp_Def_Per) <=25 then 'Minor'
	   else 'Major'
  end + ' ('+cast(cast( (Supp_Def_Per) as int) as varchar(5))+'%)' as Sup_Difference
, case when abs(Conf_Def_Per) = 0 then 'None'
       when abs(Conf_Def_Per) <=10 then 'Minor'
	   else 'Major'
  end + ' ('+cast(cast( (Conf_Def_Per) as int) as varchar(5))+'%)' as Conf_Difference
, case when abs(Lift_Def_Per) = 0 then 'None'
       when abs(Lift_Def_Per) <=25 then 'Minor'
	   else 'Major'
  end  + ' ('+cast(cast( (Lift_Def_Per) as int) as varchar(5))+'%)' as Lift_Difference
 
from
(
select a.ruleid,a.association

, a.real_support as Support_Before2010
, b.real_support as Support_After2010
,(b.real_support - a.real_support)*100.0/ a.real_support    as Supp_Def_Per 
 
, a.confidence as Confidence_Before2010
, b.confidence as Confidence_After2010
,(b.confidence - a.confidence)*100.0/ a.confidence    as Conf_Def_Per
 
, a.lift as Lift_Before2010
, b.lift as Lift_After2010
,(b.lift - a.lift)*100.0/  a.lift    as Lift_Def_Per 

 
from
(
SELECT distinct substring(a.ruleid,1,19) as group_id, a.*
  FROM [AssociationRule] a
  inner join
  Attribute b
  on a.ruleid = b.ruleid
     where a.sampling_condition like '%2000%'
	 and a.sampling_condition like '%pos%'
	 ) a
   inner join
   (
SELECT distinct substring(a.ruleid,1,19) as group_id, a.*
  FROM [AssociationRule] a
  inner join
  Attribute b
  on a.ruleid = b.ruleid
     where a.sampling_condition like '%2010%'
	   and a.sampling_condition like '%pos%'
     and a.real_support >= 0.1
   	 and a.support >= 0.05
	 and a.confidence >= 0.8
	 and a.lift >= 1.5
   ) b
   on a.association = b.association

   ) t
 ) kk 
 inner join
 (select ruleid , case when max(class) is null then 'Intra_Class' when max(class) = min(class) then  'Intra_Class' else 'Cross_Class' end as rule_type
   from Attribute a
   left join
   (select drug , case when class in    ('Cephalosporins','Penicillins', 'Beta lactam','Carbapenems' )  then 'Beta Lactam' else Class end as Class from drug) d
   on d.drug = a.attribute
   group by ruleid
 
 ) bb
 on kk.ruleid = bb.ruleid

 ) a
 group by  Rule_type,association




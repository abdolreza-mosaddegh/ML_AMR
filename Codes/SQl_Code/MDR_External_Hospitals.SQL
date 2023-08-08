use HorseDB
---- MDR prevalence (External Hospitals)

 select MDR_by_gram_decade.Gram_id, MDR_by_gram_decade.decade, 
       MultiResistantIsolates,TotalIsolates, (MultiResistantIsolates * 100.0) /TotalIsolates as MultiDrugResistant_Ratio
from

(select Gram_id, decade, count(*) as MultiResistantIsolates 
from
(select Gram_id,decade,  id
 from
 (SELECT distinct Gram_id,decade,id
      ,  case when   class in    ('Cephalosporins','Penicillins', 'Beta lactam','Carbapenems' ) then 'Beta lactam' else class end  as class
  FROM Horse_External_Hospital_View 
  where Status = 'resistant'  ) ResistantIsloates
  group by   Gram_id, decade,  id
  having count(*) > 2 ) MDR
  group by   Gram_id,decade ) MDR_by_gram_decade

  inner join

 (select Gram_id,decade,   count(*) as TotalIsolates
  from 
  (SELECT distinct Gram_id,decade,id
  FROM Horse_External_Hospital_View
  ) All_isloates
  group by Gram_id,decade
 ) All_isloates_by_gram_decade
  
 on  MDR_by_gram_decade.Gram_id = All_isloates_by_gram_decade.Gram_id 
 and MDR_by_gram_decade.decade = All_isloates_by_gram_decade.decade

 order by  MDR_by_gram_decade.Gram_id ,MDR_by_gram_decade.decade
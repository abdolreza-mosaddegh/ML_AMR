use HorseDB
---------------Prevalence of MDR by antimicrobial classes

select Gram_id,Class
, cast(cast (PrevalenceRatio_Before2010 as decimal(5,2))  as varchar(10))  + 
 ' ('+ 
 cast(cast (Resistant_Cases_Before2010 as decimal(5))  as varchar(10)) +
' / '+
cast(cast (TestedIsolatesBefore2010 as decimal(5))  as varchar(10)) +
' )'
as Prevalence_Before2010


, cast(cast (PrevalenceRatio_after2010 as decimal(5,2))  as varchar(10))  + 
 ' ('+ 
 cast(cast (Resistant_Cases_after2010 as decimal(5))  as varchar(10)) +
' / '+
cast(cast (TestedIsolatesafter2010 as decimal(5))  as varchar(10)) +
')'
as Prevalence_after2010

from
(select gram_id,class,
(Resistant_Cases_Before2010 +  susceptible_Cases_Before2010) as TestedIsolatesBefore2010,
(Resistant_Cases_After2010  +   susceptible_Cases_After2010) as TestedIsolatesAfter2010,
Resistant_Cases_Before2010,
Resistant_Cases_After2010,
case when Resistant_Cases_Before2010 = 0 then 0 else ( (Resistant_Cases_Before2010)*100.0) / ( (Resistant_Cases_Before2010) +  (susceptible_Cases_Before2010)) end as PrevalenceRatio_Before2010,
case when Resistant_Cases_After2010 = 0 then 0 else ( (Resistant_Cases_After2010)*100.0) / ( (Resistant_Cases_After2010) +  (susceptible_Cases_After2010)) end as PrevalenceRatio_After2010


from
(select gram_id,class,
sum(case when decade = '2000-2009' then resistant else 0 end) as Resistant_Cases_Before2010 ,
sum(case when decade = '2010-2020' then resistant else 0 end) as Resistant_Cases_After2010 ,
sum(case when decade = '2000-2009' then susceptible else 0 end) as susceptible_Cases_Before2010 ,
sum(case when decade = '2010-2020' then susceptible else 0 end) as susceptible_Cases_After2010 
from
(SELECT    id, gram_id,decade,    Class 
, case when max (case when status = 'susceptible' then 0 else 1 end) > 0 then 1 else 0 end as resistant
, case when max (case when status = 'susceptible' then 0 else 1 end) = 0 then 1 else 0 end as susceptible

  FROM Horse_View 
  group by id, gram_id,decade,   Class    
   ) a

    

   group by gram_id,class) b
   ) c
   order by  gram_id,class


use HorseDB
-------------Co-existing resistance in gram-positive bacteria

select case when f.Class1 = f.class2 then 'IntraClass' else 'CrossClass' end as Type,
f. Drug1, f.Class1, f.Drug2, f.Class2, f.cnt as Before2010,g.cnt as After2010

from 
(SELECT   a.Gram_id, a.drug as Drug1, a.Class as Class1, b.drug as Drug2 , b.class  as Class2,count(*) as cnt
  FROM [Horse_view] a
  inner join
  [Horse_view] b
  on a.id = b.id
  and  a.Drug > b.drug and a.Status <> 'susceptible' and b.Status <> 'susceptible'
  where  a.Gram_id = 'Positive'
  and a.decade = '2000-2009'
  group by a.Gram_id,a.Class, a.drug, b.class , b.drug
  ) f
  inner join
  (SELECT   a.Gram_id, a.drug as Drug1, a.Class as Class1, b.drug as Drug2 , b.class  as Class2,count(*) as cnt
  FROM [Horse_view] a
  inner join
  [Horse_view] b
  on a.id = b.id
  and  a.Drug > b.drug and a.Status <> 'susceptible' and b.Status <> 'susceptible'
  where  a.Gram_id = 'Positive'
  and a.decade = '2010-2020'
  group by a.Gram_id,a.Class, a.drug, b.class , b.drug
  ) g
  on f.Drug1 = g.Drug1 and f.Drug2 = g.Drug2
  order by  f.cnt desc, g.cnt desc, f.drug1, f.drug2

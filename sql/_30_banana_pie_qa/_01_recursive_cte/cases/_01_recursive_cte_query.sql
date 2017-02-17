with 
DataSet 
as 
( 
  select  'A' as node, null as parent union all 
  select  'B' as node, 'A' as parent union all 
  select  'C' as node, 'B' as parent union all 
  select  'D' as node, 'C' as parent 
), 
Hierarchy( node, parent, level1, path ) 
as 
( 
  select  DataSet.node, 
          DataSet.parent, 
          1 as level1, 
          ' ? ' || DataSet.node as path 
  from     DataSet 
  where    DataSet.parent is null 
  union all 
  select  DataSet.node, 
          DataSet.parent, 
          Hierarchy.level1 + 1 as level1, 
          Hierarchy.path || ' ? ' || DataSet.node as path 
  from    Hierarchy 
  join    DataSet 
  on      DataSet.parent = Hierarchy.node 
) 
select * from Hierarchy order by 1,2,3,4;


with colors(bag,color) as 
(values('bag1','blue'),('bag1','red'),('bag2','green'),('bag2','yellow'),('bag1','yellow')) 
   , bags (bag, colors, last1) as ( 
       select  bag , min(color) as colors, min(color) as last1 from colors 
group by bag 
           union all 
       select b.bag, colors ||' - ' ||  color  ,  color  from bags b , 
colors l 
            where b.bag=l.bag and l.color=( 
            select min(color) from colors as x where b.bag=x.bag and 
b.last1<x.color) 
           ) 
     select bag, max(colors) as colors from bags group by bag order by 1,2; 

with 
DataSet 
as 
( 
  select 'bag1' as bag, 'blue' as color union all 
  select 'bag1' as bag, 'red' as color union all 
  select 'bag1' as bag, 'yellow' as color union all 
  select 'bag2' as bag, 'green' as color union all 
  select 'bag2' as bag, 'yellow' as color 
) 
select    DataSet.bag as bag, 
          GROUP_CONCAT( DataSet.color||' - ' ) as colors 
from      DataSet 
group by  DataSet.bag  order by  DataSet.bag; 



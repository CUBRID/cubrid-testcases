drop table if exists foo;
drop view if exists v1;

create table foo (i int , j int);
insert into foo values (1,1) , (2,2), (3,3);
create view v1 as select i i, j j, i+j k from foo order by 1;

-- CBRD-22413
select foo.* , v1.* , jt.*
from foo, v1, json_table(
 '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
 '$[*]' COLUMNS(
  a INT PATH '$.a',
  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
 )
  ) AS jt order by 7,6 desc,5,4,3,2,1 limit 10
;

select count(foo.i), group_concat(unique jt.a), jt.b
from foo, v1, json_table(
 '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
 '$[*]' COLUMNS(
  a INT PATH '$.a',
  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
 )
  ) AS jt group by b 
order by b;

-- CBRD-22437
select count (v1.j), group_concat(unique jt.k), jt.b
from foo, v1, json_table(
 '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
 '$[*]' COLUMNS(
  a INT PATH '$.a',
  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
 )
  ) AS jt group by b 
order by b;

select count (v1.j), group_concat(unique k), jt.b
from foo, v1, json_table(
 '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
 '$[*]' COLUMNS(
  a INT PATH '$.a',
  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
 )
  ) AS jt group by b 
order by b;

select foo.* , v1.* , jt.*
from foo, v1, json_table(
 '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]',
 '$[*]' COLUMNS(
  a INT PATH '$.a',
  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$')
 )
  ) AS jt
where a=foo.i order by 1,2,3,4,5,6,7;

select * from foo  
union all 
select j,k from v1 
union all 
select * from json_table(
  '[ {"a": 1, "b": [11,111]}, {"a": 2, "b": [22,222]}, {"a":3}]', '$[*]' 
  COLUMNS( a INT PATH '$.a',  NESTED PATH '$.b[*]' COLUMNS (b INT PATH '$') 
)) AS jt order by 1,2;

drop table if exists foo;
drop view if exists v1;

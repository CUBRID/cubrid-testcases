drop if exists setA,setB;
create class setA
(i	integer unique,
 set1   set(setA),
 mset2  multiset(integer),
 seq3   sequence(smallint));
grant all on setA to public;
create class setB
(i	integer unique,
 set1   set(setA),
 mset2  multiset(integer),
 seq3   sequence(smallint));
grant all on setB to public;
insert into setA values (-3,  NULL ,  NULL ,  NULL ) to a_3;
insert into setA values (-2, {NULL}, {NULL}, {NULL}) to a_2;
insert into setA values (-1, {}, {}, {})             to a_1;
insert into setA values (0, {a_1}, {0}, {0})         to a0;
insert into setA (with recursive cte as 
(select i+1, set1+{a0}+set1, mset2+{1}+mset2, seq3+sequence{1}+seq3 
from setA where i = 0 ) select * from cte) to a1;
insert into setA(with recursive cte as
(select i+1, set1+{a1}+set1, mset2+{2}+mset2, seq3+sequence{2}+seq3 
from setA where i = 1 ) select * from cte) to a2;
insert into setA(with recursive cte as
(select i+1, set1+{a2}+set1, mset2+{3}+mset2, seq3+sequence{3}+seq3 
from setA where i = 2 ) select * from cte) to a3;
insert into setA(with recursive cte as
(select i+1, set1+{a3}+set1, mset2+{4}+mset2, seq3+sequence{4}+seq3 
from setA where i = 3 ) select * from cte) to a4;
insert into setA(with recursive cte as
(select i+1, set1+{a4}+set1, mset2+{5}+mset2, seq3+sequence{5}+seq3 
from setA where i = 4 ) select * from cte) to a5;
insert into setA(with recursive cte as
(select i+1, set1+{a5}+set1, mset2+{6}+mset2, seq3+sequence{6}+seq3 
from setA where i = 5 ) select * from cte) to a6;
insert into setA(with recursive cte as
(select i+1, set1+{a6}+set1, mset2+{7}+mset2, seq3+sequence{7}+seq3 
from setA where i = 6 ) select * from cte) to a7;
insert into setA (with recursive cte as
(select i+1, set1+{a7}+set1, mset2+{8}+mset2, seq3+sequence{8}+seq3 
from setA where i = 7 ) select * from cte) to a8;
insert into setA (with recursive cte as
(select i+1, set1+{a8}+set1, mset2+{9}+mset2, seq3+sequence{9}+seq3 
from setA where i = 8 ) select * from cte) to a9;
insert into setA (with recursive cte as
(select i+1, set1+{a9}+set1, mset2+{10}+mset2, seq3+sequence{10}+seq3 
from setA where i = 9 ) select * from cte) to a10;
insert into setB (with recursive setA as (select * from setA) select * from setA);
insert into setA ( with recursive cte as
(select i+1, set1+{NULL}, mset2+{NULL}, seq3+sequence{NULL}
from setA where i = 10 ) select * from cte) to a11;
select * from setA order by 1 limit 9 ;
select * from setB order by 1 limit 9 ;
drop if exists setA,setB; 

create table z1 (a int);
insert into z1 values (1);
insert into z1 values (3);
insert into z1 values (5);


select a,
ROW_NUMBER() over(PARTITION BY rownum ORDER BY a) c11
from z1 order by a;


select a,
ROW_NUMBER() over(PARTITION BY rownum ORDER BY a) c11,
ROW_NUMBER() over(PARTITION BY rownum ORDER BY a) c12
from z1 order by a;


select a,
ROW_NUMBER()over(PARTITION BY rownum ORDER BY a) c11,
ROW_NUMBER()over(PARTITION BY rownum ORDER BY a) c12,
ROW_NUMBER()over(PARTITION BY rownum ORDER BY a) c13
from z1 order by a;

drop table z1;
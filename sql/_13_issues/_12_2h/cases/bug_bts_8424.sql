--TEST: [Analytic Functions] unexpected NULL values occur when ROW_NUMBER() is used twice and in a expression clause


drop table if exists z1;

create table z1 (a int, b int);

insert into z1 values (1,1);
insert into z1 values (1,2);

select a, b, 
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc)) c11,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc)) c12 
from z1 order by a, b desc;

select a, b, 
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))+0 c11,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))+0 c12 
from z1 order by a, b desc;

select a, b,                 
(rank() over(PARTITION BY a ORDER BY b desc))+0 c11,
(dense_rank() over(PARTITION BY a ORDER BY b desc))+0 c12, 
(avg(b) over(PARTITION BY a ORDER BY b desc))+0 c13
from z1 order by a, b desc;

select a, b,                 
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))*20 c11,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))*20 c12,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))/1 c13,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))/1 c14
from z1 order by a, b desc;

create view v as
select a, b,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))*20 c11,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))*20 c12,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))/1 c13,
(ROW_NUMBER() over(PARTITION BY a ORDER BY b desc))/1 c14
from z1 order by a, b desc;
select * from v order by 2 desc;

drop view v;
drop table z1;




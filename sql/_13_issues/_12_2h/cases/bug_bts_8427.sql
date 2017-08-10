--TEST: [Analytic Functions] a VIEW which contains ROW_NUMBER() function is created successfully, but fail to query


drop table if exists z1;


create table z1 (a int, b int);
insert into z1 values (1,1);
insert into z1 values (2,1);
insert into z1 values (3,2);

create view v as select a, b, ROW_NUMBER() over(PARTITION BY a ORDER BY b asc) c11 from z1;
select * from v order by 1;
drop view v;

--CUBRID BUG: CUBRIDSUS-8888
--create view v as select a, b, (select rank() over(order by a) as c from z1) c from z1;
--select * from v order by 1;
--drop view v;

create view v as select a, b, (select rank() over(order by a) as c from z1 where b=2) c from z1;
select * from v order by 1;
drop view v;

create view v as select * from (select a, b, ROW_NUMBER() over(PARTITION BY a ORDER BY b asc) c from z1) t;
select * from v order by 1;
drop view v;

drop table z1;

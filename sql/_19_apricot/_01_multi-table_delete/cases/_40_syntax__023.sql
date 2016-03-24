--SERVER
create table t1 (i int);
insert into t1 values (1), (2), (3), (4), (5), (6);

create table t2 (i int);
insert into t2 values (2), (3), (4), (5), (6), (7);

delete t1 from (select * from t2 as t1 where t1.i < 6) a inner join t1 on t1.i = a.i where t1.i > 2 ;
select  * from t1 order by 1;
select  * from t2 order by 1;

drop class t1;
drop class t2;
--SERVER
create table t (i int);
insert into t values (1), (2), (3), (4), (5);

delete from t as t1 where i > 2;
select * from t order by 1;

drop table t;
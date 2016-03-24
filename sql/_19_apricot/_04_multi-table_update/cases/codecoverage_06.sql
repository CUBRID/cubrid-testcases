--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 select i + 2 from t1;

update (t1, t2) tt inner join (select * from t2 where i= 5) t on tt.i=t.i set tt.i=3;
select * from t1 order by 1;
select * from t2 order by 1;

update (t1, t2) tt inner join (select * from t2 where i= 5) t on tt.i=t.i set i=3;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;
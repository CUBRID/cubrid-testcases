create table t1 (i1 integer);

insert into t1 values (1);

select * from t1;

rename t3 to t1, t1 to t3;

select * from t1;

drop table t1;
drop table t3;

create table t1(a int);
insert into t1 values (1);
insert into t1 values (2);
insert into t1 values (3);

select * from t1 order by 1+2 desc;
select a from t1 order by 1+2 desc;


drop table t1;


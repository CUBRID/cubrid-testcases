drop table if exists t1, t2, t3;

create table t1(a varchar(100), b int);
create table t2(a varchar(100), b int);
insert into t1 values ('A', 1);
insert into t2 values ('B', 2);

select * from (t1, t2) order by 1;

--test: csql crashed for below
select json_object(a, b) from (t1, t2) order by 1;
select json_object(a, b) from (t1, t2, t1,t2) order by 1;
select json_object(a, b) from t1 union select json_object(a, b) from t2 order by 1;

create table t3 as select json_object(a, b) a , json_object(a, b) b from (t1, t2) order by 1;
select json_object(a, b) from (t1, t2, t3) order by 1;

drop table if exists t1, t2, t3;

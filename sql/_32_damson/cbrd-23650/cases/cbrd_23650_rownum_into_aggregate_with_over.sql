drop table if exists t1;

create table t1 (a int primary key, b int);

insert into t1 values (1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (6, 2), (7, 2), (8, 2);

select rownum, sum(rownum) over (partition by a) from t1;
select sum(rownum) over (partition by b) from t1;
select count(*) over () from t1 limit 2;
select rownum, sum(rownum) over (partition by a) from t1;
select sum(rownum) over (partition by b) from t1;
select count(*) over () from t1 limit 2;

drop table t1;

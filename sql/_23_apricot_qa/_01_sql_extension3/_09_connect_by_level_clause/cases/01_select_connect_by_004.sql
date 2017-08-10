drop table if exists t;
create table t (a int, b int);

insert into t values (1,1);

select *,level from t connect by level < 10 or (prior a = a and level < 5) order by 1,2;

select *,level from t connect by level in (1,2,3,5,6) order by 1,2;

select *,level from t connect by level in (1,2,3,1,2,3,5,6) order by 1,2;

select *,level from t connect by level in (1,2,3,4,5,6) order by 1,2;

select *,level from t connect by level between 1 and 10 order by 1,2;

select *,level from t connect by level between 1 and -10 order by 1,2;

drop table if exists t;
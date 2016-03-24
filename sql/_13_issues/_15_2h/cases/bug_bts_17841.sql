drop table if exists t1;
drop table if exists t2;
create table t1(a int, b string);
create table t2(a int, b string);
 
insert into t1 values(1, rpad('a', 30000));
insert into t2 values(2, rpad('a', 30000));
 
select count(*) from (select a,b from t1 union all select a,b from t2 order by a) a;

select count(*) from
        (select a,b from t1
         union all select a,b from t2
         union all select a,b from t1
         union all select a,b from t2
         union all select a,b from t1
         union all select a,b from t2
         union all select a,b from t1
         union all select a,b from t2
        ) a;

drop table if exists t1;
drop table if exists t2;

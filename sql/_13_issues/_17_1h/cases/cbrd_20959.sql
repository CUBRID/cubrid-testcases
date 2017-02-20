drop table if exists t1;
create table t1 (id int primary key, a int, b int);
insert into t1 values (1,1,2);
insert into t1 values (2,1,1);
insert into t1 values (3,3,5);
insert into t1 values (4,3,1);

select id, a, b, (
   with c1 as (
      select id,a,b from t1
   )
   select max(b) from c1 where c1.a=t1.a
) max_b from t1 order by id, a, b, max_b;

drop table if exists t1;

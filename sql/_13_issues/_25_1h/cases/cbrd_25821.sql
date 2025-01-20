-- This issue verified CBRD-25821
-- This issue originated from CBRD-25238.
-- fix : The fix ensures that the mq_mark_location() function does not incorrectly assign locations to nodes inside subqueries.

drop table if exists t1, t2, t3, t4;
create table t1 (c1 int, c2 int);
create table t2 (c1 int, c2 int);
create table t3 (c1 int, c2 int);
create table t4 (c1 int, c2 int);

insert into t1 values(1,1),(2,2),(3,3);
insert into t2 values(1,1),(2,2),(3,3);
insert into t3 values(1,1),(2,2),(3,3);
insert into t4 values(1,1),(2,2),(3,3);

select /*+ recompile */ *
from
  (
    select
      (select max (b.c2) from t2 b where b.c1 = a.c1)
    from t1 a
  ) ab (max_c2)
  inner join t3 c on ab.max_c2 = c.c1
  left outer join t4 d on c.c1 = d.c1;

drop table if exists t1, t2, t3, t4;

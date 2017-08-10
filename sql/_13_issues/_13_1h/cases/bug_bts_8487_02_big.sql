-- set up scenario
drop table if exists t;
drop table if exists a;

create table a (i int);
insert into a values (1);
insert into a values (2);
insert into a values (3);
insert into a values (4);
insert into a values (5);
insert into a values (6);
insert into a values (7);
insert into a values (8);
insert into a values (9);
insert into a values (0);

create table t (o1 int, o2 int, p1 int, p2 int, v int);
insert into t select rownum, rownum, a1.i, a1.i, a1.i / 3 from a a1, a a2, a a3, a a4;

-- same grouping and ordering
select count(*) from (select
  sum(v)         over (partition by p1 order by o1) A,
  avg(v)         over (partition by p1 order by o1) B,
  stddev_pop(v)  over (partition by p1 order by o1) C,
  stddev_samp(v) over (partition by p1 order by o1) D,
  var_pop(v)     over (partition by p1 order by o1) E,
  var_samp(v)    over (partition by p1 order by o1) F,
  min(v)         over (partition by p1 order by o1) G,
  max(v)         over (partition by p1 order by o1) H,
  lead(v, 1, -1) over (partition by p1 order by o1) I,
  lag(v, 1, -1)  over (partition by p1 order by o1) J,
  ntile(3)       over (partition by p1 order by o1) K
from t order by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);

-- cleanup
drop table t;
drop table a;

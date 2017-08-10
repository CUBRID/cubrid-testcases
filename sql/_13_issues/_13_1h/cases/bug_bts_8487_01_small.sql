-- set up scenario
drop table if exists t;
create table t (v int, p1 int, o1 int, p2 int, o2 int);
insert into t values (1, 1, 3, 1, 1);
insert into t values (2, 1, 2, 1, 2);
insert into t values (3, 1, 1, 1, 3);
insert into t values (4, 2, 3, 1, 4);
insert into t values (5, 2, 2, 2, 1);
insert into t values (6, 2, 1, 2, 2);
insert into t values (7, 3, 3, 2, 3);
insert into t values (8, 3, 2, 2, 4);
insert into t values (9, 3, 1, 3, 1);

-- interwined, should group
select
  sum(v)         over (partition by p1 order by o1) A,
  trunc(avg(v)         over (partition by p2 order by o2), 2) B,
  trunc(stddev_pop(v)  over (partition by p1 order by o1), 2) C,
  trunc(stddev_samp(v) over (partition by p2 order by o2), 2) D,
  trunc(var_pop(v)     over (partition by p1 order by o1), 2) E,
  trunc(var_samp(v)    over (partition by p2 order by o2), 2) F,
  min(v)         over (partition by p1 order by o1) G,
  max(v)         over (partition by p2 order by o2) H
from t order by 1, 2, 3, 4, 5, 6, 7, 8;

-- interwined, should group
select
  lead(v, 1, -2) over (partition by p1 order by o1) A,
  lead(v, 1, -2) over (partition by p2 order by o2) B,
  lag(v, 1, -1 ) over (partition by p1 order by o1) C,
  lag(v, 1, -1)  over (partition by p2 order by o2) D
from t order by 1, 2, 3, 4;

-- interwined, should not group
select
  sum(v)         over (partition by p1 order by o1) A,
  sum(v)         over (partition by p2 order by o2) B,
  lead(v, 1, -1) over (partition by p1 order by o1) C,
  lag(v, 1, -1)  over (partition by p2 order by o2) D,
  row_number()   over (partition by p1 order by o1) E,
  row_number()   over (partition by p2 order by o2) F
from t order by 1, 2, 3, 4, 5, 6;

-- same grouping and ordering
select
  sum(v)         over (partition by p1 order by o1) A,
  trunc(avg(v)         over (partition by p1 order by o1), 2) B,
  trunc(stddev_pop(v)  over (partition by p1 order by o1), 2) C,
  trunc(stddev_samp(v) over (partition by p1 order by o1), 2) D,
  trunc(var_pop(v)     over (partition by p1 order by o1), 2) E,
  trunc(var_samp(v)    over (partition by p1 order by o1), 2) F,
  min(v)         over (partition by p1 order by o1) G,
  max(v)         over (partition by p1 order by o1) H,
  lead(v, 1, -1) over (partition by p1 order by o1) I,
  lag(v, 1, -1)  over (partition by p1 order by o1) J,
  ntile(3)       over (partition by p1 order by o1) K
from t order by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11;

-- cleanup
drop table t;

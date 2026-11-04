-- CBRD-27683: the analytic functions write their rows to the output as they are sorted, without the intermediate,
-- sort key value and partition header lists. ROW_NUMBER, RANK and DENSE_RANK at once, the aggregates, FIRST_VALUE and
-- LAST_VALUE when the sort key group ends, NTILE, CUME_DIST and PERCENT_RANK when the partition ends.
-- The results must stay as before.

drop table if exists t27683;
create table t27683 (id int primary key, p int, o int, s varchar(10));
insert into t27683 select rownum, case when mod(rownum, 7) = 0 then null else mod(rownum, 3) end,
  case when mod(rownum, 5) = 0 then null else mod(rownum * 7, 4) end, 's' || mod(rownum, 2)
  from db_root connect by level <= 30;

-- Case 1: each function alone, with ties, NULL partition keys and NULL sort keys
select id, p, o, row_number () over (partition by p order by o, id) as rn from t27683 order by id;
select id, p, o, rank () over (partition by p order by o) as rk from t27683 order by id;
select id, p, o, dense_rank () over (partition by p order by o desc) as dr from t27683 order by id;

-- Case 2: the three functions in one window, and in two windows
select id, p, o, row_number () over (partition by p order by o, id) as rn, rank () over (partition by p order by o, id) as rk,
       dense_rank () over (partition by p order by o, id) as dr
  from t27683 order by id;
select id, p, s, o, rank () over (partition by p order by o) as rk, dense_rank () over (partition by s order by o nulls first) as dr
  from t27683 order by id;

-- Case 2b: the three functions over one sort key with ties, listed by the row number. A row's place among its peers
-- is not fixed, but the sort key and the ranks at each row number are.
select p, o, rn, rk, dr from (select p, o, row_number () over (partition by p order by o) as rn,
       rank () over (partition by p order by o) as rk, dense_rank () over (partition by p order by o) as dr from t27683) x
  order by p, rn;

-- Case 3: no PARTITION BY, and an expression over the functions
select id, o, rank () over (order by o) as rk, dense_rank () over (order by o) * 10 + 1 as dr10 from t27683 order by id;

-- Case 4: a ranking window next to another function's window, and next to it in the same window
select id, p, o, rank () over (partition by p order by o) as rk, sum (o) over (partition by s) as so from t27683 order by id;
select id, p, o, rank () over (partition by p order by o) as rk, count (*) over (partition by p order by o) as cnt
  from t27683 order by id;

-- Case 5: ROWNUM selected with the functions, and ROWNUM in WHERE
select rownum, id, p, o, rank () over (partition by p order by o, id) as rk from t27683;
select rownum, id, rk from (select id, rank () over (partition by p order by o, id) as rk from t27683 order by id) x order by 1;
select count (*), max (rk) from (select id, rank () over (partition by p order by o) as rk from t27683 where rownum <= 12) x;

-- Case 6: the outer query filters on the function, as a top-N per partition
select p, id, o, rn from (select p, id, o, row_number () over (partition by p order by o desc, id) as rn from t27683) x
  where rn <= 2 order by p, rn;

-- Case 7: no rows, and a GROUP BY under the functions
select id, rank () over (order by o) from t27683 where id < 0;
select p, count (*) as c, rank () over (order by count (*) desc) as rk, dense_rank () over (order by count (*)) as dr
  from t27683 group by p order by p;

-- Case 8: running aggregates over sort key groups with ties, and aggregates over the partition
select id, p, o, sum (o) over (partition by p order by o) as so, count (*) over (partition by p order by o) as c,
       avg (o) over (partition by p order by o) as ao, min (s) over (partition by p order by o) as mi
  from t27683 order by id;
select id, p, sum (o) over (partition by p) as so, count (o) over (partition by p) as co, max (o) over () as mx
  from t27683 order by id;
select id, p, o, stddev_pop (o) over (partition by p order by o) as sd, var_samp (o) over (partition by p) as vs
  from t27683 order by id;
select id, p, o, sum (distinct o) over (partition by p order by o) as sdo, count (distinct s) over (partition by p) as cds
  from t27683 order by id;

-- Case 9: FIRST_VALUE and LAST_VALUE, with IGNORE NULLS
select id, p, o, first_value (o) over (partition by p order by id) as fv, last_value (o) over (partition by p order by id) as lv
  from t27683 order by id;
select id, p, o, first_value (o) ignore nulls over (partition by p order by id) as fvn,
       last_value (o) ignore nulls over (partition by p order by id) as lvn
  from t27683 order by id;

-- Case 10: NTILE, CUME_DIST and PERCENT_RANK, which need the partition's row count
select id, p, o, ntile (3) over (partition by p order by o, id) as nt, cume_dist () over (partition by p order by o) as cd,
       percent_rank () over (partition by p order by o) as pr
  from t27683 order by id;
select id, o, ntile (4) over (order by o, id) as nt, cume_dist () over (order by o) as cd from t27683 order by id;

-- Case 11: the functions of one window together, and next to LAG, which keeps the existing path
select id, p, o, row_number () over (partition by p order by o, id) as rn, sum (o) over (partition by p order by o, id) as so,
       first_value (s) over (partition by p order by o, id) as fs
  from t27683 order by id;
select id, p, o, sum (o) over (partition by p) as so, ntile (2) over (partition by p order by o, id) as nt,
       cume_dist () over (partition by p order by o) as cd
  from t27683 order by id;
select id, p, o, sum (o) over (partition by p order by o, id) as so, lag (o) over (partition by p order by o, id) as lg
  from t27683 order by id;

-- Case 12: ROWNUM with a function that waits for its sort key group
select rownum, id, p, o, sum (o) over (partition by p order by o, id) as so from t27683;
select count (*), max (so) from (select id, sum (o) over (partition by p order by o, id) as so from t27683 where rownum <= 12) x;

drop table t27683;

-- Case 13: a partition larger than what the waiting rows keep in memory
drop table if exists t27683b;
create table t27683b (id int primary key, g int, h varchar(40));
insert into t27683b select rownum, mod (rownum, 2), md5 (to_char (rownum)) from db_root connect by level <= 40000;
select count (*), min (c), max (c), min (s), max (s), count (distinct r) from (select id, count (*) over () as c,
       sum (id) over (partition by g) as s, rank () over (partition by g order by h) as r from t27683b) x;
select count (*), min (cd), max (cd), sum (nt) from (select id, cume_dist () over (order by h) as cd,
       ntile (5) over (order by h) as nt from t27683b) x;
drop table t27683b;

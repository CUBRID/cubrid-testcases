-- CBRD-27683: ROW_NUMBER, RANK and DENSE_RANK write their rows to the output as they are sorted
-- (no intermediate, sort key value and partition header lists). The results must stay as before.

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

drop table t27683;

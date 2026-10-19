/**
 *  This test case verifies CBRD-27684 : Carry whole tuples in sort records to avoid re-fetching originals after sort
 *  A sort record carries a short tuple (128 bytes or less) and points back to a longer one.
 *  Sorted results must be the same for short, long and overflow tuples mixed in one sort,
 *  with NULL keys and ties, for analytic functions, ORDER BY and GROUP BY.
 */

drop table if exists t27684;
create table t27684 (id int primary key, g int, k varchar(10), v varchar(30000));

-- k: NULL for every 11th row, many ties otherwise
-- v: overflow tuple for every 50th row, longer than 128 bytes for every 3rd row, NULL for every 13th row, short otherwise
insert into t27684
  select rownum, mod(rownum, 5),
         case when mod(rownum, 11) = 0 then null else lpad(to_char(mod(rownum * 37, 101)), 5, '0') end,
         case when mod(rownum, 50) = 0 then repeat('x', 17000 + rownum)
              when mod(rownum, 3) = 0 then repeat('y', 200 + mod(rownum, 400))
              when mod(rownum, 13) = 0 then null
              else 'v' || rownum end
  from db_class a, db_class b, db_class c limit 3000;

evaluate '1. analytic functions';
select id, g, k, length(v) lv,
       row_number() over (partition by g order by k, id) rn,
       rank() over (partition by g order by k) rk,
       sum(length(v)) over (partition by g order by k, id) s,
       lag(id) over (partition by g order by k, id) lg,
       first_value(length(v)) over (partition by g order by k desc, id) fv
from t27684 where mod(id, 97) = 0 or id between 1490 and 1510 order by id;

select g, k, count(*), sum(rn), max(lv), min(fv)
from (select g, k, length(v) lv, row_number() over (partition by g order by k nulls first, id desc) rn,
             first_value(substr(v, 1, 3)) over (partition by g, k order by id) fv
      from t27684) t
where rn <= 3 or k is null
group by g, k order by g, k;

select id, k, median(id) over (partition by g) md, count(*) over (partition by k) c from t27684 where mod(id, 211) = 0 order by id;

evaluate '2. ORDER BY';
select id, g, k, length(v), substr(v, 1, 5) from t27684 order by k desc, g, id limit 40;
select id, g, k, length(v), substr(v, 1, 5) from t27684 order by k nulls first, length(v) desc, id limit 30;
select orderby_num(), id, k, length(v) from t27684 order by k, id for orderby_num() between 1495 and 1520;
select id, k, length(v) from (select id, k, v from t27684 order by k, id desc limit 3000) t where mod(id, 150) = 0 order by k, id desc;

evaluate '3. GROUP BY';
select /*+ NO_HASH_AGGREGATE */ k, count(*), sum(length(v)), max(length(v)), min(id), max(substr(v, 1, 3))
from t27684 group by k order by k;
select /*+ NO_HASH_AGGREGATE */ g, count(*), sum(id), max(length(v)) from t27684 group by g, k with rollup having g is null or k is null;
select k, count(*), sum(id), max(length(v)), min(substr(v, 1, 3)) from t27684 group by k order by k;

drop table t27684;

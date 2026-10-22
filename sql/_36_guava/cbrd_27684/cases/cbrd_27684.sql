/**
 *  This test case verifies CBRD-27684 : Carry whole tuples in sort records to avoid re-fetching originals after sort
 *  A sort record carries a short tuple (256 bytes or less) when the sorted tuples are scattered over the input
 *  (decided on a sample of the first 8K input tuples), and points back to a longer one.
 *  Sorted results must be the same for short, long and overflow tuples mixed in one sort,
 *  with NULL keys and ties, for analytic functions, ORDER BY and GROUP BY.
 */

drop table if exists t27684;
drop table if exists t27684_o;
create table t27684 (id int primary key, g int, k varchar(10), v varchar(30000));

-- k: NULL for every 11th row, many ties otherwise, in no relation to the row order
-- v: overflow tuple for every 2000th row, 200 to 600 bytes (both sides of 256) for every 3rd row, NULL for every 13th row, short otherwise
insert into t27684
  select rownum, mod(rownum, 5),
         case when mod(rownum, 11) = 0 then null else lpad(to_char(mod(rownum * 37, 101)), 5, '0') end,
         case when mod(rownum, 2000) = 0 then repeat('x', 17000 + rownum / 100)
              when mod(rownum, 3) = 0 then repeat('y', 200 + mod(rownum, 400))
              when mod(rownum, 13) = 0 then null
              else 'v' || rownum end
  from db_class a, db_class b, db_class c limit 20000;

evaluate '1. analytic functions over the whole table';
select * from (select id, g, k, length(v) lv,
                      row_number() over (partition by g order by k, id) rn,
                      rank() over (partition by g order by k) rk,
                      sum(length(v)) over (partition by g order by k, id) s,
                      lag(id) over (partition by g order by k, id) lg,
                      first_value(length(v)) over (partition by g order by k desc, id) fv
               from t27684) t
where mod(id, 997) = 0 or id between 14990 and 15010 order by id;

select g, k, count(*), sum(rn), max(lv), min(fv)
from (select g, k, length(v) lv, row_number() over (partition by g order by k nulls first, id desc) rn,
             first_value(substr(v, 1, 3)) over (partition by g, k order by id) fv
      from t27684) t
where rn <= 3 or k is null
group by g, k order by g, k;

select * from (select id, k, median(id) over (partition by g) md, count(*) over (partition by k) c from t27684) t
where mod(id, 1499) = 0 order by id;

evaluate '2. ORDER BY over the whole table';
create table t27684_o (seq int auto_increment primary key, id int, g int, k varchar(10), lv int, pv varchar(5));
insert into t27684_o (id, g, k, lv, pv) select id, g, k, length(v), substr(v, 1, 5) from t27684 order by k desc, g, id;
select * from t27684_o where mod(seq, 499) = 0 or seq between 9990 and 10010 order by seq;
select id, g, k, length(v), substr(v, 1, 5) from t27684 order by k nulls first, length(v) desc, id limit 30;
select orderby_num(), id, k, length(v) from t27684 order by k, id for orderby_num() between 9995 and 10020;
select id, k, length(v) from (select id, k, v from t27684 order by k, id desc limit 20000) t where mod(id, 1000) = 0 order by k, id desc;

evaluate '3. GROUP BY over the whole table';
select /*+ NO_HASH_AGGREGATE */ k, count(*), sum(length(v)), max(length(v)), min(id), max(substr(v, 1, 3))
from t27684 group by k order by k;
select /*+ NO_HASH_AGGREGATE */ g, count(*), sum(id), max(length(v)) from t27684 group by g, k with rollup having g is null or k is null;
select k, count(*), sum(id), max(length(v)), min(substr(v, 1, 3)) from t27684 group by k order by k;

drop table t27684_o;
drop table t27684;

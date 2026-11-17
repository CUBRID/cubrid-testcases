/**
 *  This test case verifies CBRD-27787 : Keep parallel sort with a serial put from running slower than a serial sort
 *  on a small data buffer
 *  ORDER BY with LIMIT, analytic functions and GROUP BY sort in parallel but the main thread puts the sorted tuples
 *  alone. The main thread now merges the worker runs (down to 4 by the merge queue when there are more workers)
 *  and puts each tuple as it is merged instead of writing one merged run and reading it back, and a merge discards
 *  each run page once it has read the page so that the run pages do not push the input pages out of the buffer.
 *  Under CTP every sort with 2 pages or more is parallel. Each query runs serially (PARALLEL(1)), with 4 workers
 *  (merged on the main thread directly) and with 8 and 16 workers (merge queue first) and must return the same rows.
 *  The pad is a chain of SHA-2 digests so that the sort input is not compressed and spans many pages, and the
 *  outer queries aggregate it so that it is not pruned from the sort input. DISTINCT with ORDER BY and LIMIT runs
 *  the duplicate-eliminating merge on the main thread.
 *  Section 4 traces one query of each kind serially and with 8 workers so that the parallel sort is visible.
 */


drop table if exists t27787;
create table t27787 (id int primary key, g int, k varchar(10), v int, pad varchar(400));

-- k: NULL for every 11th row, many ties otherwise, in no relation to the row order
insert into t27787
  select rownum, mod(rownum, 7),
         case when mod(rownum, 11) = 0 then null else lpad(to_char(mod(rownum * 37, 211)), 4, '0') end,
         mod(rownum * 7919, 100003),
         sha2(rownum, 512) || sha2(rownum + 1, 512) || sha2(rownum + 2, 256)
  from db_class a, db_class b, db_class c limit 30000;


evaluate '1. ORDER BY with LIMIT';
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), max(id), sum(length(pad)) from (select id, pad, rownum rn from (select /*+ PARALLEL(1) */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) s) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), max(id), sum(length(pad)) from (select id, pad, rownum rn from (select /*+ PARALLEL(4) */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) s) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), max(id), sum(length(pad)) from (select id, pad, rownum rn from (select /*+ PARALLEL(8) */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) s) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), max(id), sum(length(pad)) from (select id, pad, rownum rn from (select /*+ PARALLEL(16) */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) s) t;
select count(*), sum(id), min(id), max(id), sum(length(pad)) from (select /*+ PARALLEL(1) */ id, pad from t27787 order by k nulls first, v desc, id limit 1000, 12000) t;
select count(*), sum(id), min(id), max(id), sum(length(pad)) from (select /*+ PARALLEL(4) */ id, pad from t27787 order by k nulls first, v desc, id limit 1000, 12000) t;
select count(*), sum(id), min(id), max(id), sum(length(pad)) from (select /*+ PARALLEL(8) */ id, pad from t27787 order by k nulls first, v desc, id limit 1000, 12000) t;
select count(*), sum(id), min(id), max(id), sum(length(pad)) from (select /*+ PARALLEL(16) */ id, pad from t27787 order by k nulls first, v desc, id limit 1000, 12000) t;
select * from (select /*+ PARALLEL(1) */ id, k, v, length(pad) lp from t27787 order by k, v, id limit 20, 5) t order by 1;
select * from (select /*+ PARALLEL(4) */ id, k, v, length(pad) lp from t27787 order by k, v, id limit 20, 5) t order by 1;
select * from (select /*+ PARALLEL(8) */ id, k, v, length(pad) lp from t27787 order by k, v, id limit 20, 5) t order by 1;
select * from (select /*+ PARALLEL(16) */ id, k, v, length(pad) lp from t27787 order by k, v, id limit 20, 5) t order by 1;
select count(*), sum(mod(cast(id as bigint) * o, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(1) */ id, orderby_num() o, pad from t27787 order by k, v desc, id for orderby_num() between 100 and 25000) t;
select count(*), sum(mod(cast(id as bigint) * o, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(4) */ id, orderby_num() o, pad from t27787 order by k, v desc, id for orderby_num() between 100 and 25000) t;
select count(*), sum(mod(cast(id as bigint) * o, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(8) */ id, orderby_num() o, pad from t27787 order by k, v desc, id for orderby_num() between 100 and 25000) t;
select count(*), sum(mod(cast(id as bigint) * o, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(16) */ id, orderby_num() o, pad from t27787 order by k, v desc, id for orderby_num() between 100 and 25000) t;

evaluate '2. analytic functions';
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(mod(cast(id as bigint) * rk, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(1) */ id, row_number() over (order by k, v, id) rn, rank() over (partition by g order by k) rk, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(mod(cast(id as bigint) * rk, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(4) */ id, row_number() over (order by k, v, id) rn, rank() over (partition by g order by k) rk, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(mod(cast(id as bigint) * rk, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(8) */ id, row_number() over (order by k, v, id) rn, rank() over (partition by g order by k) rk, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(mod(cast(id as bigint) * rk, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(16) */ id, row_number() over (order by k, v, id) rn, rank() over (partition by g order by k) rk, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * lg, 1000003)), sum(cast(fv as bigint)), sum(length(pad)) from (select /*+ PARALLEL(1) */ id, lag(id) over (partition by g order by k desc, id) lg, first_value(v) over (partition by k order by id) fv, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * lg, 1000003)), sum(cast(fv as bigint)), sum(length(pad)) from (select /*+ PARALLEL(4) */ id, lag(id) over (partition by g order by k desc, id) lg, first_value(v) over (partition by k order by id) fv, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * lg, 1000003)), sum(cast(fv as bigint)), sum(length(pad)) from (select /*+ PARALLEL(8) */ id, lag(id) over (partition by g order by k desc, id) lg, first_value(v) over (partition by k order by id) fv, pad from t27787) t;
select count(*), sum(mod(cast(id as bigint) * lg, 1000003)), sum(cast(fv as bigint)), sum(length(pad)) from (select /*+ PARALLEL(16) */ id, lag(id) over (partition by g order by k desc, id) lg, first_value(v) over (partition by k order by id) fv, pad from t27787) t;

evaluate '3. GROUP BY';
select count(*), sum(c), sum(mod(cast(s as bigint) * mn, 1000003)), max(mx) from (select /*+ PARALLEL(1) NO_HASH_AGGREGATE */ k, g, count(*) c, sum(v) s, min(id) mn, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
select count(*), sum(c), sum(mod(cast(s as bigint) * mn, 1000003)), max(mx) from (select /*+ PARALLEL(4) NO_HASH_AGGREGATE */ k, g, count(*) c, sum(v) s, min(id) mn, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
select count(*), sum(c), sum(mod(cast(s as bigint) * mn, 1000003)), max(mx) from (select /*+ PARALLEL(8) NO_HASH_AGGREGATE */ k, g, count(*) c, sum(v) s, min(id) mn, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
select count(*), sum(c), sum(mod(cast(s as bigint) * mn, 1000003)), max(mx) from (select /*+ PARALLEL(16) NO_HASH_AGGREGATE */ k, g, count(*) c, sum(v) s, min(id) mn, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
select * from (select /*+ PARALLEL(1) NO_HASH_AGGREGATE */ k, count(*) c, sum(v) s, min(id) mn from t27787 group by k) t where k is null or k in ('0000', '0105', '0210') order by k;
select * from (select /*+ PARALLEL(4) NO_HASH_AGGREGATE */ k, count(*) c, sum(v) s, min(id) mn from t27787 group by k) t where k is null or k in ('0000', '0105', '0210') order by k;
select * from (select /*+ PARALLEL(8) NO_HASH_AGGREGATE */ k, count(*) c, sum(v) s, min(id) mn from t27787 group by k) t where k is null or k in ('0000', '0105', '0210') order by k;
select * from (select /*+ PARALLEL(16) NO_HASH_AGGREGATE */ k, count(*) c, sum(v) s, min(id) mn from t27787 group by k) t where k is null or k in ('0000', '0105', '0210') order by k;
select count(*), sum(length(d)) from (select /*+ PARALLEL(1) */ distinct k || substr(pad, 1, 2) d from t27787) t;
select count(*), sum(length(d)) from (select /*+ PARALLEL(4) */ distinct k || substr(pad, 1, 2) d from t27787) t;
select count(*), sum(length(d)) from (select /*+ PARALLEL(8) */ distinct k || substr(pad, 1, 2) d from t27787) t;
select count(*), sum(length(d)) from (select /*+ PARALLEL(16) */ distinct k || substr(pad, 1, 2) d from t27787) t;
select count(*), sum(mod(cast(rn as bigint) * v, 1000003)), sum(length(pad)) from (select v, pad, rownum rn from (select /*+ PARALLEL(1) */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) s) t;
select count(*), sum(mod(cast(rn as bigint) * v, 1000003)), sum(length(pad)) from (select v, pad, rownum rn from (select /*+ PARALLEL(4) */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) s) t;
select count(*), sum(mod(cast(rn as bigint) * v, 1000003)), sum(length(pad)) from (select v, pad, rownum rn from (select /*+ PARALLEL(8) */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) s) t;
select count(*), sum(mod(cast(rn as bigint) * v, 1000003)), sum(length(pad)) from (select v, pad, rownum rn from (select /*+ PARALLEL(16) */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) s) t;


-- trace: the sort line (ORDERBY / ANALYTIC / GROUPBY) shows "parallel workers" with PARALLEL(8) and not with PARALLEL(1).
--        NO_PARALLEL_SCAN keeps the scans serial so that only the sort is parallel. CTP masks the numbers.
evaluate '4. traces: serial and parallel sort';
set trace on;
select /*+ NO_PARALLEL_SCAN */ count(*), max(id), sum(length(pad)) from (select /*+ PARALLEL(1) NO_PARALLEL_SCAN */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), max(id), sum(length(pad)) from (select /*+ PARALLEL(8) NO_PARALLEL_SCAN */ id, pad from t27787 order by k desc nulls last, v, id limit 30000) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(1) NO_PARALLEL_SCAN */ id, row_number() over (order by k, v, id) rn, pad from t27787) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(mod(cast(id as bigint) * rn, 1000003)), sum(length(pad)) from (select /*+ PARALLEL(8) NO_PARALLEL_SCAN */ id, row_number() over (order by k, v, id) rn, pad from t27787) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(c), max(mx) from (select /*+ PARALLEL(1) NO_PARALLEL_SCAN NO_HASH_AGGREGATE */ k, g, count(*) c, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(c), max(mx) from (select /*+ PARALLEL(8) NO_PARALLEL_SCAN NO_HASH_AGGREGATE */ k, g, count(*) c, max(substr(pad, 1, 8)) mx from t27787 group by k, g) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(length(pad)) from (select /*+ PARALLEL(1) NO_PARALLEL_SCAN */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) t;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(length(pad)) from (select /*+ PARALLEL(8) NO_PARALLEL_SCAN */ distinct k, v, pad from t27787 order by v desc, k, pad limit 20000) t;
show trace;
set trace off;

drop table t27787;

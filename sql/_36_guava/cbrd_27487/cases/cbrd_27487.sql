/**
 *  This test case verifies CBRD-27487: when the memoize storage of an NL join inner is
 *  given up, and what it does once its memoize_memory_limit budget is used up.
 *
 *  Before, the storage was given up for the rest of the query when fewer than half of
 *  the first 1,000 probes were hits. Keys that repeat but have not come round yet look
 *  like distinct keys in that sample, so a join whose probe key took more than about
 *  630 distinct values never kept memoize. Now the hit ratio is judged only once the
 *  storage holds 60% of its budget, as the subquery cache does.
 *
 *  Before, the storage was also freed when it reached its budget. Now it keeps
 *  answering hits and only stops inserting. The entries already inserted for the key
 *  being filled at that moment are removed, so a key with several inner rows is never
 *  replayed in part.
 *
 *  CTP runs with test_mode=yes, which masks volatile trace values to '?'. The traces
 *  show whether the MEMOIZE line is there, which needs at least one hit. Every result
 *  with memoize on must equal the same query with memoize off (memoize_memory_limit=0).
 *
 *  Cases 6 and 7 depend on the order of the probes. The heap scan order is not the insert
 *  order, so their outer reads the table through a NO_MERGE derived table ordered by its
 *  primary key.
 *
 *  Coverage:
 *    Case 1:  probe key NDV 400, 800, 1200 and 2000 under the default budget, memoize kept,
 *             and NDV 1200 through an EXISTS (the match-only memo of an NL semi join inner)
 *    Case 2:  nine probe keys in ten distinct, memoize still given up
 *    Case 3:  hot keys among many distinct cold keys, the budget runs out and hits go on
 *    Case 4:  three inner rows per key, the budget runs out while keys are being filled
 *    Case 5:  Cases 3 and 4 with the outer table scanned in parallel, memoize kept in the
 *             workers
 *    Case 6:  a key with 4000 inner rows fills the budget and is taken out, leaving the
 *             storage under 60%, then misses pile up - the hit ratio is still judged and
 *             the storage is released
 *    Case 7:  hot keys then only distinct keys - after inserts stop the hit ratio falls
 *             below half and the storage is released
 */

drop table if exists small, ndv_outer, big_in, multi, skew_outer, fat_in, fat_outer, phase_outer;

create table small (col1 int primary key, col2 char(1));
insert into small select rownum, chr(65 + mod(rownum, 26)) from db_class a, db_class b, db_class c, db_class d limit 5000;

create table ndv_outer (a int primary key, k400 int, k800 int, k1200 int, k2000 int, mu int);
insert into ndv_outer
select rownum,
       mod(mod(rownum * 48271, 2147483647), 400) + 1,
       mod(mod(rownum * 48271, 2147483647), 800) + 1,
       mod(mod(rownum * 48271, 2147483647), 1200) + 1,
       mod(mod(rownum * 48271, 2147483647), 2000) + 1,
       case when mod(rownum, 10) = 0 then 1 else rownum end
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;

create table big_in (id int primary key, v int);
insert into big_in select rownum, mod(rownum, 97) from db_class a, db_class b, db_class c, db_class d, db_class e limit 110000;

create table multi (k int, v int);
insert into multi select floor((rownum - 1) / 3) + 1, mod(rownum, 1000) from db_class a, db_class b, db_class c, db_class d, db_class e limit 90000;
create index idx_multi_k on multi (k);

create table skew_outer (a int primary key, hot_cold int);
insert into skew_outer
select rownum, case when mod(rownum, 4) <> 0 then mod(rownum, 50) + 1 else 100 + rownum end
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;

-- key 999 has 4000 inner rows, keys 1 to 50 one each
create table fat_in (k int, v int);
insert into fat_in select 999, mod(rownum, 1000) from db_class a, db_class b, db_class c limit 4000;
insert into fat_in select rownum, rownum from db_class a, db_class b limit 50;
create index idx_fat_in_k on fat_in (k);

-- in primary key order: 20000 probes on the 50 hot keys, one probe on key 999, then 49999 distinct keys
-- without an inner row
create table fat_outer (a int primary key, k int);
insert into fat_outer
select rownum, case when rownum <= 20000 then mod(rownum, 50) + 1 when rownum = 20001 then 999 else 100000 + rownum end
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 70000;

-- in primary key order: 40000 probes on the 50 hot keys, then 60000 distinct keys
create table phase_outer (a int primary key, k int);
insert into phase_outer
select rownum, case when rownum <= 40000 then mod(rownum, 50) + 1 else 100000 + rownum end
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;

update statistics on small, ndv_outer, big_in, multi, skew_outer, fat_in, fat_outer, phase_outer with fullscan;

set trace on;

evaluate 'Case 1: probe key NDV 400, 800, 1200 and 2000 under the default budget, and NDV 1200 through an EXISTS semi join, memoize kept';
select /*+ recompile parallel(0) ordered use_nl */ count(*) from ndv_outer a, small s where s.col1 = a.k400;
show trace;
select /*+ recompile parallel(0) ordered use_nl */ count(*) from ndv_outer a, small s where s.col1 = a.k800;
show trace;
select /*+ recompile parallel(0) ordered use_nl */ count(*) from ndv_outer a, small s where s.col1 = a.k1200;
show trace;
select /*+ recompile parallel(0) ordered use_nl */ count(*) from ndv_outer a, small s where s.col1 = a.k2000;
show trace;
-- the match-only memo of an NL semi join inner (CBRD-27465) is judged by the same rule
select /*+ recompile parallel(0) USE_NL */ count(*) from ndv_outer a where exists (select 1 from small s where s.col1 = a.k1200);
show trace;

evaluate 'Case 2: nine probe keys in ten distinct, memoize still given up; result = memoize off';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from ndv_outer a, big_in b where b.id = a.mu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from ndv_outer a, big_in b where b.id = a.mu;
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 3: hot keys among many distinct cold keys, the budget runs out and hits go on; result = memoize off';
set system parameters 'memoize_memory_limit=256K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from skew_outer o, big_in b where b.id = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from skew_outer o, big_in b where b.id = o.hot_cold;
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 4: three inner rows per key, the budget runs out while keys are being filled; result = memoize off';
set system parameters 'memoize_memory_limit=256K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=384K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=512K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 5: Cases 3 and 4 with the outer table scanned in parallel, memoize kept in the workers; result = memoize off';
-- the trace shows the parallel scan, and the MEMOIZE line merged from the workers is gone if any worker released its storage
set system parameters 'memoize_memory_limit=256K';
select /*+ recompile ordered use_nl */ count(*), sum(b.v) from skew_outer o, big_in b where b.id = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=384K';
select /*+ recompile ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count(*), sum(b.v) from skew_outer o, big_in b where b.id = o.hot_cold;
select /*+ recompile ordered use_nl */ count(*), sum(m.v) from skew_outer o, multi m where m.k = o.hot_cold;
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 6: a key with 4000 inner rows fills the budget and is taken out, then misses pile up and the storage is released; result = memoize off';
-- key 999 alone must overflow the budget, and once it is taken out the storage holds only the 50 hot keys,
-- far under 60%
set system parameters 'memoize_memory_limit=384K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(f.v) from (select /*+ no_merge parallel(0) */ a, k from fat_outer order by a) o, fat_in f where f.k = o.k;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(f.v) from (select /*+ no_merge parallel(0) */ a, k from fat_outer order by a) o, fat_in f where f.k = o.k;
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 7: hot keys then only distinct keys, the storage is released once the hit ratio falls below half; result = memoize off';
set system parameters 'memoize_memory_limit=256K';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from (select /*+ no_merge parallel(0) */ a, k from phase_outer order by a) o, big_in b where b.id = o.k;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl */ count(*), sum(b.v) from (select /*+ no_merge parallel(0) */ a, k from phase_outer order by a) o, big_in b where b.id = o.k;
set system parameters 'memoize_memory_limit=default';

set trace off;

drop table small, ndv_outer, big_in, multi, skew_outer, fat_in, fat_outer, phase_outer;

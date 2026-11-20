/**
 *  This test case verifies CBRD-28032: an index scan that looks its rows up in the heap may
 *  first record every row the index finds, by heap page, and then read the recorded pages once
 *  each in file order (a bitmap heap scan). The optimizer chooses it by cost; no parameter or
 *  hint turns it on or off.
 *
 *  Before the change an index scan fixed the heap page of each row in key order.
 *
 *  Each case runs the query on the index, prints its trace, and runs a twin that reads the
 *  heap with no index. The two result blocks must be equal. A scan run as a bitmap heap scan
 *  has a "SCAN (bitmap heap: ...)" line under its index line; a scan that looks its rows up in
 *  key order keeps "(lookup time: ..., rows: ...)" on its index line. CTP masks the digits.
 *
 *  Coverage:
 *    Case 1:  parallel scan
 *    Case 2:  serial scan
 *    Case 3:  serial scan with a key filter and a data filter
 *    Case 4:  serial scan of several key ranges
 *    Case 5:  serial scan of keys whose row identifiers fill overflow pages
 *    Case 6:  function index and filtered index
 *    Case 7:  hash join, an index scan below each input
 *    Case 8:  nested loop join: the inner scan keeps the lookup in key order
 *    Case 9:  LIMIT alone stops the scan early: lookup in key order
 *    Case 10: ORDER BY with LIMIT sorts every row: bitmap heap scan
 *    Case 11: index MIN/MAX with a predicate on another column: lookup in key order
 *    Case 12: covering scan and COUNT-only scan read no heap row: no bitmap heap scan
 *    Case 13: FOR UPDATE locks the rows it reads: lookup in key order
 *    Case 14: EXISTS subquery run for each outer row stops at its first row
 *    Case 15: correlated subquery, run once an outer row: lookup in key order
 *    Case 16: partitioned table, serial scan
 *    Case 17: analytic function that skips its sort on the key order: lookup in key order
 *    Case 18: rownum that stops the scan below an ORDER BY: lookup in key order
 */

drop table if exists bh_t, bh_j, bh_p;

-- 200,000 rows of about 90 bytes. k is spread over the heap (4 rows for each key), grp has
-- 20,000 rows for each key (overflow pages).
create table bh_t (id int not null, k int, grp int, s varchar(20), v int, pad varchar(40));
insert into bh_t select rownum, mod(rownum * 31, 50021), mod(rownum, 10), cast(mod(rownum * 13, 100003) as varchar), mod(rownum * 17, 1009), lpad(cast(rownum as varchar), 40, 'x') from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1,2,3,4,5,6,7,8,9}) e, table({0,1}) f;
create index i_bh_k on bh_t (k);
create index i_bh_grp on bh_t (grp);
create index i_bh_ks on bh_t (k, s);
create index i_bh_kv on bh_t (k, v);
create index i_bh_f on bh_t (mod(k, 1000));
create index i_bh_w on bh_t (k) where grp < 5;
create table bh_j (k int, w int);
insert into bh_j select k, count(*) from bh_t where k between 1000 and 9000 group by k;
create index i_bh_j on bh_j (k);
create table bh_p (id int not null, k int, v int, pad varchar(40)) partition by hash (id) partitions 4;
insert into bh_p select id, k, v, pad from bh_t;
create index i_bh_p on bh_p (k);
update statistics on bh_t with fullscan;
update statistics on bh_j with fullscan;
update statistics on bh_p with fullscan;

set trace on;


evaluate 'Case 1: parallel scan; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where k between 60 and 30000 using index i_bh_k(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where k between 60 and 30000 using index none;


evaluate 'Case 2: serial scan; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where k between 60 and 30000 using index i_bh_k(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where k between 60 and 30000 using index none;


evaluate 'Case 3: serial scan with a key filter and a data filter; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 and s like '1%' and grp < 7 using index i_bh_ks(+);
show trace;
select count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 and s like '1%' and grp < 7 using index none;


evaluate 'Case 4: serial scan of several key ranges; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)) from bh_t where (k between 10 and 9000 or k between 8000 and 16000 or k in (40000, 40001, 50020)) using index i_bh_k(+);
show trace;
select count(*), sum(cast(v as bigint)) from bh_t where (k between 10 and 9000 or k between 8000 and 16000 or k in (40000, 40001, 50020)) using index none;


evaluate 'Case 5: serial scan of keys with overflow pages; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where grp between 2 and 5 using index i_bh_grp(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from bh_t where grp between 2 and 5 using index none;


evaluate 'Case 6: function index and filtered index; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)) from bh_t where mod(k, 1000) between 100 and 400 using index i_bh_f(+);
show trace;
select count(*), sum(cast(v as bigint)) from bh_t where mod(k, 1000) between 100 and 400 using index none;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 and grp < 5 using index i_bh_w(+);
show trace;
select count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 and grp < 5 using index none;


evaluate 'Case 7: hash join, an index scan below each input; result = heap scan';
select /*+ recompile no_parallel_scan ordered use_hash */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from bh_t a, bh_t b where a.k between 1000 and 9000 and b.k between 5000 and 13000 and a.k = b.k and a.grp = b.grp using index a.i_bh_k(+), b.i_bh_k(+);
show trace;
select /*+ recompile ordered use_hash */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from bh_t a, bh_t b where a.k between 1000 and 9000 and b.k between 5000 and 13000 and a.k = b.k and a.grp = b.grp using index none;


evaluate 'Case 8: nested loop join, the inner scan looks up in key order; result = heap scan';
select /*+ recompile no_parallel_scan ordered use_nl */ count(*), sum(cast(t.id as bigint)), sum(j.w) from bh_j j, bh_t t where j.k between 1000 and 3000 and t.k = j.k using index j.i_bh_j(+), t.i_bh_k(+);
show trace;
select /*+ recompile ordered use_hash */ count(*), sum(cast(t.id as bigint)), sum(j.w) from bh_j j, bh_t t where j.k between 1000 and 3000 and t.k = j.k using index none;


evaluate 'Case 9: LIMIT alone, lookup in key order';
select /*+ recompile no_parallel_scan */ count(*) from (select /*+ no_merge */ id from bh_t where k between 60 and 30000 and grp < 7 using index i_bh_k(+) limit 50) x;
show trace;


evaluate 'Case 10: ORDER BY with LIMIT; result = heap scan';
select /*+ recompile no_parallel_scan */ id, k, v from bh_t where k between 60 and 30000 and grp = 3 using index i_bh_k(+) order by id limit 5;
show trace;
select id, k, v from bh_t where k between 60 and 30000 and grp = 3 using index none order by id limit 5;


evaluate 'Case 11: index MIN/MAX with a predicate on another column; result = heap scan';
select /*+ recompile no_parallel_scan */ min(k), max(k) from bh_t where k between 60 and 30000 and grp = 3 using index i_bh_k(+);
show trace;
select min(k), max(k) from bh_t where k between 60 and 30000 and grp = 3 using index none;


evaluate 'Case 12: covering scan and COUNT-only scan; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 using index i_bh_kv(+);
show trace;
select /*+ recompile no_parallel_scan */ count(*) from bh_t where k between 60 and 30000 using index i_bh_k(+);
show trace;
select count(*), sum(cast(v as bigint)) from bh_t where k between 60 and 30000 using index none;


evaluate 'Case 13: FOR UPDATE, lookup in key order';
select /*+ recompile no_parallel_scan */ id, k from bh_t where k between 60 and 70 and grp = 3 using index i_bh_k(+) order by id for update;
show trace;


evaluate 'Case 14: EXISTS subquery run for each outer row; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*) from bh_j j where j.k between 1000 and 1200 and exists (select 1 from bh_t t where t.k between j.k and j.k + 3000 and t.grp = 5);
select /*+ recompile */ count(*) from bh_j j where j.k between 1000 and 1200 and exists (select 1 from bh_t t where t.k + 0 between j.k and j.k + 3000 and t.grp = 5);


evaluate 'Case 15: correlated subquery, run once an outer row, lookup in key order; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(c) from (select /*+ no_merge */ (select count(*) from bh_t t where t.k between j.k and j.k + 2000 and t.grp >= 3) c from bh_j j where j.k between 1000 and 1040) x;
show trace;
select /*+ recompile */ count(*), sum(c) from (select /*+ no_merge */ (select count(*) from bh_t t where t.k + 0 between j.k and j.k + 2000 and t.grp >= 3) c from bh_j j where j.k between 1000 and 1040) x;


evaluate 'Case 17: analytic function that skips its sort on the key order, lookup in key order; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(r as bigint)), sum(cast(r as bigint) * mod(id, 7)), min(r), max(r) from (select id, rank() over (order by k) r from bh_t where k between 60 and 30000 and grp >= 0 using index i_bh_k(+)) x;
show trace;
select /*+ recompile */ count(*), sum(cast(r as bigint)), sum(cast(r as bigint) * mod(id, 7)), min(r), max(r) from (select id, rank() over (order by k) r from bh_t where k between 60 and 30000 and grp >= 0 using index none) x;


evaluate 'Case 18: rownum that stops the scan below an ORDER BY, lookup in key order; the 4 rows of the smallest key';
select /*+ recompile no_parallel_scan */ id, k from bh_t where k between 60 and 30000 and grp >= 0 and rownum <= 4 using index i_bh_k(+) order by id;
show trace;
select /*+ recompile */ id, k from bh_t where k + 0 = 60 order by id;


evaluate 'Case 16: partitioned table, serial scan; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(v as bigint)), min(id), max(id) from bh_p where k between 60 and 30000 using index i_bh_p(+);
show trace;
-- the trace is turned off before the last statement: a trace left on would stay with the CTP
-- session and the first show trace of the next file over a cached plan would print it
set trace off;
select count(*), sum(cast(v as bigint)), min(id), max(id) from bh_p where k between 60 and 30000 using index none;

drop table bh_t, bh_j, bh_p;

/**
 *  This test case verifies CBRD-28030: an index scan restarted after it stopped inside the
 *  overflow OIDs of a key reads that key from its leaf record again.
 *
 *  A range scan hands OIDs to the executor through a buffer of 8192 OIDs. When the buffer
 *  fills in the overflow OID pages of a key, the scan marks the key as partially processed.
 *  Before the fix, two restarts kept the mark - the inner index scan of an unnested NL SEMI
 *  or ANTI JOIN (CBRD-26872) rewound for the next outer row, and the index MIN/MAX scan that
 *  turns around (CBRD-24890) - so the first key found skipped the OIDs of its leaf record,
 *  or all of them. SEMI JOIN lost outer rows, ANTI JOIN kept them, MIN or MAX was wrong.
 *
 *  Each query is followed by the same query that reads the table with IGNORE INDEX, and the
 *  two result blocks must match. The traces show the semi or anti join and the index scan
 *  or the min_max_only index scan. CTP masks the digits of a trace.
 *
 *  Coverage:
 *    Case 1:  SEMI JOIN, both outer rows on the long key, matches past and before the buffer end
 *    Case 2:  ANTI JOIN of Case 1
 *    Case 3:  SEMI JOIN, both outer rows match in the leaf record of the long key
 *    Case 4:  SEMI JOIN, the second outer row on a key without overflow pages
 *    Case 5:  ANTI JOIN of Case 4
 *    Case 6:  SEMI JOIN of Case 1 over a descending index
 *    Case 7:  SEMI JOIN of Case 1 with an IN list as the key range
 *    Case 8:  index MIN/MAX with a predicate on another column, MIN and MAX and MAX alone
 *    Case 9:  index MIN/MAX over a descending index, the long key is the largest
 *    Case 10: index MIN/MAX, the largest key also has overflow pages and older OIDs
 *    Case 11: index MIN/MAX without that predicate, no_covering_idx and covering
 */

drop table if exists t_seq, t_inner, t_inner_desc, t_outer, t_outer_other, t_mm, t_mm_desc, t_mm_chain;

-- 40 rows, a row source for the cross joins below
create table t_seq (n int primary key);
insert into t_seq select rownum from db_class a, db_class b limit 40;
-- key 10 holds 20000 rows: past its leaf record they lie in overflow OID pages, and a scan of
-- the key fills the OID buffer of 8192 OIDs (index_scan_oid_buffer_size default) twice inside
-- those pages; v follows the insertion order, so v = 36 is in the leaf record and v = 15000 is
-- past the first 8192 OIDs; key 20 holds one row and has no overflow pages
create table t_inner (id int, k int, v int);
insert into t_inner select rownum, 10, rownum from t_seq a, t_seq b, t_seq c where rownum <= 20000;
insert into t_inner values (20001, 20, 36);
create index i_inner_k on t_inner (k);
-- the same rows under a descending index
create table t_inner_desc (id int, k int, v int);
insert into t_inner_desc select id, k, v from t_inner order by id;
create index i_inner_desc_k on t_inner_desc (k desc);
-- the outer rows are read in id order: the inner scan of row 1 stops inside the overflow pages
-- of key 10 before the inner scan of row 2 starts
create table t_outer (id int, k int);
insert into t_outer values (1, 10), (2, 10);
create table t_outer_other (id int, k int);
insert into t_outer_other values (1, 10), (2, 20);
-- key 1 holds 20000 rows, so the scan for MIN stops inside its overflow pages; key 2 holds one row
create table t_mm (k int, v int);
insert into t_mm select 1, rownum from t_seq a, t_seq b, t_seq c where rownum <= 20000;
insert into t_mm values (2, 5);
create index i_mm_k on t_mm (k);
-- descending: the scan for MAX reads key 2 with 20000 rows first, then the scan for MIN finds key 1
create table t_mm_desc (k int, v int);
insert into t_mm_desc select 2, rownum from t_seq a, t_seq b, t_seq c where rownum <= 20000;
insert into t_mm_desc values (1, 5);
create index i_mm_desc_k on t_mm_desc (k desc);
-- key 2 holds 5000 rows inserted before the 20000 rows of key 1, so it has overflow pages too
create table t_mm_chain (k int, v int);
insert into t_mm_chain select 2, rownum from t_seq a, t_seq b, t_seq c where rownum <= 5000;
insert into t_mm_chain select 1, rownum from t_seq a, t_seq b, t_seq c where rownum <= 20000;
create index i_mm_chain_k on t_mm_chain (k);
update statistics on t_seq, t_inner, t_inner_desc, t_outer, t_outer_other, t_mm, t_mm_desc, t_mm_chain with fullscan;

set trace on;


-- every outer row matches the inner with another value of v, so the inner scan of row 2 is a
-- new search, not the rows the scan of row 1 returned
evaluate 'Case 1: SEMI JOIN over the long key, row 1 matches past the buffer end and row 2 in the leaf record; result = ignore index';
select /*+ recompile ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
show trace;
select /*+ recompile ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i ignore index (i_inner_k) where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
show trace;


evaluate 'Case 2: ANTI JOIN of Case 1; result = ignore index';
select /*+ recompile ordered use_nl */ o.id from t_outer o where not exists (select 1 from t_inner i where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
show trace;
select /*+ ordered use_nl */ o.id from t_outer o where not exists (select 1 from t_inner i ignore index (i_inner_k) where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;


-- a match in the leaf record still stops the scan of row 1 after the buffer filled
evaluate 'Case 3: SEMI JOIN, both outer rows match in the leaf record of the long key; result = ignore index';
select /*+ ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i where i.k = o.k and i.v = o.id) order by 1;
select /*+ ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i ignore index (i_inner_k) where i.k = o.k and i.v = o.id) order by 1;


evaluate 'Case 4: SEMI JOIN, row 2 searches key 20, which has no overflow pages; result = ignore index';
select /*+ ordered use_nl */ o.id from t_outer_other o where exists (select 1 from t_inner i where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
select /*+ ordered use_nl */ o.id from t_outer_other o where exists (select 1 from t_inner i ignore index (i_inner_k) where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;


evaluate 'Case 5: ANTI JOIN of Case 4; result = ignore index';
select /*+ ordered use_nl */ o.id from t_outer_other o where not exists (select 1 from t_inner i where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
select /*+ ordered use_nl */ o.id from t_outer_other o where not exists (select 1 from t_inner i ignore index (i_inner_k) where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;


evaluate 'Case 6: SEMI JOIN of Case 1 over a descending index; result = ignore index';
select /*+ recompile ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner_desc i where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
show trace;
select /*+ ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner_desc i ignore index (i_inner_desc_k) where i.k = o.k and i.v = case o.id when 1 then 15000 else 36 end) order by 1;


-- key 30 is absent, so each outer row reads key 10 from the first range of the list
evaluate 'Case 7: SEMI JOIN of Case 1 with an IN list as the key range; result = ignore index';
select /*+ recompile ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i where i.k in (o.k, 30) and i.v = case o.id when 1 then 15000 else 36 end) order by 1;
show trace;
select /*+ ordered use_nl */ o.id from t_outer o where exists (select 1 from t_inner i ignore index (i_inner_k) where i.k in (o.k, 30) and i.v = case o.id when 1 then 15000 else 36 end) order by 1;


-- the predicate on v keeps the scan from covering the index, so it reads OIDs into the buffer
evaluate 'Case 8: index MIN/MAX scan with a predicate on v; result = ignore index';
select /*+ recompile */ min(k), max(k) from t_mm where k > 0 and v > 0 using index i_mm_k(+);
show trace;
-- no_parallel_scan keeps the parallel heap scan line, which depends on the page count, out of this trace
select /*+ recompile no_parallel_scan */ min(k), max(k) from t_mm ignore index (i_mm_k) where k > 0 and v > 0;
show trace;
select max(k) from t_mm where k > 0 and v > 0 using index i_mm_k(+);
select max(k) from t_mm ignore index (i_mm_k) where k > 0 and v > 0;


evaluate 'Case 9: index MIN/MAX scan over a descending index, the long key is the largest; result = ignore index';
select /*+ recompile */ min(k), max(k) from t_mm_desc where k > 0 and v > 0 using index i_mm_desc_k(+);
show trace;
select min(k), max(k) from t_mm_desc ignore index (i_mm_desc_k) where k > 0 and v > 0;


evaluate 'Case 10: index MIN/MAX scan, the largest key has overflow pages with older OIDs; result = ignore index';
select /*+ recompile */ min(k), max(k) from t_mm_chain where k > 0 and v > 0 using index i_mm_chain_k(+);
show trace;
select min(k), max(k) from t_mm_chain ignore index (i_mm_chain_k) where k > 0 and v > 0;


-- no_covering_idx makes the scan read OIDs through the buffer; the covering scan reads keys
-- only and never stops inside a key
evaluate 'Case 11: index MIN/MAX scan without the predicate on v, no_covering_idx and covering; result = ignore index';
select /*+ recompile no_covering_idx */ min(k), max(k) from t_mm where k > 0 using index i_mm_k(+);
show trace;
select /*+ recompile */ min(k), max(k) from t_mm where k > 0 using index i_mm_k(+);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the first show trace of the next file over a cached plan would print it
set trace off;
select min(k), max(k) from t_mm ignore index (i_mm_k) where k > 0;

drop table t_seq, t_inner, t_inner_desc, t_outer, t_outer_other, t_mm, t_mm_desc, t_mm_chain;

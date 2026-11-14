/**
 *  This test case verifies CBRD-28031: an index scan tells the OS which heap pages its next
 *  lookups read, and the rows, the errors and the trace lines of the scan stay the same.
 *
 *  Before the change an index scan read each heap page only when its lookup asked for it.
 *
 *  Each case runs the query on the index, prints its trace, and runs a twin that reads the
 *  heap with no index. The two result blocks must be equal. The trace names the scan by its
 *  tokens only, because CTP masks the digits. No hint or parameter turns the hint to the OS
 *  off, so the build before the change passes this file too.
 *
 *  Coverage:
 *    Case 1:  parallel scan of a unique index returns the rows of the heap scan
 *    Case 2:  parallel scan of an index with a few rows for each key
 *    Case 3:  parallel scan of keys whose row identifiers fill overflow pages
 *    Case 4:  parallel scan with a key filter on the second column
 *    Case 5:  parallel scan of several key ranges
 *    Case 6:  parallel scan of a descending index
 *    Case 7:  serial scan in index order that stops at a LIMIT
 *    Case 8:  key filter error in a parallel scan, then the same keys with no error
 *    Case 9:  inner index scan of a semi join that stops at its first match
 *    Case 10: inner index scan of an anti join
 *    Case 11: LIMIT over a data filter that few rows of one key pass
 *    Case 12: EXISTS subquery under OR, run for each outer row
 *    Case 13: key list on an index with a few rows for each key
 *    Case 14: key list on a unique index
 */

drop table if exists ra_t;

-- 250,000 rows of about 90 bytes: 1,569 heap pages. u is unique, k has 4 rows for each key, grp has
-- 25,000 rows for each key (overflow pages), s cannot be cast to int in 5 rows (the error of Case 8).
-- Case 1 to Case 6 and Case 8 carry parallel(4): a hinted index scan runs in parallel from 32 index
-- pages under CTP, and SHOW INDEX CAPACITY gives 160 pages for the two indexes on k, 262 for the
-- index on u, 384 for the index on grp and 390 for the index on (k, s), 5 times the threshold or more
create table ra_t (id int not null, u int not null, k int, grp int, s varchar(20), v int, pad varchar(40));
insert into ra_t select rownum, mod(rownum * 7919, 250007), mod(rownum * 31, 62501), mod(rownum, 10), case when mod(rownum, 50000) = 7 then 'abc' else cast(mod(rownum, 1000) as varchar(20)) end, rownum, lpad('x', 40, 'x') from db_root connect by level <= 250000;
create unique index i_ra_u on ra_t (u);
create index i_ra_k on ra_t (k);
create index i_ra_grp on ra_t (grp);
create index i_ra_ks on ra_t (k, s);
create index i_ra_kd on ra_t (k desc);
update statistics on ra_t with fullscan;

set trace on;



evaluate 'Case 1: parallel scan of a unique index; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where u between 600 and 187500 using index i_ra_u(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where u between 600 and 187500 using index none;


evaluate 'Case 2: parallel scan, a few rows for each key; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where k between 60 and 56000 using index i_ra_k(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where k between 60 and 56000 using index none;


evaluate 'Case 3: parallel scan of keys with overflow pages; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where grp between 2 and 5 using index i_ra_grp(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where grp between 2 and 5 using index none;


evaluate 'Case 4: parallel scan with a key filter on the second column; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)) from ra_t where k between 60 and 56000 and s like '1%' using index i_ra_ks(+);
show trace;
select count(*), sum(cast(v as bigint)) from ra_t where k between 60 and 56000 and s like '1%' using index none;


evaluate 'Case 5: parallel scan of several key ranges; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)) from ra_t where (u between 10 and 31000 or u between 125000 and 156000 or u in (187501, 187502, 250000)) using index i_ra_u(+);
show trace;
select count(*), sum(cast(v as bigint)) from ra_t where (u between 10 and 31000 or u between 125000 and 156000 or u in (187501, 187502, 250000)) using index none;


evaluate 'Case 6: parallel scan of a descending index; result = heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)) from ra_t where k between 3000 and 37500 using index i_ra_kd(+);
show trace;
select count(*), sum(cast(v as bigint)) from ra_t where k between 3000 and 37500 using index none;


evaluate 'Case 7: serial scan in index order that stops at a LIMIT; result = heap scan and sort';
select /*+ recompile */ id, u from ra_t where u between 600 and 187500 using index i_ra_u(+) order by u limit 20;
show trace;
select id, u from ra_t where u between 600 and 187500 using index none order by u limit 20;


evaluate 'Case 8: a key filter fails in a parallel scan and in the heap scan (expected errors), then the same keys return the rows of the heap scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)) from ra_t where k between 0 and 62501 and cast(s as int) >= 0 using index i_ra_ks(+);
select count(*), sum(cast(v as bigint)) from ra_t where k between 0 and 62501 and cast(s as int) >= 0 using index none;
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)) from ra_t where k between 0 and 62501 and s >= '0' using index i_ra_ks(+);
show trace;
select count(*), sum(cast(v as bigint)) from ra_t where k between 0 and 62501 and s >= '0' using index none;


evaluate 'Case 9: inner index scan of a semi join; result = join with distinct';
select /*+ recompile */ count(*), sum(cast(a.v as bigint)) from ra_t a where a.id between 124900 and 125200 and exists (select 1 from ra_t b where b.k = a.k and b.v > a.v + 93750);
show trace;
select count(distinct a.id), sum(distinct cast(a.v as bigint)) from ra_t a, ra_t b where a.id between 124900 and 125200 and b.k = a.k and b.v > a.v + 93750;


evaluate 'Case 10: inner index scan of an anti join; result = count subquery';
select /*+ recompile */ count(*), sum(cast(a.v as bigint)) from ra_t a where a.id between 124900 and 125200 and not exists (select 1 from ra_t b where b.k = a.k and b.v > a.v + 93750);
show trace;
select count(*), sum(cast(a.v as bigint)) from ra_t a where a.id between 124900 and 125200 and (select count(*) from ra_t b where b.k = a.k and b.v > a.v + 93750) = 0;


evaluate 'Case 11: LIMIT over a data filter that 250 of the 25,000 rows of one key pass; 5 rows that pass the filter, and the heap scan counts 250';
select /*+ recompile */ count(*), min(grp), max(grp), min(mod(v, 1000)), max(mod(v, 1000)) from (select grp, v from ra_t where grp = 3 and mod(v, 1000) = 13 using index i_ra_grp(+) limit 5) t;
show trace;
select count(*) from ra_t where grp = 3 and mod(v, 1000) = 13 using index none;


evaluate 'Case 12: EXISTS subquery under OR, run for each outer row; result = join with distinct';
select /*+ recompile */ count(*), sum(cast(a.v as bigint)) from ra_t a where a.id between 124900 and 125200 and (a.s = 'zzz' or exists (select 1 from ra_t b where b.k = a.k and b.v > a.v + 93750));
show trace;
select count(distinct a.id), sum(distinct cast(a.v as bigint)) from ra_t a, ra_t b where a.id between 124900 and 125200 and b.k = a.k and b.v > a.v + 93750;


evaluate 'Case 13: key list, a few rows for each key; result = heap scan';
select /*+ recompile */ count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where k in (60, 1250, 18750, 43750, 62500) using index i_ra_k(+);
show trace;
select count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where k in (60, 1250, 18750, 43750, 62500) using index none;


evaluate 'Case 14: key list on a unique index; result = heap scan';
select /*+ recompile */ count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where u in (5, 600, 12500, 187500, 250006) using index i_ra_u(+);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the first show trace of the next file over a cached plan would print it
set trace off;
select count(*), sum(cast(v as bigint)), min(id), max(id) from ra_t where u in (5, 600, 12500, 187500, 250006) using index none;

drop table ra_t;

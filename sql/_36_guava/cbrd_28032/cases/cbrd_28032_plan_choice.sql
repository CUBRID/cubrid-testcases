/**
 *  This test case verifies CBRD-28032: the optimizer compares three ways to read a table by cost,
 *  the sequential scan, the index scan that looks its rows up in key order, and the index scan
 *  that reads them through a bitmap (a bitmap heap scan), and builds its joins from all three.
 *
 *  Before the change an index scan always looked its rows up in key order. No case below has an
 *  index hint or a parameter: each plan is the one the optimizer picks.
 *
 *  Each case prints the plan of its query and runs a twin that reads the heap with no index. The
 *  two result blocks must be equal. A bitmap heap scan prints "(bitmap heap scan)" on the index
 *  line of the plan. CTP masks the digits of a plan.
 *
 *  Coverage:
 *    Case 1:  range of a few rows: lookup in key order
 *    Case 2:  range of a tenth of the rows: bitmap heap scan
 *    Case 3:  range of most of the rows: sequential scan
 *    Case 4:  the range of Case 2 with a parallel hint: bitmap heap scan
 *    Case 5:  hash join: a bitmap heap scan below each input
 *    Case 6:  hash join that a LIMIT stops early: lookup in key order below each input
 *    Case 7:  merge join: lookup in key order below each input
 *    Case 8:  index join: a bitmap heap scan outside, the inner scan looks up in key order
 *    Case 9:  analytic function: a bitmap heap scan, and with a LIMIT the lookup in key order
 *    Case 10: two analytic functions, the key order saves the sort of one: lookup in key order
 *    Case 11: analytic function over an index join, the key order of the outer scan saves its sort: lookup in key order
 */

drop table if exists pc_t, pc_j;

-- 200,000 rows of about 90 bytes on about 1,200 heap pages. k is spread over the heap, 4 rows for
-- each of its 50,021 keys. The ranges below stay away from the two points where the plan changes:
-- a bitmap heap scan starts to win near 235 rows (Case 1 reads about 12, Case 2 about 20,000) and
-- the sequential scan near 56,000 rows (Case 2 reads about 20,000, Case 3 about 160,000).
create table pc_t (id int not null, k int, grp int, v int, pad varchar(40));
insert into pc_t select rownum, mod(rownum * 31, 50021), mod(rownum, 10), mod(rownum * 17, 1009), lpad(cast(rownum as varchar), 40, 'x') from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1,2,3,4,5,6,7,8,9}) e, table({0,1}) f;
create index i_pc_k on pc_t (k);
-- one row for each key of pc_t between 1000 and 9000
create table pc_j (k int, w int);
insert into pc_j select k, count(*) from pc_t where k between 1000 and 9000 group by k;
create index i_pc_j on pc_j (k);
update statistics on pc_t with fullscan;
update statistics on pc_j with fullscan;


evaluate 'Case 1: range of a few rows, lookup in key order; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 62;
select count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 62 using index none;


evaluate 'Case 2: range of a tenth of the rows, bitmap heap scan; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 5060;
select count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 5060 using index none;


evaluate 'Case 3: range of most of the rows, sequential scan; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 40060;
select count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 40060 using index none;


-- unlike Case 2, a parallel hint: the cost of a bitmap heap scan does not count the workers
evaluate 'Case 4: the range of Case 2 with a parallel hint, bitmap heap scan; result = heap scan';
--@queryplan
select /*+ recompile parallel(4) */ count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 5060;
select count(*), sum(cast(v as bigint)), min(pad), max(pad) from pc_t where k between 60 and 5060 using index none;


-- the join hints of Case 5 to Case 8 fix the join method, which is what each case is about
evaluate 'Case 5: hash join, a bitmap heap scan below each input; result = heap scan';
--@queryplan
select /*+ recompile ordered use_hash */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from pc_t a, pc_t b where a.k between 1000 and 3000 and b.k between 2000 and 4000 and a.k = b.k and a.grp = b.grp;
select /*+ ordered use_hash */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from pc_t a, pc_t b where a.k between 1000 and 3000 and b.k between 2000 and 4000 and a.k = b.k and a.grp = b.grp using index none;


-- the join of Case 5 below a LIMIT with no ORDER BY: the statement may stop before the scans end
evaluate 'Case 6: hash join that a LIMIT stops early, lookup in key order below each input; result = 50';
--@queryplan
select /*+ recompile */ count(*) from (select /*+ no_merge ordered use_hash */ a.id from pc_t a, pc_t b where a.k between 1000 and 3000 and b.k between 2000 and 4000 and a.k = b.k and a.grp = b.grp limit 50) x;


evaluate 'Case 7: merge join, lookup in key order below each input; result = heap scan';
--@queryplan
select /*+ recompile ordered use_merge */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from pc_t a, pc_t b where a.k between 1000 and 3000 and b.k between 2000 and 4000 and a.k = b.k and a.grp = b.grp;
select /*+ ordered use_hash */ count(*), sum(cast(a.id as bigint)), sum(cast(b.id as bigint)) from pc_t a, pc_t b where a.k between 1000 and 3000 and b.k between 2000 and 4000 and a.k = b.k and a.grp = b.grp using index none;


-- parallel(0): with workers the optimizer drives this join with a parallel heap scan of pc_t, another plan than the one this case checks
evaluate 'Case 8: index join, a bitmap heap scan outside and a lookup in key order inside; result = heap scan';
--@queryplan
select /*+ recompile ordered use_idx parallel(0) */ count(*), sum(cast(t.id as bigint)), sum(j.w) from pc_t t, pc_j j where t.k between 1000 and 3000 and j.k = t.k and t.grp < 9;
select /*+ ordered use_hash */ count(*), sum(cast(t.id as bigint)), sum(j.w) from pc_t t, pc_j j where t.k between 1000 and 3000 and j.k = t.k and t.grp < 9 using index none;


-- the second query adds only a LIMIT to the block of the analytic function
evaluate 'Case 9: analytic function, a bitmap heap scan, and with a LIMIT the lookup in key order; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(r as bigint)), sum(cast(r as bigint) * mod(id, 7)) from (select id, rank() over (order by v, id) r from pc_t where k between 60 and 5060) x;
select count(*), sum(cast(r as bigint)), sum(cast(r as bigint) * mod(id, 7)) from (select id, rank() over (order by v, id) r from pc_t where k between 60 and 5060 using index none) x;
--@queryplan
select /*+ recompile */ id, v, rank() over (order by v, id) r from pc_t where k between 60 and 5060 order by v, id limit 5;
select id, v, rank() over (order by v, id) r from pc_t where k between 60 and 5060 using index none order by v, id limit 5;


-- unlike Case 9, the key order of i_pc_k is the order of the first function, whose sort is skipped
evaluate 'Case 10: two analytic functions, the key order saves the sort of one, lookup in key order; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(ra as bigint) * mod(id, 7)), sum(cast(rb as bigint) * mod(id, 7)) from (select id, rank() over (order by k) ra, row_number() over (order by v, id) rb from pc_t where k between 60 and 5060) x;
select count(*), sum(cast(ra as bigint) * mod(id, 7)), sum(cast(rb as bigint) * mod(id, 7)) from (select id, rank() over (order by k) ra, row_number() over (order by v, id) rb from pc_t where k between 60 and 5060 using index none) x;


-- parallel(0) as in Case 8
evaluate 'Case 11: analytic function over an index join, the key order of the outer scan saves its sort, lookup in key order; result = heap scan';
--@queryplan
select /*+ recompile */ count(*), sum(cast(ra as bigint) * mod(id, 7)), sum(w) from (select /*+ no_merge ordered use_idx parallel(0) */ t.id, t.pad, j.w, rank() over (order by t.k) ra from pc_t t, pc_j j where t.k between 1000 and 3000 and j.k = t.k) x;
select count(*), sum(cast(ra as bigint) * mod(id, 7)), sum(w) from (select /*+ no_merge ordered use_hash */ t.id, t.pad, j.w, rank() over (order by t.k) ra from pc_t t, pc_j j where t.k between 1000 and 3000 and j.k = t.k using index none) x;

drop table pc_t, pc_j;

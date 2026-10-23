/**
 *  This test case verifies CBRD-27733: HAVING correlations belong to each
 *  outer row even when the WHERE search key is shared or repeated.
 *  Default queries and NO_SUBQUERY_CACHE twins use literal expected rows.
 *  Grouped, empty-input and uncached shapes also check unchanged semantics.
 *  No execution-plan token, cache hit count or evaluation order is required.
 *  Coverage:
 *    Case 1: two outer values in AND
 *    Case 2: OR predicate and NULL truth
 *    Case 3: arithmetic and COALESCE operands
 *    Case 4: COUNT over empty and NULL search keys
 *    Case 5: GROUP BY HAVING scalar semantics
 *    Case 6: aggregate without HAVING regression
 *    Case 7: correlation only in HAVING
 *    Case 8: IN predicate with two correlated operands
 *    Case 9: nested HAVING subquery correctness fallback
 *    Case 10: HAVING IF condition with a shared WHERE key
 *    Case 11: HAVING CASE condition with a shared WHERE key
 *    Case 12: HAVING DECODE condition with a shared WHERE key
 *    Case 13: WHERE IF condition
 *    Case 14: select-list IF condition
 *    Case 15: predicate used as a select-list value
 */

drop table if exists t_outer, t_inner;

-- Repeated complete keys and different HAVING values share each search key
create table t_outer (id int primary key, k int, lo int, hi int);

insert into t_outer values (1, 1, 0, 15), (2, 1, 10, 15), (3, 1, 0, 10), (4, 1, NULL, 15), (5, 1, 0, 15), (6, 1, 10, 15), (7, 1, 0, 10), (8, 1, NULL, 15), (9, 2, 0, 35), (10, 2, 30, 35), (11, 3, -1, 5), (12, 3, 0, 5), (13, NULL, -1, 5), (14, NULL, 0, 5), (15, 2, 0, 35), (16, 2, 30, 35);

-- Distinct group sizes and maxima distinguish empty, NULL and nonempty inputs
create table t_inner (k int, v int);

insert into t_inner values (1, 3), (1, 10), (2, 7), (2, 20), (2, 30), (NULL, 99);

create index idx_k on t_inner(k);

update statistics on t_outer, t_inner with fullscan;

evaluate 'Case 1: two outer values in AND; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.lo and max(ii.v) < oo.hi) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > oo.lo and max(ii.v) < oo.hi) as x from t_outer oo order by oo.id;

evaluate 'Case 2: OR predicate and NULL truth; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) <= oo.lo or max(ii.v) >= oo.hi) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) <= oo.lo or max(ii.v) >= oo.hi) as x from t_outer oo order by oo.id;

evaluate 'Case 3: arithmetic and COALESCE operands; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > coalesce(oo.lo, 0) + oo.hi - 15) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > coalesce(oo.lo, 0) + oo.hi - 15) as x from t_outer oo order by oo.id;

evaluate 'Case 4: COUNT over empty and NULL search keys; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select count(*) from t_inner ii where ii.k = oo.k having count(*) > oo.lo) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ count(*) from t_inner ii where ii.k = oo.k having count(*) > oo.lo) as x from t_outer oo order by oo.id;

evaluate 'Case 5: GROUP BY HAVING scalar semantics; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k group by ii.k having max(ii.v) > oo.lo) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k group by ii.k having max(ii.v) > oo.lo) as x from t_outer oo order by oo.id;

evaluate 'Case 6: aggregate without HAVING regression; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select sum(ii.v) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ sum(ii.v) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;

evaluate 'Case 7: correlation only in HAVING; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii having max(ii.v) > oo.hi * 4) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii having max(ii.v) > oo.hi * 4) as x from t_outer oo order by oo.id;

evaluate 'Case 8: IN predicate with two correlated operands; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) in (oo.lo, oo.hi)) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) in (oo.lo, oo.hi)) as x from t_outer oo order by oo.id;

evaluate 'Case 9: nested HAVING subquery correctness fallback; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > (select min(cc.lo) from t_outer cc where cc.id = oo.id)) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having max(ii.v) > (select min(cc.lo) from t_outer cc where cc.id = oo.id)) as x from t_outer oo order by oo.id;


-- The same k and hi with different lo expose a missing condition-only key
evaluate 'Case 10: HAVING IF condition; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having if(oo.lo = 0, oo.hi, 0) > 0) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having if(oo.lo = 0, oo.hi, 0) > 0) as x from t_outer oo order by oo.id;


evaluate 'Case 11: HAVING CASE condition; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having case when oo.lo = 0 then 1 else 0 end = 1) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having case when oo.lo = 0 then 1 else 0 end = 1) as x from t_outer oo order by oo.id;


evaluate 'Case 12: HAVING DECODE condition; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k having decode(oo.lo, 0, oo.hi, 0) > 0) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k having decode(oo.lo, 0, oo.hi, 0) > 0) as x from t_outer oo order by oo.id;


evaluate 'Case 13: WHERE IF condition; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) from t_inner ii where ii.k = oo.k and if(oo.lo = 0, 1, 0) = 1) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) from t_inner ii where ii.k = oo.k and if(oo.lo = 0, 1, 0) = 1) as x from t_outer oo order by oo.id;


evaluate 'Case 14: select-list IF condition; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) + if(oo.lo = 0, 100, 0) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) + if(oo.lo = 0, 100, 0) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;


evaluate 'Case 15: predicate used as a value; result = NO_SUBQUERY_CACHE';

select /*+ recompile */ oo.id, (select max(ii.v) + (oo.lo > 0) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;

select /*+ recompile */ oo.id, (select /*+ NO_SUBQUERY_CACHE */ max(ii.v) + (oo.lo > 0) from t_inner ii where ii.k = oo.k) as x from t_outer oo order by oo.id;

drop table t_outer, t_inner;

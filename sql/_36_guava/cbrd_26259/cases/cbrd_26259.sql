/*
 * CBRD-26259: qo_check_nullable_expr() / qo_check_nullable_expr_with_spec()
 * must treat "= ALL/NOT IN (empty subquery)" and "NOT EXISTS (empty
 * correlated subquery)" as nullable-unsafe: these predicates are vacuously
 * TRUE even when the tested column is NULL, so they must never be accepted
 * as a not-null proof for a key column.
 *
 * Without the fix, a row whose relevant key is NULL (or, for a composite
 * key, entirely NULL) is silently dropped:
 *   - ORDER BY skip (qo_validate_index_for_sort -> qo_check_nullable_expr)
 *     wrongly treats the composite index as covering every row, so the
 *     (NULL, NULL) row goes missing from a natural index-order scan.
 *   - LEFT OUTER JOIN -> INNER JOIN reduction (qo_check_nullable_expr_with_spec)
 *     wrongly treats the outer side's join column as proven not-null, so an
 *     unmatched (padding) row is dropped entirely.
 *
 * Each case below is paired with a "using index none" control on the same
 * query: that result is the ground truth (never affected by either skip
 * decision), so the fixed and unfixed queries can be compared against it.
 *
 * The 3 predicate forms (= ALL / NOT IN / NOT EXISTS) must each be tested
 * against BOTH affected code paths, since they are two separately
 * duplicated not-null checks (qo_check_nullable_expr / _with_spec):
 *   - ORDER BY skip:        [1] = ALL, [1b] NOT IN, [2] NOT EXISTS
 *   - outer join reduction: [3] = ALL, [3b] NOT IN, [3c] NOT EXISTS
 * NOT IN is its own PT_NODE type (PT_IS_NOT_IN), not rewritten into
 * "= ALL"/"<> ALL" before reaching the not-null check, so [1b]/[3b] each
 * need their own case to actually exercise that switch branch.
 *
 * [1]/[1b]/[3]/[3b]'s arg2 is a subquery; = ALL/NOT IN are also vacuously
 * TRUE for NULL when arg2 is instead a host variable or literal set bound
 * empty at execution time, which is a syntactically different arg2 (not
 * PT_IS_QUERY) that the not-null checks must catch too:
 *   [1c]/[1c-control]: NOT IN against a host variable bound to {}
 *   [1d]/[1d-control]: = ALL against a literal set {}
 *   [1e]/[1e-control]: NOT IN against a literal set {}
 * Separately, two more operators are TRUE for a NULL operand and were
 * missing from one or both checks:
 *   [4]/[4-control]: (c2 > 0) IS NOT TRUE -- NULL > 0 is UNKNOWN, and
 *     UNKNOWN IS NOT TRUE is TRUE, so this is never a not-null proof.
 *   [3d]: j <=> NULL (NULLSAFE_EQ) in an outer join -- true precisely
 *     when j IS NULL, so it can never prove j is not null either; this
 *     was already handled by qo_check_nullable_expr() but missing from
 *     qo_check_nullable_expr_with_spec().
 *
 * Schema:
 *   u(c1, c2): composite index (c1, c2); one row is entirely NULL.
 *   v(x): empty/non-empty subquery source.
 *   oa(i)/ob(i, j): outer-join pair; oa has rows with no match in ob.
 */

set system parameters 'dont_reuse_heap_file=yes';

drop table if exists u;
drop table if exists v;
drop table if exists oa;
drop table if exists ob;

create table u (c1 int, c2 int);
create index i_u_c1_c2 on u (c1, c2);
insert into u values (3,1),(NULL,5),(NULL,NULL),(2,NULL);

create table v (x int);
insert into v values (1),(5);

create table oa (i int);
insert into oa values (1),(2),(3);
create table ob (i int, j int);
insert into ob values (1, 10);

evaluate '[1] c2 = all (empty subquery): (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where c2 = all (select c1 from u where c1 > 1000) order by c1;

evaluate '[1-control] same query, index forced off: ground truth for [1]';
select c1, c2 from u where c2 = all (select c1 from u where c1 > 1000) using index none order by c1;

evaluate '[1b] c2 not in (empty subquery): (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where c2 not in (select c1 from u where c1 > 1000) order by c1;

evaluate '[1b-control] same query, index forced off: ground truth for [1b]';
select c1, c2 from u where c2 not in (select c1 from u where c1 > 1000) using index none order by c1;

evaluate '[2] not exists (correlated subquery with no match against a NULL column): (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where not exists (select 1 from v where v.x = u.c2) order by c1;

evaluate '[2-control] same query, index forced off: ground truth for [2]';
select c1, c2 from u where not exists (select 1 from v where v.x = u.c2) using index none order by c1;

evaluate '[3] left outer join + j = all (empty subquery): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j = all (select x from v where x > 1000) order by oa.i;

evaluate '[3b] left outer join + j not in (empty subquery): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j not in (select x from v where x > 1000) order by oa.i;

evaluate '[3c] left outer join + not exists (correlated on ob.j): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where not exists (select 1 from v where v.x = ob.j) order by oa.i;

evaluate '[1c] c2 not in ? (host variable bound to an empty set): (NULL,NULL) must survive ORDER BY skip';
prepare stmt_1c from 'select c1, c2 from u where c2 not in ? order by c1';
execute stmt_1c using {};

evaluate '[1c-control] same query, index forced off: ground truth for [1c]';
prepare stmt_1c_ctrl from 'select c1, c2 from u where c2 not in ? using index none order by c1';
execute stmt_1c_ctrl using {};

evaluate '[1d] c2 = all {} (empty set literal, not a subquery): (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where c2 = all {} order by c1;

evaluate '[1d-control] same query, index forced off: ground truth for [1d]';
select c1, c2 from u where c2 = all {} using index none order by c1;

evaluate '[1e] c2 not in {} (empty set literal, not a subquery): (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where c2 not in {} order by c1;

evaluate '[1e-control] same query, index forced off: ground truth for [1e]';
select c1, c2 from u where c2 not in {} using index none order by c1;

evaluate '[4] (c2 > 0) is not true: (NULL,NULL) must survive ORDER BY skip';
select c1, c2 from u where (c2 > 0) is not true order by c1;

evaluate '[4-control] same query, index forced off: ground truth for [4]';
select c1, c2 from u where (c2 > 0) is not true using index none order by c1;

evaluate '[3d] left outer join + j <=> null (NULLSAFE_EQ): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j <=> null order by oa.i;

drop table if exists u;
drop table if exists v;
drop table if exists oa;
drop table if exists ob;

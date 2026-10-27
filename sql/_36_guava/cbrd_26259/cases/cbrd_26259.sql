-- ============================================================================
-- CBRD-26259
--
-- Two independent mechanisms, verified separately below:
--
-- A. qo_validate_index_for_sort(): a composite index may be used for
--    ORDER BY/GROUP BY skip if ANY key column (not just the leading one)
--    is proven NOT NULL, since a row is absent from the index only when
--    every key column is NULL. Also resolves CBRD-27467.
--
--    Positive (skip fires, matches control) -- PR review Test table:
--      [7]   trailing key (c3) is schema NOT NULL, unreferenced in the query -> ORDER BY skip
--      [7g]  WHERE c2 > 0 ORDER BY c1: term proves c2 NOT NULL, c1 may still be NULL
--      [7b]  same as [7], under GROUP BY skip
--
--    (An ENUM-literal-list case ("[8]"), exercising the same PT_FUNCTION
--    literal-set recognition as e0d5fc622, was tried here too, but the engine PR
--    itself already judged a dedicated TC unnecessary -- that CI regression is
--    already covered by the existing trac_344_03.sql. Dropped to avoid
--    duplicating coverage this file doesn't need.)
--
--    (A WHERE c1 = 3 ORDER BY c2 case ("[7h]") was tried here too, but gdb showed
--    qo_validate_index_for_sort() is never even called for it -- an equality term
--    on the leading key already guarantees that key is not null, through a
--    completely different, pre-existing code path, so it cannot regress from
--    anything this PR touches. Dropped as out of scope for this file.)
--
--    Negative (skip must NOT fire) -- PR review Test table:
--      [7i]  WHERE c1 = 3 OR c2 = 1 ORDER BY c1: OR breaks the NOT NULL proof
--      [7j]  GROUP BY ... WITH ROLLUP -> must NOT skip
--      [7c]  single-column index on a nullable column -> must NOT skip
--
--    Regression (CBRD-27467):
--      [7d]  same as [7b], descending index scan path
--      [7e]  same as [7], descending index scan path (separate function from [7d]'s)
--      [7f]  same schema/query as [7], but no NULLs in the data at all (regression baseline)
--
-- B. qo_check_nullable_op(): classifies whether an operator can be TRUE for
--    a NULL operand, so it must not be treated as a NOT NULL proof for
--    ORDER BY/GROUP BY skip or LEFT OUTER JOIN -> INNER JOIN reduction.
--
--    For [1]/[1b]/[1c]/[1d]/[1e]/[4]/[5]/[5b] below, the predicate is on
--    the ORDER BY/GROUP BY column itself (c1), not on a different key column:
--    qo_validate_index_attr_notnull() already walks the WHERE clause for terms
--    on that exact column without needing the multi-key extension from A, so
--    these predicates reach qo_check_nullable_op() even on a build that only has
--    the single-column (leading-key) check. A build with the misclassification
--    bug treats the predicate as a valid NOT NULL proof and wrongly skips the
--    sort, which drops the (NULL, NULL) row entirely (composite index (c1, c2)
--    excludes it from the B-tree since both key columns are NULL). A fixed
--    build classifies the predicate correctly and falls back to an explicit
--    SORT/GROUPBY, which cannot drop any row -- so these are result-level
--    regression checks, not plan-only ones.
--
--    Regression (reviewer, first pass, 2026-09-04):
--      [1]   c1 = ALL (empty subquery)
--      [1b]  c1 NOT IN (empty subquery)
--      [2]   NOT EXISTS (correlated subquery on c1), /*+ NO_UNNEST */
--      [3]   j = ALL (empty subquery), outer join
--      [3b]  j NOT IN (empty subquery), outer join
--      [3c]  NOT EXISTS (correlated on ob.j), outer join, /*+ NO_UNNEST */
--
--    ([2]/[3c]'s subquery is otherwise unnestable (single base table, no
--    aggregate/GROUP BY/LIMIT), so CBRD-26872's SEMI/ANTI JOIN unnesting
--    (qo_rewrite_exists_semi_anti()) rewrites the NOT EXISTS into an explicit
--    ANTI JOIN before either proof search runs, bypassing qo_check_nullable_op()
--    entirely and masking this PR's fix -- confirmed with gdb: without the hint,
--    the as-is and fixed builds produce identical plans/results, because the
--    function is never called either way. The /*+ NO_UNNEST */ hint on the
--    subquery's SELECT forces qo_is_unnestable_subquery() to reject it, so the
--    NOT EXISTS stays a plain correlated predicate and does reach
--    qo_check_nullable_op()'s PT_NOT(PT_EXISTS) case; with the hint, gdb confirms
--    the branch is hit and that forcing it back to its pre-fix behavior
--    reproduces the row/padding-row loss on the as-is build.)
--
--    Regression (reviewer, second pass, 2026-09-16):
--      [1c]  c1 NOT IN ? (host variable bound to {})
--      [1d]  c1 = ALL {} (empty set literal)
--      [1e]  c1 NOT IN {} (empty set literal)
--      [4]   (c1 > 0) IS NOT TRUE
--      [3d]  j <=> NULL (NULLSAFE_EQ), outer join
--
--    Regression (reviewer, exhaustive 70-predicate sweep, 2026-09-22):
--      [5]   (c1 > 0) IS UNKNOWN
--      [5b]  same as [5], under GROUP BY skip
--      [6]   j IS UNKNOWN, outer join
--      [6b]  same as [6], through an inline view
--
--    (e0d5fc622 also added a CAST-unwrap branch to qo_check_nullable_op(), for a
--    literal collection wrapped in PT_EXPR/PT_CAST by
--    pt_wrap_collection_with_cast_op(). No case is added for it: confirmed with
--    gdb that pt_wrap_collection_with_cast_op() does produce that wrapper (e.g.
--    for `date_col NOT IN ('2020-01-01', ...)`, needing an implicit cast of the
--    whole literal set), but the wrapper is flagged PT_EXPR_INFO_CAST_SHOULD_FOLD
--    and constant-folded back to a plain PT_VALUE before qo_check_nullable_op()
--    ever runs, so the CAST branch is not reached this way. A set containing a
--    host variable also does not reach it: arg2 is the PT_HOST_VAR node itself,
--    not a CAST wrapping it. A non-foldable set (e.g. containing sys_date) goes
--    through the PT_FUNCTION branch instead, not the CAST one. No construct that
--    reaches this branch with a surviving CAST node was found -- as a prior
--    session already noted for the PR's related PT_CAST handling, this looks
--    defensive-only.)
--
-- For ORDER BY/GROUP BY skip cases, each [N-control] executes the same query
-- with USING INDEX NONE. The normal query and its control must return the
-- same result, including rows whose index key contains NULL.
--
-- For outer join cases, unmatched NULL-padding rows must remain in the result;
-- the LEFT OUTER JOIN must not be incorrectly reduced to an INNER JOIN.
--
-- [7]/[7b]/[7d]/[7e]/[7f]/[7g]: traced with show trace.
-- For these A-side cases, a regression that silently stops skipping still
-- returns the right rows (it only loses the optimization, not correctness),
-- so only the trace -- not the result -- would catch it.
-- [1]/[2]/[4]/[5]/[5b]: also traced, to show directly whether the build uses an
-- index-order skip plan for these predicates; see the B note above for why a
-- regression here is result-visible too.
-- [1]/[1b]/[1c]/[1d]/[1e]/[7]/[7g]/[7e]/[7f]/[7i] add c2 as an
-- ORDER BY tiebreaker, and [2]/[4]/[5] add it to their ORDER BY c1: ORDER BY c1 alone
-- does not fully determine row order when c1 has duplicates, so an index-scan
-- plan and a plain SORT/USING INDEX NONE plan could legally disagree on tie
-- order without either being wrong.
--
-- Schema:
--   w(c1, c2, c3)  : composite index (c1, c2, c3), c1/c2 nullable, c3 schema NOT NULL
--   w0(c1, c2, c3) : same shape as w, but no NULLs in the data (regression baseline)
--   w2(c1)         : single-column index on a nullable column, no other proof available
--   t(c1, c2)      : both nullable, no schema NOT NULL -- proof comes from query terms
--   u(c1, c2)      : composite index (c1, c2), including a (NULL, NULL) row
--   v(x)           : subquery source
--   oa/ob          : LEFT OUTER JOIN test tables with unmatched oa rows
-- ============================================================================

set system parameters 'dont_reuse_heap_file=yes';

drop table if exists w;
drop table if exists w0;
drop table if exists w2;
drop table if exists t;
drop table if exists u;
drop table if exists v;
drop table if exists oa;
drop table if exists ob;

create table w (c1 int, c2 int, c3 int not null);
create index i_w_c1_c2_c3 on w (c1, c2, c3);
insert into w values
  (1,10,100),(1,11,101),
  (NULL,NULL,200),(NULL,21,201),(NULL,22,202),
  (2,NULL,300);

create table w0 (c1 int, c2 int, c3 int not null);
create index i_w0_c1_c2_c3 on w0 (c1, c2, c3);
insert into w0 values (1,10,100),(1,11,101),(2,20,200),(2,21,201),(3,30,300);

create table w2 (c1 int);
create index i_w2_c1 on w2 (c1);
insert into w2 values (1),(1),(NULL),(NULL),(NULL),(2);

create table t (c1 int, c2 int);
create index i_t_c1_c2 on t (c1, c2);
insert into t values (3,1),(3,NULL),(3,7),(NULL,5),(NULL,NULL),(2,NULL);

evaluate '[7] w: trailing key c3 is schema NOT NULL and unreferenced in the query: ORDER BY skip without any IS NOT NULL; c2 added as a tiebreaker so row order is fully determined';
set trace on;
select c1, c2 from w order by c1, c2;
show trace;
set trace off;

evaluate '[7-control] same query, index forced off: ground truth for [7]';
select c1, c2 from w using index none order by c1, c2;

evaluate '[7g] t: where c2 > 0 order by c1: term proves c2 NOT NULL, c1 may still be NULL, must survive skip; c2 added as a tiebreaker';
set trace on;
select c1, c2 from t where c2 > 0 order by c1, c2;
show trace;
set trace off;

evaluate '[7g-control] same query, index forced off: ground truth for [7g]';
select c1, c2 from t where c2 > 0 using index none order by c1, c2;

evaluate '[7b] w: same as [7], under GROUP BY skip, NULL group must survive';
set trace on;
select c1, count(*) from w group by c1;
show trace;
set trace off;

evaluate '[7b-control] same query, index forced off: ground truth for [7b]';
select c1, count(*) from w group by c1 using index none;

evaluate '[7i] t: where c1 = 3 or c2 = 1 order by c1: OR breaks the NOT NULL proof, must NOT skip; c2 added as a tiebreaker';
select c1, c2 from t where c1 = 3 or c2 = 1 order by c1, c2;

evaluate '[7i-control] same query, index forced off: ground truth for [7i]';
select c1, c2 from t where c1 = 3 or c2 = 1 using index none order by c1, c2;

evaluate '[7j] w: group by c1 with rollup: WITH ROLLUP must NOT skip';
select c1, count(*) from w group by c1 with rollup;

evaluate '[7j-control] same query, index forced off: ground truth for [7j]';
select c1, count(*) from w group by c1 with rollup using index none;

evaluate '[7c] w2: single-column index on a nullable column must NOT skip GROUP BY';
select c1, count(*) from w2 group by c1;

evaluate '[7c-control] same query, index forced off: ground truth for [7c]';
select c1, count(*) from w2 group by c1 using index none;

evaluate '[7d] w: same as [7b], descending index scan path (no extra sort node)';
set trace on;
select c1, count(*) from w group by c1 desc;
show trace;
set trace off;

evaluate '[7d-control] same query, index forced off: ground truth for [7d]';
select c1, count(*) from w group by c1 desc using index none;

evaluate '[7e] w: same as [7], descending index scan path (qo_check_orderby_skip_descending, a separate function from [7d]s); c2 added as a tiebreaker so row order is fully determined';
set trace on;
select c1, c2 from w order by c1 desc, c2 desc;
show trace;
set trace off;

evaluate '[7e-control] same query, index forced off: ground truth for [7e]';
select c1, c2 from w using index none order by c1 desc, c2 desc;

evaluate '[7f] w0: same query as [7], but no NULLs anywhere in the data: regression baseline; c2 added as a tiebreaker';
set trace on;
select c1, c2 from w0 order by c1, c2;
show trace;
set trace off;

evaluate '[7f-control] same query, index forced off: ground truth for [7f]';
select c1, c2 from w0 using index none order by c1, c2;

create table u (c1 int, c2 int);
create index i_u_c1_c2 on u (c1, c2);
insert into u values (3,1),(NULL,5),(NULL,NULL),(2,NULL);

create table v (x int);
insert into v values (1),(5);

create table oa (i int);
insert into oa values (1),(2),(3);
create table ob (i int, j int);
insert into ob values (1, 10);

evaluate '[1] c1 = all (empty subquery): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker so row order is fully determined';
set trace on;
select c1, c2 from u where c1 = all (select c1 from u where c1 > 1000) order by c1, c2;
show trace;
set trace off;

evaluate '[1-control] same query, index forced off: ground truth for [1]';
select c1, c2 from u where c1 = all (select c1 from u where c1 > 1000) using index none order by c1, c2;

evaluate '[1b] c1 not in (empty subquery): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
select c1, c2 from u where c1 not in (select c1 from u where c1 > 1000) order by c1, c2;

evaluate '[1b-control] same query, index forced off: ground truth for [1b]';
select c1, c2 from u where c1 not in (select c1 from u where c1 > 1000) using index none order by c1, c2;

evaluate '[2] not exists (correlated subquery with no match against the sort column): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker; NO_UNNEST keeps this a plain correlated predicate instead of being unnested into an ANTI JOIN, so it actually reaches qo_check_nullable_op()';
set trace on;
select c1, c2 from u where not exists (select /*+ NO_UNNEST */ 1 from v where v.x = u.c1) order by c1, c2;
show trace;
set trace off;

evaluate '[2-control] same query, index forced off: ground truth for [2]';
select c1, c2 from u where not exists (select /*+ NO_UNNEST */ 1 from v where v.x = u.c1) using index none order by c1, c2;

evaluate '[3] left outer join + j = all (empty subquery): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j = all (select x from v where x > 1000) order by oa.i;

evaluate '[3b] left outer join + j not in (empty subquery): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j not in (select x from v where x > 1000) order by oa.i;

evaluate '[3c] left outer join + not exists (correlated on ob.j): padding rows must survive, join must stay outer; NO_UNNEST keeps this a plain correlated predicate instead of being unnested into an ANTI JOIN, so it actually reaches qo_check_nullable_op()';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where not exists (select /*+ NO_UNNEST */ 1 from v where v.x = ob.j) order by oa.i;

evaluate '[1c] c1 not in ? (host variable bound to an empty set): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
prepare stmt_1c from 'select c1, c2 from u where c1 not in ? order by c1, c2';
execute stmt_1c using {};

evaluate '[1c-control] same query, index forced off: ground truth for [1c]';
prepare stmt_1c_ctrl from 'select c1, c2 from u where c1 not in ? using index none order by c1, c2';
execute stmt_1c_ctrl using {};

evaluate '[1d] c1 = all {} (empty set literal, not a subquery): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
select c1, c2 from u where c1 = all {} order by c1, c2;

evaluate '[1d-control] same query, index forced off: ground truth for [1d]';
select c1, c2 from u where c1 = all {} using index none order by c1, c2;

evaluate '[1e] c1 not in {} (empty set literal, not a subquery): (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
select c1, c2 from u where c1 not in {} order by c1, c2;

evaluate '[1e-control] same query, index forced off: ground truth for [1e]';
select c1, c2 from u where c1 not in {} using index none order by c1, c2;

evaluate '[4] (c1 > 0) is not true: (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
set trace on;
select c1, c2 from u where (c1 > 0) is not true order by c1, c2;
show trace;
set trace off;

evaluate '[4-control] same query, index forced off: ground truth for [4]';
select c1, c2 from u where (c1 > 0) is not true using index none order by c1, c2;

evaluate '[3d] left outer join + j <=> null (NULLSAFE_EQ): padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where ob.j <=> null order by oa.i;

evaluate '[5] (c1 > 0) is unknown: (NULL,NULL) must survive ORDER BY skip; c2 added as a tiebreaker';
set trace on;
select c1, c2 from u where (c1 > 0) is unknown order by c1, c2;
show trace;
set trace off;

evaluate '[5-control] same query, index forced off: ground truth for [5]';
select c1, c2 from u where (c1 > 0) is unknown using index none order by c1, c2;

evaluate '[5b] (c1 > 0) is unknown, group by c1: NULL group must survive GROUP BY skip';
set trace on;
select c1, count(*) from u where (c1 > 0) is unknown group by c1;
show trace;
set trace off;

evaluate '[5b-control] same query, index forced off: ground truth for [5b]';
select c1, count(*) from u where (c1 > 0) is unknown group by c1 using index none;

evaluate '[6] left outer join + j is unknown: padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where (ob.j > 0) is unknown order by oa.i;

evaluate '[6b] same as [6], through an inline view on the inner side';
select oa.i, d.i, d.j from oa left outer join (select i, j from ob) d on oa.i = d.i
where (d.j > 0) is unknown order by oa.i;

drop table if exists w;
drop table if exists w0;
drop table if exists w2;
drop table if exists t;
drop table if exists u;
drop table if exists v;
drop table if exists oa;
drop table if exists ob;

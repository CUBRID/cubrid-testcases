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
--      [7h]  WHERE c1 = 3 ORDER BY c2: equality on the leading key permits scanning by c2
--      [7b]  same as [7], under GROUP BY skip
--
--    Negative (skip must NOT fire) -- PR review Test table:
--      [7i]  same as [7h] but with OR: the NOT NULL proof breaks
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
--    Regression (reviewer, first pass, 2026-09-04):
--      [1]   c2 = ALL (empty subquery)
--      [1b]  c2 NOT IN (empty subquery)
--      [2]   NOT EXISTS (correlated subquery)
--      [3]   j = ALL (empty subquery), outer join
--      [3b]  j NOT IN (empty subquery), outer join
--      [3c]  NOT EXISTS (correlated on j), outer join
--
--    Regression (reviewer, second pass, 2026-09-16):
--      [1c]  c2 NOT IN ? (host variable bound to {})
--      [1d]  c2 = ALL {} (empty set literal)
--      [1e]  c2 NOT IN {} (empty set literal)
--      [4]   (c2 > 0) IS NOT TRUE
--      [3d]  j <=> NULL (NULLSAFE_EQ), outer join
--
--    Regression (reviewer, exhaustive 70-predicate sweep, 2026-09-22):
--      [5]   (c2 > 0) IS UNKNOWN
--      [5b]  same as [5], under GROUP BY skip
--      [6]   j IS UNKNOWN, outer join
--      [6b]  same as [6], through an inline view
--
--    Regression (follow-up, e0d5fc622, found via CI, 2026-09-18):
--      [8]   ENUM column IN (nonempty literal list): the list is rewritten to a
--            PT_FUNCTION by pt_fix_enumeration_comparison() and was wrongly
--            treated as possibly-empty, the opposite misclassification direction
--            from [1]/[1b]/[1c]/[1d]/[1e] (a genuinely nonempty set wrongly
--            disqualified as NOT NULL proof, instead of a possibly-empty one
--            wrongly accepted)
--
-- For ORDER BY/GROUP BY skip cases, each [N-control] executes the same query
-- with USING INDEX NONE. The normal query and its control must return the
-- same result, including rows whose index key contains NULL.
--
-- For outer join cases, unmatched NULL-padding rows must remain in the result;
-- the LEFT OUTER JOIN must not be incorrectly reduced to an INNER JOIN.
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

evaluate '[7] w: trailing key c3 is schema NOT NULL and unreferenced in the query: ORDER BY skip without any IS NOT NULL';
select c1, c2 from w order by c1;

evaluate '[7-control] same query, index forced off: ground truth for [7]';
select c1, c2 from w using index none order by c1;

evaluate '[7g] t: where c2 > 0 order by c1: term proves c2 NOT NULL, c1 may still be NULL, must survive skip';
select c1, c2 from t where c2 > 0 order by c1;

evaluate '[7g-control] same query, index forced off: ground truth for [7g]';
select c1, c2 from t where c2 > 0 using index none order by c1;

evaluate '[7h] t: where c1 = 3 order by c2: equality on the leading key permits scanning ordered by c2';
select c1, c2 from t where c1 = 3 order by c2;

evaluate '[7h-control] same query, index forced off: ground truth for [7h]';
select c1, c2 from t where c1 = 3 using index none order by c2;

evaluate '[7b] w: same as [7], under GROUP BY skip, NULL group must survive';
select c1, count(*) from w group by c1;

evaluate '[7b-control] same query, index forced off: ground truth for [7b]';
select c1, count(*) from w group by c1 using index none;

evaluate '[7i] t: where c1 = 3 or c2 = 1 order by c1: OR breaks the NOT NULL proof, must NOT skip';
select c1, c2 from t where c1 = 3 or c2 = 1 order by c1;

evaluate '[7i-control] same query, index forced off: ground truth for [7i]';
select c1, c2 from t where c1 = 3 or c2 = 1 using index none order by c1;

evaluate '[7j] w: group by c1 with rollup: WITH ROLLUP must NOT skip';
select c1, count(*) from w group by c1 with rollup;

evaluate '[7j-control] same query, index forced off: ground truth for [7j]';
select c1, count(*) from w group by c1 with rollup using index none;

evaluate '[7c] w2: single-column index on a nullable column must NOT skip GROUP BY';
select c1, count(*) from w2 group by c1;

evaluate '[7c-control] same query, index forced off: ground truth for [7c]';
select c1, count(*) from w2 group by c1 using index none;

evaluate '[7d] w: same as [7b], descending index scan path (no extra sort node)';
select c1, count(*) from w group by c1 desc;

evaluate '[7d-control] same query, index forced off: ground truth for [7d]';
select c1, count(*) from w group by c1 desc using index none;

evaluate '[7e] w: same as [7], descending index scan path (qo_check_orderby_skip_descending, a separate function from [7d]s); c2 added as a tiebreaker so row order is fully determined';
select c1, c2 from w order by c1 desc, c2 desc;

evaluate '[7e-control] same query, index forced off: ground truth for [7e]';
select c1, c2 from w using index none order by c1 desc, c2 desc;

evaluate '[7f] w0: same query as [7], but no NULLs anywhere in the data: regression baseline';
select c1, c2 from w0 order by c1;

evaluate '[7f-control] same query, index forced off: ground truth for [7f]';
select c1, c2 from w0 using index none order by c1;

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

evaluate '[5] (c2 > 0) is unknown: (NULL,NULL) and (2,NULL) must survive ORDER BY skip';
select c1, c2 from u where (c2 > 0) is unknown order by c1;

evaluate '[5-control] same query, index forced off: ground truth for [5]';
select c1, c2 from u where (c2 > 0) is unknown using index none order by c1;

evaluate '[5b] (c2 > 0) is unknown, group by c1: (NULL,NULL) and (2,NULL) groups must survive GROUP BY skip';
select c1, count(*) from u where (c2 > 0) is unknown group by c1;

evaluate '[5b-control] same query, index forced off: ground truth for [5b]';
select c1, count(*) from u where (c2 > 0) is unknown group by c1 using index none;

evaluate '[6] left outer join + j is unknown: padding rows must survive, join must stay outer';
select oa.i, ob.i, ob.j from oa left outer join ob on oa.i = ob.i
where (ob.j > 0) is unknown order by oa.i;

evaluate '[6b] same as [6], through an inline view on the inner side';
select oa.i, d.i, d.j from oa left outer join (select i, j from ob) d on oa.i = d.i
where (d.j > 0) is unknown order by oa.i;

create table te (c1 int, c2 enum('Mon','Tue','Wed','Thu','Fri'));
create index i_te_c1_c2 on te (c1, c2);
insert into te values (NULL,'Mon'), (NULL,'Tue'), (1,'Wed'), (2,'Thu');

evaluate '[8] te: c2 in (nonempty enum literal list, rewritten to PT_FUNCTION by pt_fix_enumeration_comparison) proves c2 NOT NULL, c1 may still be NULL, must survive skip (CBRD-26259 e0d5fc622)';
select c1, c2 from te where c2 in ('Mon','Tue','Wed','Thu') order by c1;

evaluate '[8-control] same query, index forced off: ground truth for [8]';
select c1, c2 from te where c2 in ('Mon','Tue','Wed','Thu') using index none order by c1;

drop table if exists w;
drop table if exists w0;
drop table if exists w2;
drop table if exists t;
drop table if exists u;
drop table if exists v;
drop table if exists oa;
drop table if exists ob;
drop table if exists te;

/**
 * CBRD-27215 (PR #7658 review round 2): a compiled scan-filter leaf must verify the runtime type of a
 * TYPE_CONSTANT operand.  A recursive CTE declares column n as INTEGER (anchor) but the recursive branch
 * refills the slot with the BIGINT of count (); the correlated filter k <= c.n inside the subquery then
 * compares an INTEGER attribute with a BIGINT value.  The interpreter (eval_pred_comp0 () /
 * eval_value_rel_cmp ()) coerces; a typed leaf reading db_get_int () would assert (debug) or compare the
 * low 32 bits (release).  Host-variable sides (TYPE_POS_VALUE) must keep the guard they already have.
 */

drop table if exists r;
create table r (k int, v int);
insert into r values (1, 10), (2, 20), (3, 30), (4, 40), (5, 50);

-- reviewer's repro: develop 1, 2, 4, 8 (values stay below 2^32, so a low-half read is wrong only in debug)
with recursive c(n) as (select 1 union all select (select count(*) from r where k <= c.n) + c.n from c where n < 5) select * from c;

-- the drifted value exceeds 32 bits: a low-half read compares k <= 0 and yields (3, 0) instead of (3, 21474836480)
with recursive c(i, n) as (select 1, 1 union all select i + 1, (select count(*) from r where k <= c.n) * 4294967296 from c where i < 3) select i, n from c;

-- drift on the other side of the leaf (c.n >= k) and with a different operator
with recursive c(i, n) as (select 1, 1 union all select i + 1, (select count(*) from r where c.n >= k) * 4294967296 from c where i < 3) select i, n from c;

-- host-variable side of a scan filter: the same leaf shape bound to INTEGER, BIGINT and NUMERIC
$int, $3
select k from r where k <= ? order by k;
$bigint, $4294967296
select k from r where k <= ? order by k;
$numeric, $2.5
select k from r where k <= ? order by k;
$int, $3
select k from r where ? >= k order by k;
select k from r where k <= 3 order by k;
select k from r where k <= 4294967296 order by k;

drop table r;

--   hostvar/literal selects: k = 1,2,3 / 1..5 / 1,2 / 1,2,3 / 1,2,3 / 1..5
-- Place in cubrid-testcases sql/_13_issues/_26_2h/cases/cbrd_27215_scan_const_drift.sql (tc/pr-7658, alongside the five cbrd_27215_* cases).

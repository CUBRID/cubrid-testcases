/**
 * CBRD-27215 (PR #7658 review round 2): a comparison term fetches its right operand only for a non-NULL
 * left one and LIKE fetches its pattern/escape only for a non-NULL source (eval_pred ()), so a right side
 * that would fail (division by zero) must not fail on the rows whose left side is NULL.  DECODE compares
 * with R_EQ_TORDER, fetches both sides and keeps failing.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, s varchar(20));
insert into t1 values (1, NULL, 1, 0, 'abc');
insert into t1 values (2, 1, 2, 0, 'ABC');
insert into t1 values (3, 2, 3, 1, 'abd');
insert into t1 values (4, 0, 5, 0, NULL);

-- NULL left operand: the interpreted path never fetches b / c
select case when a > b / c then 1 else 0 end from t1 where id = 1;
select if(a > b / c, 1, 0) from t1 where id = 1;
select (a > b / c) from t1 where id = 1;
select sum(case when a > b / c then 1 else 0 end) from t1 where id = 1;
select case when a = b / c then 1 else 0 end from t1 where id = 1;
select id, case when a > b / c then 1 else 0 end from t1 where id in (1, 3) order by id;

-- NULL LIKE source: the pattern (and the escape) are never fetched
select case when s like cast(b / c as varchar) then 1 else 0 end from t1 where id = 4;
select case when s like cast(b / c as varchar) escape '#' then 1 else 0 end from t1 where id = 4;
select if(s like cast(b / c as varchar), 1, 0) from t1 where id = 4;

-- controls: the interpreted path does fetch the right side here, so these fail on develop as well
select case when a > b / c then 1 else 0 end from t1 where id = 2;
select case when s like cast(b / c as varchar) then 1 else 0 end from t1 where id = 2;
select decode(a, b / c, 1, 0) from t1 where id = 1;

-- controls: no fallible right-hand step, still compiled
select id, case when a < b then 1 else 0 end from t1 order by id;
select id, decode(a, b, 1, 0) from t1 order by id;
select id, case when s like '%d' then 1 else 0 end from t1 order by id;

drop table t1;

--   block 1: 0 / 0 / NULL / 0 / 0 / rows (1,0),(3,0)          -- PR head 0acc72bfb: ER_QPROC_ZERO_DIVIDE on all six
--   block 2: 0 / 0 / 0                                          -- PR head: ER_QPROC_ZERO_DIVIDE on all three
--   block 3: Division by zero error x3 on develop AND on the PR (a=1 non-NULL; s='ABC' non-NULL; DECODE fetches both)
--   block 4: (1,0),(2,1),(3,1),(4,1) / (1,0),(2,0),(3,0),(4,0) / (1,0),(2,0),(3,1),(4,0)
--   ESCAPE is grammatically a literal/host variable only (csql_grammar.y:20790), so the escape variant makes the
--   pattern fail; 'ABC' is avoided in the LIKE control ('%d') so the answer does not depend on the collation.

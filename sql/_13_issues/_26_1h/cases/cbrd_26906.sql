/**
 *  This test case verifies CBRD-26906 : USE INDEX hint ignored when optimizer picks
 *  sequential scan over hinted index on non-covering index with low-distinct leading column.
 *
 *  Root cause: CBRD-24044 removed the branch that skipped seq scan when a normal index plan
 *  existed. Now seq scan always competes, and sel_limit = 1/pkeys inflates non-covering index
 *  heap_access cost, causing seq scan to win and the USE INDEX hint to be overridden.
 *
 *  Scenarios:
 *   [1] Basic reproduction: USE INDEX on non-covering index, low distinct leading column
 *   [2] FORCE INDEX vs USE INDEX comparison on same data
 *   [3] Non-indexed column (colc) filter variations: IS NULL / IN / !=
 *   [4] Actual column retrieval
 */

drop table if exists tbl;

create table tbl (cola varchar(20), colb varchar(20), colc varchar(20), cold varchar(20));
insert into tbl select mod(rownum,3), mod(rownum,2), mod(rownum,2), rownum
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 300000;
create index idx_non_covering on tbl(cola,colb,cold);  -- non-covering (colc excluded)
create index idx_covering on tbl(cola,colb,colc,cold); -- covering
update statistics on tbl;

-- ============================================================
-- [Scenario 1] Basic reproduction
--   USE INDEX on non-covering index with low distinct leading column (cola distinct=3).
--   Optimizer should select idx_non_covering (iscan), not sequential scan.
-- ============================================================
evaluate '[Scenario 1] Basic reproduction: USE INDEX on non-covering index, low distinct leading column';

select /*+ recompile */ count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 2] FORCE INDEX vs USE INDEX comparison
--   FORCE INDEX: cost forced to 0 -> always iscan (reference baseline).
--   USE INDEX(idx_covering): covering index, no heap cost inflation -> should be iscan.
-- ============================================================
evaluate '[Scenario 2a] FORCE INDEX on non-covering index (cost-zero baseline)';

select /*+ recompile */ count(*) from tbl force index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc='1';

evaluate '[Scenario 2b] USE INDEX on covering index (no heap cost inflation)';

select /*+ recompile */ count(*) from tbl use index (idx_covering)
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 3] Non-indexed column (colc) filter variations
--   Verify USE INDEX hint is honored regardless of predicate type on colc.
-- ============================================================
evaluate '[Scenario 3a] colc IS NULL filter on non-indexed column';

select /*+ recompile */ count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc is null;

evaluate '[Scenario 3b] colc IN condition on non-indexed column';

select /*+ recompile */ count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc in ('0','1');

evaluate '[Scenario 3c] colc negation (!=) condition on non-indexed column';

select /*+ recompile */ count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc <> '0';

-- ============================================================
-- [Scenario 4] Actual column retrieval — result correctness verification
-- ============================================================
evaluate '[Scenario 4] Actual column retrieval from non-covering index';

select /*+ recompile */ cola, colb, colc, cold from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc='1'
order by cola, colb, colc, cold
limit 10;

drop table if exists tbl;

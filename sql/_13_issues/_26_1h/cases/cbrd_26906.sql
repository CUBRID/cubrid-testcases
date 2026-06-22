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
 *   [3] Non-indexed column (colc) filter variations: IS NULL / IN
 *   [4] No-hint baseline: optimizer selects sequential scan on its own
 *   [5] USE INDEX with multiple index names: optimizer chooses among them
 *   [6] USING INDEX NONE forces sequential scan
 *   [7] GROUP BY uses the hinted index
 *   [8] JOIN: hinted index used on the big table node
 *   [9] UPDATE with USE INDEX uses the hinted index
 *   [10] DELETE with USE INDEX uses the hinted index
 *   [11] Stale statistics: hinted index still used after inserting rows without re-gathering stats
 */

drop table if exists tbl;

create table tbl (cola varchar(20), colb varchar(20), colc varchar(20), cold varchar(20));
insert into tbl select mod(rownum,3), mod(rownum,2), mod(rownum,2), rownum from db_class a, db_class b, db_class c, db_class d, db_class e limit 300000;
-- non-covering (colc excluded)
create index idx_non_covering on tbl(cola,colb,cold);
-- covering
create index idx_covering on tbl(cola,colb,colc,cold);
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
-- [Scenario 2] USE INDEX on covering index (no heap cost inflation)
--   Covering index has no heap access -> no cost inflation -> should always be iscan.
--   Contrasts with Scenario 1 to isolate the problem to heap cost calculation.
-- ============================================================
evaluate '[Scenario 2] USE INDEX on covering index (no heap cost inflation)';

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

-- ============================================================
-- [Scenario 4] No-hint baseline
--   Confirm optimizer picks sequential scan without any index hint.
--   Establishes that the bug condition (sscan winning) is reproducible.
-- ============================================================
evaluate '[Scenario 4] no-hint baseline: optimizer selects sequential scan on its own';

select /*+ recompile */ count(*) from tbl
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 5] USE INDEX with multiple index names
--   Optimizer chooses between non-covering and covering when both are hinted.
--   Verifies hint is not ignored when multiple candidates are provided.
-- ============================================================
evaluate '[Scenario 5] USE INDEX with multiple index names: optimizer chooses among them';

select /*+ recompile */ count(*) from tbl use index (idx_non_covering, idx_covering)
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 6] USING INDEX NONE
--   Explicitly forbids index usage, forcing sequential scan.
-- ============================================================
evaluate '[Scenario 6] USING INDEX NONE forces sequential scan';

select /*+ recompile */ count(*) from tbl
where cola between '0' and '9' and colb='1' and colc='1'
using index none;

-- ============================================================
-- [Scenario 7] GROUP BY with USE INDEX
--   Verifies hint is honored when GROUP BY is present.
-- ============================================================
evaluate '[Scenario 7] GROUP BY uses the hinted index (index scan)';

select /*+ recompile */ cola, count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1'
group by cola
order by cola;

-- ============================================================
-- [Scenario 8] JOIN with USE INDEX
--   Verifies hint is honored on the big table inside a join.
-- ============================================================
evaluate '[Scenario 8] JOIN: hinted index used on the big table node, not seq scan';

create table dim (k varchar(20), v int);
insert into dim values ('0', 0), ('1', 1), ('2', 2);
update statistics on dim;

select /*+ recompile */ count(*)
from tbl use index (idx_non_covering) inner join dim on tbl.cola = dim.k
where tbl.cola between '0' and '9' and tbl.colb='1' and tbl.colc='1';

drop table if exists dim;

-- ============================================================
-- [Scenario 9] UPDATE with USE INDEX
--   Verifies hint is honored in an UPDATE statement.
-- ============================================================
evaluate '[Scenario 9] UPDATE with USE INDEX uses the hinted index (index scan)';

update /*+ recompile */ tbl use index (idx_non_covering) set cold = cold
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 10] DELETE with USE INDEX
--   Verifies hint is honored in a DELETE statement.
-- ============================================================
evaluate '[Scenario 10] DELETE with USE INDEX uses the hinted index (index scan)';

delete /*+ recompile */ from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc='1';

-- ============================================================
-- [Scenario 11] Stale statistics
--   Rows added without re-gathering stats. Verifies hint is still honored
--   under stale statistics, which is an additional reproduction condition from the bug report.
-- ============================================================
evaluate '[Scenario 11] stale statistics: add rows without re-gathering stats, hinted index still used (index scan)';

insert into tbl select mod(rownum,3), mod(rownum,2), mod(rownum,2), rownum + 300000
  from db_class a, db_class b, db_class c, db_class d, db_class e limit 100000;
select /*+ recompile */ count(*) from tbl use index (idx_non_covering)
where cola between '0' and '9' and colb='1' and colc='1';
update statistics on tbl;

drop table if exists tbl;

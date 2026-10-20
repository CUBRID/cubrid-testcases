/*
 * This test case verifies CBRD-27113 : the index scan cost model underpriced
 * high-fanout index scans, so multi-join queries picked join orders that built
 * large intermediate results.
 *
 * Bug: qo_iscan_cost () priced the heap fetch of a NON-covering index scan by
 * pages only (opages * sel), so a probe that fetches hundreds of rows cost
 * about the same as a one-row primary-key probe, and the leaf pages of a
 * nested-loop inner index scan were charged once (fixed_io_cost) instead of
 * once per outer row.
 *
 * Fix: the per-row heap fetch is charged per qualifying row (heap_rows *
 * ISCAN_OID_ACCESS_OVERHEAD plus the page estimate of those rows), and the
 * leaf pages beyond the landing leaf moved to the variable side so that
 * qo_nljoin_cost () multiplies them by the outer cardinality. Later cost work
 * (CBRD-27094) reshaped these terms but kept both properties.
 *
 * Data: ic_dim 1,000 rows (grp 0..49, 20 rows per grp), ic_fact 20,000 rows
 * (20 rows per dim_id, 400 rows per grp, ~100-byte rows so the table is
 * ~200 pages), ic_sub 10,000 rows (one row per even ic_fact.id), ic_heap
 * 20,000 rows (rem = id mod 3, ~100-byte rows). Statistics are collected
 * WITH FULLSCAN, so every predicate below is measured by the column
 * histogram and the plan is a pure cost decision.
 * Cases 1, 3 and 4 keep the same plan before and after the fix: they guard
 * against over-pricing the per-row heap fetch or the per-probe leaf IO
 * (a regression there shows sscan or hash-join). Case 2 is the one whose
 * plan changes with the fix.
 *   Case 1: selective non-covering predicate (grp = 8, 2% of the rows,
 *           400 rows fetched from the heap) -> iscan on i_ic_fact_grp.
 *           A regression that over-prices the per-row heap fetch shows sscan.
 *   Case 2: non-selective non-covering predicate on ic_heap (rem in (0, 1),
 *           two thirds of 20,000 rows, ~185 pages) -> sscan. This is the
 *           case that flips with the fix: before it, the heap fetch of the
 *           index scan was priced by pages only (opages * sel, fewer pages
 *           than one pass over the table), so iscan on i_ic_heap_rem looked
 *           cheaper than reading the table once. Charging each of the
 *           ~13,000 fetched rows makes the iscan cost more than the sscan.
 *           A model that forgets the per-row heap cost shows iscan.
 *   Case 3: NL join dim -> fact: the filtered ic_dim (20 rows) drives and
 *           ic_fact is probed through i_ic_fact_dim (20 rows per probe)
 *           -> idx-join, outer sscan ic_dim, inner iscan ic_fact.
 *           A regression shows hash-join or ic_fact as the outer side.
 *   Case 4: three-table chain dim -> fact -> sub: both inner sides are
 *           index probes (i_ic_fact_dim, i_ic_sub_fact) and ic_dim drives.
 */
drop table if exists ic_heap, ic_sub, ic_fact, ic_dim, ic_d;

create table ic_d (n int primary key);
insert into ic_d values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create table ic_dim (id int primary key, grp int, pad char(50));
create table ic_fact (id int primary key, dim_id int, grp int, pad char(100));
create index i_ic_fact_dim on ic_fact (dim_id);
create index i_ic_fact_grp on ic_fact (grp);
create table ic_sub (id int primary key, fact_id int, pad char(50));
create index i_ic_sub_fact on ic_sub (fact_id);
create table ic_heap (id int primary key, rem int, pad char(100));
create index i_ic_heap_rem on ic_heap (rem);

-- ic_dim: 1,000 rows, grp = id mod 50
insert into ic_dim
select x.id, mod (x.id, 50), 'd'
from (select a.n + 10 * b.n + 100 * c.n as id from ic_d a, ic_d b, ic_d c) x;

-- ic_fact: 20,000 rows, 20 rows per dim_id, 400 rows per grp
insert into ic_fact
select x.id, mod (x.id, 1000), mod (x.id, 50), 'f'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * f.n as id
      from ic_d a, ic_d b, ic_d c, ic_d e, ic_d f where f.n < 2) x;

-- ic_sub: 10,000 rows, fact_id = 2 * id (every even ic_fact.id has one row)
insert into ic_sub
select x.id, 2 * x.id, 's'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as id from ic_d a, ic_d b, ic_d c, ic_d e) x;

-- ic_heap: 20,000 rows, rem = id mod 3 (6,667 / 6,667 / 6,666 rows per value)
insert into ic_heap
select x.id, mod (x.id, 3), 'h'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * f.n as id
      from ic_d a, ic_d b, ic_d c, ic_d e, ic_d f where f.n < 2) x;

update statistics on ic_dim, ic_fact, ic_sub, ic_heap with fullscan;

select count(*) from ic_dim;
select count(*) from ic_fact;
select count(*) from ic_sub;
select count(*) from ic_heap;

-- Case 1: selective, non-covering (pad forces the heap fetch) -> iscan i_ic_fact_grp
evaluate '[1] selective non-covering predicate: iscan on i_ic_fact_grp';
--@queryplan
select /*+ recompile */ count(pad) from ic_fact where grp = 8;

-- Case 2: non-selective, non-covering (two thirds of the rows) -> sscan;
--         the pages-only heap fetch model of the bug picks iscan i_ic_heap_rem
evaluate '[2] non-selective non-covering predicate: sscan on ic_heap';
--@queryplan
select /*+ recompile */ count(pad) from ic_heap where rem in (0, 1);

-- Case 3: NL join, filtered ic_dim drives, ic_fact probed through i_ic_fact_dim
evaluate '[3] NL join: idx-join with outer sscan ic_dim and inner iscan ic_fact (i_ic_fact_dim)';
--@queryplan
select /*+ recompile */ count(ft.pad)
from ic_dim dm, ic_fact ft
where dm.id = ft.dim_id and dm.grp = 8;

-- Case 4: three-table chain, both inner sides are index probes
evaluate '[4] chain dim -> fact -> sub: inner iscan i_ic_fact_dim then inner iscan i_ic_sub_fact';
--@queryplan
select /*+ recompile */ count(sb.pad)
from ic_dim dm, ic_fact ft, ic_sub sb
where dm.id = ft.dim_id and ft.id = sb.fact_id and dm.grp = 8;

drop table ic_heap, ic_sub, ic_fact, ic_dim, ic_d;

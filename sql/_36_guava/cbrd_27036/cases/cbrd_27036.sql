/*
 * This test case verifies CBRD-27036 : the selectivity of a LIKE with a fixed
 * prefix followed by more pattern structure (a middle %, a literal after %,
 * or _) must not be counted twice.
 *
 * Bug: qo_rewrite_like_for_index_scan() adds a prefix range term derived from
 * such a LIKE (v >= 'PRE' and v < 'PRF') and keeps the LIKE itself. The
 * optimizer multiplied both selectivities as if they were independent
 * (range 0.01 x like 0.1 by default), although the LIKE matches a subset of
 * the range, so the scan cardinality was underestimated by a factor of 100.
 * Fix: the derived range and the LIKE it came from are counted once, so the
 * estimate stays at the LIKE selectivity alone.
 *
 * The estimated cardinality is masked in CTP answers, so the case checks a
 * join order that depends on it. ns has 10000 rows and sm has 110 rows,
 * joined on the primary key of each table. The 500 rows of ns starting with
 * 'PRE' match every trigger pattern below, so the prefix range and the LIKE
 * select the same 5% of ns:
 *   - LIKE counted once: about 500 rows of ns (1000 with the default LIKE
 *     selectivity when no histogram is used) -> sm drives the nested loop
 *     join and probes ns through its primary key
 *   - LIKE counted twice: about 25 rows (10 with the defaults) -> ns drives
 *     the join through an index scan on v
 * Both estimates stay at least 4 times away from the size of sm, with or
 * without histograms, and sm driving the join is also the cheaper real plan.
 *
 * Coverage
 *   Case 1: v = 'PREAMID19' (control, ns is truly tiny) -> ns drives the join
 *   Case 2: v like '%MID%'   (control, no prefix range) -> sm drives the join
 *   Case 3: v like 'PRE%MID%' (prefix + middle %)       -> sm drives the join
 *   Case 4: v like 'PRE%9'    (prefix + literal after %) -> sm drives the join
 *   Case 5: v like 'PRE_MID%' (prefix + _)              -> sm drives the join
 *
 * The RECOMPILE hint is needed because auto-parameterization gives Cases 3-5
 * the same plan cache key; without it they would reuse the plan of Case 3.
 */
drop table if exists ns;
drop table if exists sm;

create table ns (id int primary key, v varchar(40));
insert into ns
select rownum,
       case when rownum <= 500 then 'PREAMID' || rownum || '9' else 'zzz' || rownum end
from db_class a, db_class b, db_class c limit 10000;
create index i_ns_v on ns(v);

create table sm (id int primary key, w int);
insert into sm select rownum * 50, rownum from db_class a, db_class b limit 110;

update statistics on ns, sm;

set trace on;

-- Case 1
select /*+ RECOMPILE */ count(*) from ns a, sm b where a.v = 'PREAMID19' and a.id = b.id;
show trace;

-- Case 2
select /*+ RECOMPILE */ count(*) from ns a, sm b where a.v like '%MID%' and a.id = b.id;
show trace;

-- Case 3
select /*+ RECOMPILE */ count(*) from ns a, sm b where a.v like 'PRE%MID%' and a.id = b.id;
show trace;

-- Case 4
select /*+ RECOMPILE */ count(*) from ns a, sm b where a.v like 'PRE%9' and a.id = b.id;
show trace;

-- Case 5
select /*+ RECOMPILE */ count(*) from ns a, sm b where a.v like 'PRE_MID%' and a.id = b.id;
show trace;

set trace off;

drop table ns;
drop table sm;

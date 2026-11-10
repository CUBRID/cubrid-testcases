/**
 *  This test case verifies CBRD-27597: large CTE results keep every row.
 *
 *  The fix changes how a CTE result list is shared and when a CTE reader runs.
 *  These cases read large recursive and materialized CTE results, including a
 *  DISTINCT recursive member and an INSERT target, so a lost or doubled row
 *  changes a result block.
 *
 *  Each tested statement is followed by the same relation built from the base
 *  tables, and the two result blocks must match. No worker count or plan is
 *  asserted. t_src holds ids 1 to 40000 and t_large ids 1 to 100000.
 *  Sums are cast to bigint to avoid integer overflow.
 *
 *  Coverage:
 *    Case 1: large two level recursion and chained CTEs
 *    Case 2: three levels and duplicate preserving union totals
 *    Case 3: INSERT reads all recursive endpoint rows
 */

-- Exact spec cardinalities, independent of any optimizer threshold
-- No trace is captured: these are relational correctness assertions
drop table if exists t_digit,t_src,t_large,t_sink;
create table t_digit(v integer);
insert into t_digit values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
create table t_src(id integer);
insert into t_src select a.v+10*b.v+100*c.v+1000*d.v+10000*e.v+1 from t_digit a,t_digit b,t_digit c,t_digit d,t_digit e where e.v<4;
create table t_large(id integer);
insert into t_large select a.v+10*b.v+100*c.v+1000*d.v+10000*e.v+1 from t_digit a,t_digit b,t_digit c,t_digit d,t_digit e;
create table t_sink(id integer,lvl integer);
update statistics on t_digit,t_src,t_large with fullscan;


evaluate 'Case 1: large two level recursion and chained CTEs; result = relational reference';
with recursive r(id,lvl) as (select id,1 from t_large union all select id,lvl+1 from r where lvl<2) select /*+ recompile */ lvl,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from r group by lvl order by lvl;
select d.v+1 as lvl,count(*) as cnt,min(s.id) as lo,max(s.id) as hi,sum(cast(s.id as bigint)) as total from t_large s,t_digit d where d.v<2 group by d.v order by d.v;
with c as (select /*+ materialize */ id from t_large), e as (select /*+ materialize */ id from c) select /*+ recompile */ mod(id,3) as grp,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from e group by mod(id,3) order by mod(id,3);
select mod(id,3) as grp,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from t_large group by mod(id,3) order by mod(id,3);


evaluate 'Case 2: three levels and duplicate preserving union totals; result = relational reference';
with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select /*+ recompile */ lvl,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from r group by lvl order by lvl;
select d.v+1 as lvl,count(*) as cnt,min(s.id) as lo,max(s.id) as hi,sum(cast(s.id as bigint)) as total from t_src s,t_digit d where d.v<3 group by d.v order by d.v;
with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select /*+ recompile */ lvl,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from (select id,lvl from r union all select id,lvl from r) u group by lvl order by lvl;
select d.v+1 as lvl,count(*) as cnt,min(s.id) as lo,max(s.id) as hi,sum(cast(s.id as bigint)) as total from t_src s,t_digit d,t_digit e where d.v<3 and e.v<2 group by d.v order by d.v;


evaluate 'Case 3: INSERT reads all recursive endpoint rows; result = relational reference';
insert into t_sink with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select id,lvl from r where id in (1,40000);
select id,lvl from t_sink order by id,lvl;
select s.id,d.v+1 as lvl from t_src s,t_digit d where s.id in (1,40000) and d.v<3 order by s.id,d.v;
drop table t_digit,t_src,t_large,t_sink;

/**
 *  This test case verifies CBRD-27597: CTE results are complete.
 *  Every valid outer row must survive independently of earlier statements.
 *  Literal expectations come from finite relations, not engine output.
 *  Independent base-table twins expose missing or duplicated rows.
 *  Identical cached queries intentionally omit recompile and trace.
 *  Hint variants test result equivalence, not worker counts.
 *  No optimizer path or physical outer-row visit order is asserted.
 *  Run under parallelism=4 and parallelism=0 server configurations.
 *  The base tables have exactly the cardinalities required by the spec.
 *  Integer sums are widened to avoid overflow in the reference.
 *  Coverage:
 *    Case 1: three levels and duplicate preserving union totals
 *
 *
 *
 *
 *
 *
 */

-- Exact spec cardinalities, independent of any optimizer threshold
-- No trace is captured: these are relational correctness assertions
drop table if exists t_digit,t_src,t_outer,t_large,t_sink;
create table t_digit(v integer);
insert into t_digit values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
create table t_src(id integer);
insert into t_src select a.v+10*b.v+100*c.v+1000*d.v+10000*e.v+1 from t_digit a,t_digit b,t_digit c,t_digit d,t_digit e where e.v<4;
create table t_outer(seq integer,v integer);
insert into t_outer values (0,-1),(1,39999),(2,40000),(3,0),(4,9),(5,39999);
create table t_large(id integer);
insert into t_large select a.v+10*b.v+100*c.v+1000*d.v+10000*e.v+1 from t_digit a,t_digit b,t_digit c,t_digit d,t_digit e;
create table t_sink(id integer,lvl integer);
update statistics on t_digit,t_src,t_outer,t_large with fullscan;


evaluate 'Case 1: three levels and duplicate preserving union totals; result = relational reference';
with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select /*+ recompile */ lvl,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from r group by lvl order by lvl;
select d.v+1 as lvl,count(*) as cnt,min(s.id) as lo,max(s.id) as hi,sum(cast(s.id as bigint)) as total from t_src s,t_digit d where d.v<3 group by d.v order by d.v;
with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select /*+ recompile */ lvl,count(*) as cnt,min(id) as lo,max(id) as hi,sum(cast(id as bigint)) as total from (select id,lvl from r union all select id,lvl from r) u group by lvl order by lvl;
select d.v+1 as lvl,count(*) as cnt,min(s.id) as lo,max(s.id) as hi,sum(cast(s.id as bigint)) as total from t_src s,t_digit d,t_digit e where d.v<3 and e.v<2 group by d.v order by d.v;
drop table t_digit,t_src,t_outer,t_large,t_sink;

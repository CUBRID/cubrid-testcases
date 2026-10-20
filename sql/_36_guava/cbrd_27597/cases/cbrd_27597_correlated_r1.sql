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
 *    Case 1: first correlated UNION ALL EXISTS count
 *    Case 2: all outer rows including both endpoints
 *    Case 3: NOT EXISTS has no qualifying outer row
 *    Case 4: single row scalar for every outer row
 *    Case 5: DISTINCT recursive member
 *    Case 6: UNION DISTINCT is equivalent for disjoint branches
 *    Case 7: identical text rerun in the same session
 *    Case 8: reversed output and changed correlation key
 *    Case 9: mixed misses repeated keys and source endpoints
 *    Case 10: empty recursive seed gives no EXISTS matches
 *    Case 11: nonrecursive CTE relational control
 *    Case 12: recursive CTE without outer UNION control
 *    Case 13: per block parallel zero hint keeps the same rows
 *    Case 14: parallel allowed with per block suppression hint
 *    Case 15: original text after reversed outer insertion order
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


evaluate 'Case 1: first correlated UNION ALL EXISTS count; result = relational reference';
select count(*) as cnt from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select count(*) as cnt from t_digit;


evaluate 'Case 2: all outer rows including both endpoints; result = relational reference';
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 3: NOT EXISTS has no qualifying outer row; result = relational reference';
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;


evaluate 'Case 4: single row scalar for every outer row; result = relational reference';
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 5: DISTINCT recursive member; result = relational reference';
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select distinct id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 6: UNION DISTINCT is equivalent for disjoint branches; result = relational reference';
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 7: identical text rerun in the same session; result = relational reference';
select count(*) as cnt from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select count(*) as cnt from t_digit;
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 8: reversed output and changed correlation key; result = relational reference';
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=(9-d.v)+1 and r.lvl=3 union all select v from t_digit where v=(9-d.v)+100) as got from t_digit d order by d.v desc;
select d.v,10-d.v as got from t_digit d order by d.v desc;
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=(9-d.v)+1 and r.lvl=3 union all select v from t_digit where v=(9-d.v)+100) order by d.v desc;
select d.v from t_digit d order by d.v desc;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=(9-d.v)+1 and r.lvl=3 union all select v from t_digit where v=(9-d.v)+100) order by d.v desc;
select d.v from t_digit d where 1=0 order by d.v desc;


evaluate 'Case 9: mixed misses repeated keys and source endpoints; result = relational reference';
select d.seq,d.v from t_outer d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.seq;
select d.seq,d.v from t_outer d where d.v between 0 and 39999 order by d.seq;
select d.seq,d.v from t_outer d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.seq;
select d.seq,d.v from t_outer d where d.v<0 or d.v>39999 order by d.seq;


evaluate 'Case 10: empty recursive seed gives no EXISTS matches; result = relational reference';
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src where id < 0 union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src where id < 0 union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 11: nonrecursive CTE relational control; result = relational reference';
select count(*) as cnt from t_digit d where exists (with r(id,lvl) as (select id,3 from t_src) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select count(*) as cnt from t_digit;
select d.v from t_digit d where exists (with r(id,lvl) as (select id,3 from t_src) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with r(id,lvl) as (select id,3 from t_src) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with r(id,lvl) as (select id,3 from t_src) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 12: recursive CTE without outer UNION control; result = relational reference';
select count(*) as cnt from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3);
select count(*) as cnt from t_digit;
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 13: per block parallel zero hint keeps the same rows; result = relational reference';
select /*+ recompile parallel(0) */ count(*) as cnt from t_digit d where exists (with recursive r(id,lvl) as (select /*+ parallel(0) */ id,1 from t_src union all select /*+ parallel(0) */ id,lvl+1 from r where lvl<3) select /*+ parallel(0) */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ parallel(0) */ v from t_digit where v=d.v+100);
select count(*) as cnt from t_digit;
select /*+ recompile parallel(0) */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select /*+ parallel(0) */ id,1 from t_src union all select /*+ parallel(0) */ id,lvl+1 from r where lvl<3) select /*+ parallel(0) */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ parallel(0) */ v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select /*+ recompile parallel(0) */ d.v from t_digit d where not exists (with recursive r(id,lvl) as (select /*+ parallel(0) */ id,1 from t_src union all select /*+ parallel(0) */ id,lvl+1 from r where lvl<3) select /*+ parallel(0) */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ parallel(0) */ v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select /*+ recompile parallel(0) */ d.v,(with recursive r(id,lvl) as (select /*+ parallel(0) */ id,1 from t_src union all select /*+ parallel(0) */ id,lvl+1 from r where lvl<3) select /*+ parallel(0) */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ parallel(0) */ v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 14: parallel allowed with per block suppression hint; result = relational reference';
select /*+ recompile no_parallel_scan */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select /*+ no_parallel_scan */ id,1 from t_src union all select /*+ no_parallel_scan */ id,lvl+1 from r where lvl<3) select /*+ no_parallel_scan */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ no_parallel_scan */ v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select /*+ recompile no_parallel_scan */ d.v from t_digit d where not exists (with recursive r(id,lvl) as (select /*+ no_parallel_scan */ id,1 from t_src union all select /*+ no_parallel_scan */ id,lvl+1 from r where lvl<3) select /*+ no_parallel_scan */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ no_parallel_scan */ v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select /*+ recompile no_parallel_scan */ d.v,(with recursive r(id,lvl) as (select /*+ no_parallel_scan */ id,1 from t_src union all select /*+ no_parallel_scan */ id,lvl+1 from r where lvl<3) select /*+ no_parallel_scan */ id from r where r.id=d.v+1 and r.lvl=3 union all select /*+ no_parallel_scan */ v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 15: original text after reversed outer insertion order; result = relational reference';
delete from t_digit;
insert into t_digit values (9),(8),(7),(6),(5),(4),(3),(2),(1),(0);
select count(*) as cnt from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select count(*) as cnt from t_digit;
select d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
select d.v from t_digit d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;
select d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;
drop table t_digit,t_src,t_outer,t_large,t_sink;

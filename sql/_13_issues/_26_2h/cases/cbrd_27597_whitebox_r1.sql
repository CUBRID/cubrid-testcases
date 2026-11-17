/**
 *  This test case verifies CBRD-27597: a CTE reader runs after its owner.
 *  Correlated set-query arms previously read an unexecuted CTE on the first row.
 *  Keep every matched outer row and preserve existing scalar error semantics.
 *
 *  Independent base-table twins and finite literal rows judge correctness.
 *  No timing, physical visitation order, or worker count is asserted.
 *  Recompile is used except for the prepared-plan reuse case.
 *  Error queries have a non-CTE twin and are followed by a valid query.
 *  DELETE and UPDATE are checked through their actual target rows.
 *
 *  Coverage:
 *    Case 1: INTERSECT retains the first and last matches
 *    Case 2: EXCEPT preserves rows absent from the right arm
 *    Case 3: both arms read one materialized nonrecursive CTE
 *    Case 4: CTE definition matching at first middle and last positions
 *    Case 5: nested WITH owner keeps its own CTE dependencies
 *    Case 6: non CTE arm remains a valid independent match
 *    Case 7: scalar aggregate above a derived UNION returns each value
 *    Case 8: no WITH and top level WITH controls retain their rows
 *    Case 9: NULL misses and repeated endpoints keep three valued semantics
 *    Case 10: DELETE observes every match and deletes real missing rows
 *    Case 11: UPDATE changes matched values rather than only row counts
 *    Case 12: multirow scalar raises the same error then valid CTE runs
 *    Case 13: prepared query reexecution changes binds without stale rows
 */

-- Exact 40000 source rows match the spec; no optimizer threshold is assumed
drop table if exists t_digit,t_src,t_outer,t_sink,t_twin;
create table t_digit(v integer);
insert into t_digit values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
create table t_src(id integer);
insert into t_src select a.v+10*b.v+100*c.v+1000*d.v+10000*e.v+1 from t_digit a,t_digit b,t_digit c,t_digit d,t_digit e where e.v<4;
create table t_outer(seq integer,k integer);
insert into t_outer values (0,0),(1,NULL),(2,-1),(3,39999),(4,40000),(5,0);
create table t_sink(v integer,flag integer);
create table t_twin(v integer,flag integer);
update statistics on t_digit,t_src,t_outer with fullscan;


evaluate 'Case 1: INTERSECT retains the first and last matches; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 intersect select v+1 from t_digit where v=d.v) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 2: EXCEPT preserves rows absent from the right arm; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 except select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 3: both arms read one materialized nonrecursive CTE; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with r as (select /*+ materialize */ id from t_src) select id from r where id=d.v+1 and d.v<5 union all select id from r where id=d.v+1 and d.v>=5) order by d.v;
select d.v from t_digit d order by d.v;
select /*+ recompile */ d.v from t_digit d where not exists (with r as (select /*+ materialize */ id from t_src) select id from r where id=d.v+1 and d.v<5 union all select id from r where id=d.v+1 and d.v>=5) order by d.v;
select d.v from t_digit d where 1=0 order by d.v;


evaluate 'Case 4: CTE definition matching at first middle and last positions; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with c_first as (select /*+ materialize */ id from t_src), c_middle as (select /*+ materialize */ id from t_src), c_last as (select /*+ materialize */ id from t_src) select id from c_first where id=d.v+1 union all select id from c_middle where id=d.v+100000 union all select id from c_last where id=d.v+100000) order by d.v;
select d.v from t_digit d order by d.v;
select /*+ recompile */ d.v from t_digit d where exists (with c_first as (select /*+ materialize */ id from t_src), c_middle as (select /*+ materialize */ id from t_src), c_last as (select /*+ materialize */ id from t_src) select id from c_first where id=d.v+100000 union all select id from c_middle where id=d.v+1 union all select id from c_last where id=d.v+100000) order by d.v;
select d.v from t_digit d order by d.v;
select /*+ recompile */ d.v from t_digit d where exists (with c_first as (select /*+ materialize */ id from t_src), c_middle as (select /*+ materialize */ id from t_src), c_last as (select /*+ materialize */ id from t_src) select id from c_first where id=d.v+100000 union all select id from c_middle where id=d.v+100000 union all select id from c_last where id=d.v+1) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 5: nested WITH owner keeps its own CTE dependencies; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 and exists (with recursive q(id,lvl) as (select id,1 from t_src where id<=20 union all select id,lvl+1 from q where lvl<2) select 1 from q where q.id=d.v+1 and q.lvl=2) union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 6: non CTE arm remains a valid independent match; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where id=d.v+100000 union all select v from t_digit where v=d.v and v<3) order by d.v;
select d.v from t_digit d where d.v<3 order by d.v;


evaluate 'Case 7: scalar aggregate above a derived UNION returns each value; result = relational reference';
select /*+ recompile */ d.v,(select max(dt.id) from (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) dt(id)) as got from t_digit d order by d.v;
select d.v,d.v+1 as got from t_digit d order by d.v;


evaluate 'Case 8: no WITH and top level WITH controls retain their rows; result = relational reference';
select /*+ recompile */ d.v from t_digit d where exists (select id from t_src where id=d.v+1 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;
with r as (select /*+ materialize */ id from t_src) select /*+ recompile */ d.v from t_digit d where exists (select id from r where id=d.v+1 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 9: NULL misses and repeated endpoints keep three valued semantics; result = relational reference';
select /*+ recompile */ d.seq from t_outer d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.k+1 and r.lvl=3 union all select v from t_digit where v=d.k+100) order by d.seq;
select d.seq from t_outer d where d.k between 0 and 39999 order by d.seq;
select /*+ recompile */ d.seq from t_outer d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.k+1 and r.lvl=3 union all select v from t_digit where v=d.k+100) order by d.seq;
select d.seq from t_outer d where d.k is NULL or d.k<0 or d.k>39999 order by d.seq;


evaluate 'Case 10: DELETE observes every match and deletes real missing rows; result = relational reference';
insert into t_sink select v,0 from t_digit;
insert into t_sink values (40000,0),(40001,0);
insert into t_twin select v,0 from t_digit;
insert into t_twin values (40000,0),(40001,0);
delete /*+ recompile */ from t_sink d where not exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select v,flag from t_sink order by v;
delete from t_twin where v>=40000;
select v,flag from t_twin order by v;


evaluate 'Case 11: UPDATE changes matched values rather than only row counts; result = relational reference';
truncate table t_sink;
insert into t_sink select v,0 from t_digit;
truncate table t_twin;
insert into t_twin select v,0 from t_digit;
update /*+ recompile */ t_sink d set flag=d.v+10 where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100);
select v,flag from t_sink order by v;
update t_twin set flag=v+10;
select v,flag from t_twin order by v;


evaluate 'Case 12: multirow scalar raises the same error then valid CTE runs; result = relational reference';
select /*+ recompile */ d.v,(with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where id=d.v+1 and lvl in (2,3) union all select v from t_digit where v=d.v+100) as got from t_digit d order by d.v;
select d.v,(select id from t_src where id between d.v+1 and d.v+2) as got from t_digit d order by d.v;
select /*+ recompile */ d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) order by d.v;
select d.v from t_digit d order by d.v;


evaluate 'Case 13: prepared query reexecution changes binds without stale rows; result = relational reference';
prepare st from 'select  d.v from t_digit d where exists (with recursive r(id,lvl) as (select id,1 from t_src union all select id,lvl+1 from r where lvl<3) select id from r where r.id=d.v+1 and r.lvl=3 union all select v from t_digit where v=d.v+100) and d.v<? order by d.v';
execute st using 10;
select d.v from t_digit d where d.v<10 order by d.v;
execute st using 5;
select d.v from t_digit d where d.v<5 order by d.v;
execute st using 10;
select d.v from t_digit d where d.v<10 order by d.v;
deallocate prepare st;
drop table t_digit,t_src,t_outer,t_sink,t_twin;

/**
 *  This test case verifies CBRD-27731: subquery must preserve original values.
 *  Case insensitive inputs must not change ASCII or binary comparison results.
 *  Every tested result is checked against a cache-disabled twin and finite literal data.
 *  Trace tokens distinguish selected paths; counts in trace are masked by CTP.
 *  Coverage:
 *    Case 1: Baseline totals
 *    Case 2: Parity groups preserve both original values
 *    Case 3: Reversed values
 *    Case 4: Repeated identical original
 *    Case 5: Case sensitive collation control
 *    Case 6: Binary collation comparison
 *    Case 7: NULL and empty string boundaries
 *    Case 8: Case insensitive SQL equality remains unchanged
 *    Case 9: Every outer row retains its own value
 */
drop table if exists t_outer, t_inner;
-- Exactly 2000 outer rows and at most four raw string values provide repeated keys.
create table t_outer (id int, c varchar(10) collate utf8_en_ci, rev varchar(10) collate utf8_en_ci, same varchar(10) collate utf8_en_ci, cs varchar(10) collate utf8_en_cs, edge varchar(10) collate utf8_en_ci);
insert into t_outer select rownum, case when mod(rownum,2)=1 then 'A' else 'a' end, case when mod(rownum,2)=1 then 'a' else 'A' end, 'A', case when mod(rownum,2)=1 then 'A' else 'a' end, case mod(rownum,4) when 1 then 'A' when 2 then 'a' when 3 then NULL else '' end from db_class x, db_class y limit 2000;
-- All 256 byte codes have 100 matches each; the two letter values differ in ASCII code.
create table t_inner (code int, ch varchar(10) collate utf8_en_ci);
insert into t_inner select mod(rownum-1,256), case mod(rownum-1,256) when 65 then 'A' when 97 then 'a' else NULL end from db_class x, db_class y, db_class z limit 25600;
create index idx_code on t_inner(code);
create index idx_ch on t_inner(ch);
update statistics on t_outer, t_inner with fullscan;
set trace on;


evaluate 'Case 1: Baseline totals; result = cache disabled';
select /*+ recompile parallel(0) */ count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o) d;
show trace;
select /*+ recompile parallel(0) */ count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o) d;
show trace;


evaluate 'Case 2: Parity groups preserve both original values; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 3: Reversed values; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.rev)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.rev)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 4: Repeated identical original; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.same)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.same)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 5: Case sensitive collation control; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.cs)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.cs)) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 6: Binary collation comparison; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.ch collate utf8_bin=o.c collate utf8_bin) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.ch collate utf8_bin=o.c collate utf8_bin) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 7: NULL and empty string boundaries; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,4) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.edge)) as val from t_outer o) d group by mod(d.id,4) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,4) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.edge)) as val from t_outer o) d group by mod(d.id,4) order by 1;
show trace;


evaluate 'Case 8: Case insensitive SQL equality remains unchanged; result = cache disabled';
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.ch=o.c) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;
select /*+ recompile parallel(0) */ mod(d.id,2) as grp, count(d.val) as matched, sum(d.val) as total from (select /*+ no_merge parallel(0) */ o.id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.ch=o.c) as val from t_outer o) d group by mod(d.id,2) order by 1;
show trace;


evaluate 'Case 9: Every outer row retains its own value; result = cache disabled';
select /*+ recompile parallel(0) */ o.id as id, (select /*+ no_unnest */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o order by o.id;
show trace;
select /*+ recompile parallel(0) */ o.id as id, (select /*+ no_unnest no_subquery_cache */ max(i.code) from t_inner i where i.code=ascii(o.c)) as val from t_outer o order by o.id;
show trace;
-- Clear tracing before cleanup so no traced plan leaks into the next file.
set trace off;
drop table t_outer, t_inner;

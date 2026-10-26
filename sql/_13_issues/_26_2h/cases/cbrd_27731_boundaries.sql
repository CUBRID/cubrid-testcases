/**
 *  This test case verifies CBRD-27731 cache-key comparison boundaries.
 *  VARCHAR lengths and byte positions, CHAR, NULL and scalar fallback keys
 *  must preserve results with memoize and correlated-subquery caches.
 *  Each case checks both caches against disabled twins and literal rows.
 *  MEMOIZE and SUBQUERY_CACHE tokens prove cache use on nonempty input.
 *  Coverage:
 *    Case 1: Byte lengths zero, one, two and three
 *    Case 2: First byte differs under the same collation
 *    Case 3: Middle byte differs under the same collation
 *    Case 4: Last byte differs under the same collation
 *    Case 5: CHAR keys preserve case sensitive expressions
 *    Case 6: Integer key fallback
 *    Case 7: Numeric key fallback
 *    Case 8: Date key fallback
 *    Case 9: Composite string and scalar keys
 *    Case 10: Empty outer input
 */
drop table if exists t_wb_outer, t_wb_inner, t_wb_seed;
-- Nine seed rows define the length and equal-collation byte boundaries.
create table t_wb_seed (g int, k varchar(10) collate utf8_en_ci, ck char(3) collate utf8_en_ci, n int, v numeric(10,0), dt date);
insert into t_wb_seed values (0,'','AAA',0,1,date '2020-01-01'),(1,' ','aAA',1,2,date '2020-01-02'),(2,'A','AaA',2,3,date '2020-01-03'),(3,'A ','AAa',3,4,date '2020-01-04'),(4,'AAA','AAA',4,5,date '2020-01-05'),(5,'aAA','aAA',5,6,date '2020-01-06'),(6,'AaA','AaA',6,7,date '2020-01-07'),(7,'AAa','AAa',7,8,date '2020-01-08'),(8,NULL,'AAA',8,9,date '2020-01-09');
-- Repeat each key 100 times; at most nine keys fit far below the 2M budget.
create table t_wb_outer as select ss.* from t_wb_seed ss, (select rownum as seq from db_class xx, db_class yy limit 100) rr;
-- Each possible byte has ten matches; every nonempty shape has repeated hits.
create table t_wb_inner (code int);
insert into t_wb_inner select mod(rownum-1,256) from db_class xx, db_class yy limit 2560;
update statistics on t_wb_outer, t_wb_inner with fullscan;
set trace on;


evaluate 'Case 1: Byte lengths zero, one, two and three; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=octet_length(o.k) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=octet_length(o.k) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=octet_length(o.k)) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=octet_length(o.k)) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 2: First byte differs under the same collation; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,1,1)) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,1,1)) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,1,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,1,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 3: Middle byte differs under the same collation; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,2,1)) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,2,1)) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,2,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,2,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 4: Last byte differs under the same collation; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,3,1)) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.k,3,1)) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,3,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.k,3,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 5: CHAR keys preserve case sensitive expressions; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.ck,2,1)) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(substr(o.ck,2,1)) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.ck,2,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(substr(o.ck,2,1))) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 6: Integer key fallback; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=o.n group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=o.n group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=o.n) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=o.n) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 7: Numeric key fallback; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=cast(o.v as integer) group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=cast(o.v as integer) group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=cast(o.v as integer)) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=cast(o.v as integer)) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 8: Date key fallback; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=datediff(o.dt, date '2020-01-01') group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=datediff(o.dt, date '2020-01-01') group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=datediff(o.dt, date '2020-01-01')) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=datediff(o.dt, date '2020-01-01')) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 9: Composite string and scalar keys; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(o.k)+o.n+cast(o.v as integer)+datediff(o.dt,date '2020-01-01') group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(o.k)+o.n+cast(o.v as integer)+datediff(o.dt,date '2020-01-01') group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(o.k)+o.n+cast(o.v as integer)+datediff(o.dt,date '2020-01-01')) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(o.k)+o.n+cast(o.v as integer)+datediff(o.dt,date '2020-01-01')) as val from t_wb_outer o) dd group by dd.g order by dd.g;
show trace;


evaluate 'Case 10: Empty outer input; result = cache disabled';
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(o.k) and o.g<0 group by o.g order by o.g;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) ordered use_nl(ii) */ o.g as grp, count(*) as matched, sum(cast(ii.code as numeric(38,0))) as total from t_wb_outer o, t_wb_inner ii where ii.code=ascii(o.k) and o.g<0 group by o.g order by o.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest */ max(ii.code) from t_wb_inner ii where ii.code=ascii(o.k)) as val from t_wb_outer o where o.g<0) dd group by dd.g order by dd.g;
show trace;
select /*+ recompile parallel(0) */ dd.g as grp, count(dd.val) as matched, sum(cast(dd.val as numeric(38,0))) as total from (select /*+ no_merge parallel(0) */ o.g, (select /*+ no_unnest no_subquery_cache */ max(ii.code) from t_wb_inner ii where ii.code=ascii(o.k)) as val from t_wb_outer o where o.g<0) dd group by dd.g order by dd.g;
show trace;
-- Do not leave the last traced plan in the shared CQT session.
set trace off;
set system parameters 'memoize_memory_limit=default';
drop table t_wb_outer, t_wb_inner, t_wb_seed;

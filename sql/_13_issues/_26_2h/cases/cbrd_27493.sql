/**
 *  This test case verifies CBRD-27493: a join placed after an unnested NL SEMI / ANTI
 *  JOIN in the scan chain (a following join) must read every partition of its table.
 *
 *  CBRD-26872 unnests WHERE [NOT] EXISTS into an NL semi / anti join. The scan block
 *  iterator stops above the first semi / anti inner, and that inner walks its own
 *  partitions for each outer row. A plain join placed after the inner was left out of
 *  both. A partitioned following join therefore stayed on its first partition for the
 *  whole query, and when a partitioned driving table moved to its next partition, a
 *  following join that had already reached its end ended the whole query.
 *
 *  The fix drives a following join per outer row, like the semi / anti inner. It is
 *  rewound to its first partition for each outer row that reaches it, it walks all its
 *  partitions within that row, its memoize storage spans that walk, and the block
 *  iterator rewinds it when the driving table moves to its next partition. A following
 *  join with a single partition left keeps its current scan for each outer row, and is
 *  reopened on that partition after the block iterator has closed its scan.
 *
 *  Every unnested query is followed by the same query with the NO_UNNEST hint, and the
 *  two result blocks must match. CTP runs with test_mode=yes, which masks volatile
 *  trace values to '?'. The traces show the plan shape (the join after the anti join)
 *  and the PARTITION lines of the following join.
 *
 *  Coverage:
 *    Case 1:  NOT EXISTS / EXISTS, hash partitioned following join, count and rows
 *    Case 2:  explicit ANTI JOIN / SEMI JOIN syntax in FROM order, then a partitioned join
 *    Case 3:  range partitioned following join, and a single partition left by pruning
 *    Case 4:  two partitioned following joins, the second joined to the first
 *    Case 5:  partitioned semi / anti inner followed by a partitioned join
 *    Case 6:  partitioned driving table, anti join, then an unpartitioned or a partitioned join
 *    Case 7:  repeated keys with memoize on and off
 *    Case 8:  left outer join to a partitioned table after the anti join, an outer row with no match
 *    Case 9:  driving table scanned in parallel, hash join ruled out
 *    Case 10: partitioned driving table, a join that finds no match in its last block,
 *             then a following join with a single partition left
 */

drop table if exists t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp, t_o8;

create table t_o (id int primary key, k int);
insert into t_o values (1, 1), (2, 2), (3, 3), (4, 1), (5, 2), (6, 3), (7, 4), (8, 5), (9, 1), (10, 3);

create table t_i (k int primary key);
insert into t_i values (2), (5);

create table t_w (k int, id int, primary key (k, id)) partition by hash (k) partitions 3;
insert into t_w values (1, 10), (1, 11), (2, 20), (2, 21), (3, 30), (3, 31), (4, 40), (5, 50);

create table t_r (k int, id int, primary key (k, id))
  partition by range (k) (partition p0 values less than (2), partition p1 values less than (4), partition p2 values less than maxvalue);
insert into t_r select k, id from t_w;

create table t_x (k int, v int, primary key (k, v)) partition by hash (k) partitions 4;
insert into t_x values (1, 100), (1, 101), (3, 300), (4, 400), (4, 401), (5, 500);

create table t_ip (k int primary key) partition by hash (k) partitions 3;
insert into t_ip values (2), (5);

create table t_op (id int primary key, k int) partition by hash (id) partitions 2;
insert into t_op select id, k from t_o;

create table t_wnp (k int, id int, primary key (k, id));
insert into t_wnp select k, id from t_w;

-- t_o plus k = 6, which passes the anti join and has no row in t_w (Case 8)
create table t_o8 (id int primary key, k int);
insert into t_o8 select id, k from t_o;
insert into t_o8 values (11, 6);

update statistics on t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp, t_o8 with fullscan;

set trace on;


evaluate 'Case 1: NOT EXISTS / EXISTS, hash partitioned following join; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select 1 from t_i s where s.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);
-- rows, not a count
select /*+ recompile parallel(0) */ o.id, w.id from t_o o, t_w w where w.k = o.k and not exists (select 1 from t_i s where s.k = o.k) order by 1, 2;
select /*+ recompile parallel(0) */ o.id, w.id from t_o o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k) order by 1, 2;


evaluate 'Case 2: explicit ANTI JOIN / SEMI JOIN syntax in FROM order, then a partitioned join; result = NO_UNNEST';
select /*+ recompile parallel(0) ordered */ count(*) from t_o o anti join t_i s on s.k = o.k inner join t_w w on w.k = o.k;
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) ordered */ count(*) from t_o o semi join t_i s on s.k = o.k inner join t_w w on w.k = o.k;
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);


evaluate 'Case 3: range partitioned following join, and a single partition left by pruning; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from t_o o, t_r w where w.k = o.k and not exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_r w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and w.k = 1 and not exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and w.k = 1 and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);


evaluate 'Case 4: two partitioned following joins, the second joined to the first; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);


evaluate 'Case 5: partitioned semi / anti inner followed by a partitioned join; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select 1 from t_ip s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_ip s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and exists (select 1 from t_ip s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and exists (select /*+ NO_UNNEST */ 1 from t_ip s where s.k = o.k);


evaluate 'Case 6: partitioned driving table, anti join, then an unpartitioned or a partitioned join; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from t_op o, t_wnp w where w.k = o.k and not exists (select 1 from t_i s where s.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_op o, t_wnp w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_op o, t_w w where w.k = o.k and not exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*) from t_op o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);


evaluate 'Case 7: repeated keys with memoize on and off; result = NO_UNNEST';
-- k = 1 and k = 3 appear three times each in t_o, so the second and third outer rows of a key are memoize hits
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select 1 from t_i s where s.k = o.k) group by o.k order by 1;
show trace;
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k) group by o.k order by 1;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select 1 from t_i s where s.k = o.k) group by o.k order by 1;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 8: left outer join to a partitioned table after the anti join, an outer row with no match; result = NO_UNNEST';
-- k = 6 of t_o8 passes the anti join and matches no row of t_w, so count(*) exceeds count(w.id) by one
-- only if the outer join keeps that row with NULLs. The planner reads a partitioned inner of an outer
-- join through a temp list (SORT (temp) in the trace), so this following join reads no partitions, and
-- develop gives the same answer
select /*+ recompile parallel(0) */ count(*), count(w.id) from t_o8 o left join t_w w on w.k = o.k where not exists (select 1 from t_i s where s.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), count(w.id) from t_o8 o left join t_w w on w.k = o.k where not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);

set trace off;
drop table t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp, t_o8;


evaluate 'Case 9: driving table scanned in parallel, hash join ruled out; result = parallel(0) = NO_UNNEST';
-- outer_big is large enough to be scanned in parallel under test_mode (parallel_scan_page_threshold 32).
-- The trace shows the parallel scan of outer_big. A parallel trace prints only the first PARTITION line
-- of the following join t_w9, and the partitions the workers walk add to its SCAN line, so the counts,
-- not the trace, show the partition walk
drop table if exists outer_big, t_w9, t_i9;
create table outer_big (a int primary key, k int);
insert into outer_big select rownum, mod (rownum, 6) from db_class a, db_class b, db_class c, db_class d limit 100000;
create table t_w9 (k int, id int, primary key (k, id)) partition by hash (k) partitions 3;
insert into t_w9 values (0, 1), (1, 10), (1, 11), (2, 20), (2, 21), (3, 30), (3, 31), (4, 40), (5, 50);
create table t_i9 (k int primary key);
insert into t_i9 values (2);
update statistics on outer_big, t_w9, t_i9 with fullscan;
set trace on;
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select 1 from t_i9 s where s.k = o.k);
show trace;
set trace off;
select /*+ recompile no_use_hash parallel(0) */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash parallel(0) */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select /*+ NO_UNNEST */ 1 from t_i9 s where s.k = o.k);
drop table outer_big, t_w9, t_i9;


evaluate 'Case 10: partitioned driving table, a join that finds no match in its last block, then a following join with a single partition; result = NO_UNNEST';
-- t_m10 has no match in its partition p1 for the row in partition p0 of t_d10, so the block iterator
-- closes the scans after it, the following join included, before t_d10 moves to its partition p1
drop table if exists t_d10, t_m10, t_u10, t_s10, t_f10, t_g10;
create table t_d10 (c1 int, c2 int) partition by range (c1) (partition p0 values less than (2), partition p1 values less than maxvalue);
insert into t_d10 values (1, 1), (2, 2);
create table t_m10 (c1 int) partition by range (c1) (partition p0 values less than (2), partition p1 values less than maxvalue);
insert into t_m10 values (1), (2);
create table t_u10 (c1 int);
insert into t_u10 values (2);
create table t_s10 (c1 int);
insert into t_s10 values (1), (2);
-- pruned to its partition p0 by f.c1 = 0
create table t_f10 (c1 int, c2 int, c3 int) partition by range (c1) (partition p0 values less than (1), partition p1 values less than maxvalue);
insert into t_f10 values (0, 1, 101), (0, 2, 102);
-- a single partition by definition
create table t_g10 (c1 int, c2 int, c3 int) partition by range (c1) (partition p0 values less than maxvalue);
insert into t_g10 values (0, 1, 101), (0, 2, 102);
update statistics on t_d10, t_m10, t_u10, t_s10, t_f10, t_g10 with fullscan;
set trace on;
select /*+ recompile ordered no_use_hash parallel(0) */ d.c1, f.c3 from t_d10 d inner join t_m10 m on m.c1 = d.c2 semi join t_s10 s on s.c1 = d.c2 inner join t_f10 f on f.c2 = d.c2 where f.c1 = 0 order by 1, 2;
show trace;
set trace off;
select /*+ recompile parallel(0) */ d.c1, f.c3 from t_d10 d, t_m10 m, t_f10 f where m.c1 = d.c2 and f.c2 = d.c2 and f.c1 = 0 and exists (select /*+ NO_UNNEST */ 1 from t_s10 s where s.c1 = d.c2) order by 1, 2;
-- anti join: no row of t_s10 matches, so every outer row survives
select /*+ recompile ordered no_use_hash parallel(0) */ d.c1, f.c3 from t_d10 d inner join t_m10 m on m.c1 = d.c2 anti join t_s10 s on s.c1 = d.c2 + 100 inner join t_f10 f on f.c2 = d.c2 where f.c1 = 0 order by 1, 2;
select /*+ recompile parallel(0) */ d.c1, f.c3 from t_d10 d, t_m10 m, t_f10 f where m.c1 = d.c2 and f.c2 = d.c2 and f.c1 = 0 and not exists (select /*+ NO_UNNEST */ 1 from t_s10 s where s.c1 = d.c2 + 100) order by 1, 2;
-- a following join with a single partition by definition
select /*+ recompile ordered no_use_hash parallel(0) */ d.c1, g.c3 from t_d10 d inner join t_m10 m on m.c1 = d.c2 semi join t_s10 s on s.c1 = d.c2 inner join t_g10 g on g.c2 = d.c2 order by 1, 2;
select /*+ recompile parallel(0) */ d.c1, g.c3 from t_d10 d, t_m10 m, t_g10 g where m.c1 = d.c2 and g.c2 = d.c2 and exists (select /*+ NO_UNNEST */ 1 from t_s10 s where s.c1 = d.c2) order by 1, 2;
-- an unpartitioned join with no match for the row in partition p0 of t_d10 closes the scans after it the same way
select /*+ recompile ordered no_use_hash parallel(0) */ d.c1, f.c3 from t_d10 d inner join t_u10 u on u.c1 = d.c2 semi join t_s10 s on s.c1 = d.c2 inner join t_f10 f on f.c2 = d.c2 where f.c1 = 0 order by 1, 2;
select /*+ recompile parallel(0) */ d.c1, f.c3 from t_d10 d, t_u10 u, t_f10 f where u.c1 = d.c2 and f.c2 = d.c2 and f.c1 = 0 and exists (select /*+ NO_UNNEST */ 1 from t_s10 s where s.c1 = d.c2) order by 1, 2;
drop table t_d10, t_m10, t_u10, t_s10, t_f10, t_g10;

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
 *  iterator rewinds it when the driving table moves to its next partition.
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
 *    Case 8:  left outer join to a partitioned table after the anti join
 *    Case 9:  driving table scanned in parallel, hash join ruled out, trace off
 */

drop table if exists t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp;

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

update statistics on t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp with fullscan;

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
-- the reference drives with t_o, which holds the same rows unpartitioned: a partitioned driving table
-- joined to a partitioned table with memoize on is CBRD-27484 (PR #8009) whatever the subquery form
select /*+ recompile parallel(0) */ count(*) from t_o o, t_w w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);


evaluate 'Case 7: repeated keys with memoize on and off; result = NO_UNNEST';
-- k = 1 and k = 3 appear three times each in t_o, so the second and third outer rows of a key are memoize hits
set system parameters 'memoize_memory_limit=2M';
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select 1 from t_i s where s.k = o.k) group by o.k order by 1;
show trace;
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k) group by o.k order by 1;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) */ o.k, count(*) from t_o o, t_w w, t_x x where w.k = o.k and x.k = w.k and not exists (select 1 from t_i s where s.k = o.k) group by o.k order by 1;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 8: left outer join to a partitioned table after the anti join; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*), count(w.id) from t_o o left join t_w w on w.k = o.k where not exists (select 1 from t_i s where s.k = o.k);
select /*+ recompile parallel(0) */ count(*), count(w.id) from t_o o left join t_w w on w.k = o.k where not exists (select /*+ NO_UNNEST */ 1 from t_i s where s.k = o.k);

set trace off;
drop table t_o, t_i, t_w, t_r, t_x, t_ip, t_op, t_wnp;


evaluate 'Case 9: driving table scanned in parallel, hash join ruled out, trace off; result = parallel(0) = NO_UNNEST';
-- outer_big is large enough to be scanned in parallel under test_mode (parallel_scan_page_threshold 32).
-- Trace stays off: a traced parallel scan over a partitioned inner needs CBRD-27484 (PR #8009).
drop table if exists outer_big, t_w9, t_i9;
create table outer_big (a int primary key, k int);
insert into outer_big select rownum, mod (rownum, 6) from db_class a, db_class b, db_class c, db_class d limit 100000;
create table t_w9 (k int, id int, primary key (k, id)) partition by hash (k) partitions 3;
insert into t_w9 values (0, 1), (1, 10), (1, 11), (2, 20), (2, 21), (3, 30), (3, 31), (4, 40), (5, 50);
create table t_i9 (k int primary key);
insert into t_i9 values (2);
update statistics on outer_big, t_w9, t_i9 with fullscan;
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash parallel(0) */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and not exists (select /*+ NO_UNNEST */ 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash parallel(0) */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select 1 from t_i9 s where s.k = o.k);
select /*+ recompile no_use_hash */ count(*) from outer_big o, t_w9 w where w.k = o.k and exists (select /*+ NO_UNNEST */ 1 from t_i9 s where s.k = o.k);
drop table outer_big, t_w9, t_i9;

/**
 *  This test case verifies CBRD-27732: partitioned ORDER BY LIMIT preserves all input rows.
 *  Small partitions must not lose rows when large partitions can use parallel scans.
 *  Each query is compared with NO_PARALLEL_SCAN and independently computed rows.
 *  TRACE records per-partition scan shapes, without asserting an exact worker count.
 *  Empty-partition controls are not claimed to have mixed serial and parallel scans.
 *  Coverage:
 *    Case 1: t_front small partition scan control
 *    Case 2: t_front large partition scan control
 *    Case 3: t_back small partition scan control
 *    Case 4: t_back large partition scan control
 *    Case 5: Small first partition, ascending top five
 *    Case 6: Small first partition, descending top five
 *    Case 7: Small first partition, LIMIT one
 *    Case 8: Ascending OFFSET crosses partition boundary
 *    Case 9: Descending OFFSET crosses partition boundary
 *    Case 10: Small last partition, descending top five
 *    Case 11: Small last partition, ascending top five
 *    Case 12: Small last partition, OFFSET crosses boundary
 *    Case 13: Tied sort values with deterministic id tie breaker
 *    Case 14: Empty first partition
 *    Case 15: Empty large partition and nonempty small last partition
 *    Case 16: Both partitions empty
 */

drop table if exists t_front, t_back;

-- Small rows use short padding, while 262144 large-partition rows exceed the scan page floor by a wide margin
create table t_front (id int, v int, pad varchar(200)) partition by range (id) (partition p_small values less than (1000), partition p_large values less than MAXVALUE);
insert into t_front select rownum, rownum, 's' from db_class aa, db_class bb, db_class cc limit 999;
insert into t_front select 1000 + rownum, 1000 + rownum, sha2(cast(rownum as varchar), 256) from db_class aa, db_class bb, db_class cc limit 2048;
insert into t_front select id + 2048, v + 2048, pad from t_front where id >= 1000;
insert into t_front select id + 4096, v + 4096, pad from t_front where id >= 1000;
insert into t_front select id + 8192, v + 8192, pad from t_front where id >= 1000;
insert into t_front select id + 16384, v + 16384, pad from t_front where id >= 1000;
insert into t_front select id + 32768, v + 32768, pad from t_front where id >= 1000;
insert into t_front select id + 65536, v + 65536, pad from t_front where id >= 1000;
insert into t_front select id + 131072, v + 131072, pad from t_front where id >= 1000;

-- The same large input precedes 999 short rows in the last partition
create table t_back (id int, v int, pad varchar(200)) partition by range (id) (partition p_large values less than (300000), partition p_small values less than MAXVALUE);
insert into t_back select case when id < 1000 then id + 300000 else id end, case when id < 1000 then v + 300000 else v end, pad from t_front;
update statistics on t_front, t_back with fullscan;
select case when id < 1000 then 0 else 1 end as part, count(*), min(id), max(id) from t_front group by part order by part;
select case when id < 300000 then 0 else 1 end as part, count(*), min(id), max(id) from t_back group by part order by part;
set trace on;


evaluate 'Case 1: t_front small partition scan control; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front__p__p_small order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front__p__p_small order by v, id limit 5;


evaluate 'Case 2: t_front large partition scan control; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front__p__p_large order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front__p__p_large order by v, id limit 5;


evaluate 'Case 3: t_back small partition scan control; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back__p__p_small order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back__p__p_small order by v, id limit 5;


evaluate 'Case 4: t_back large partition scan control; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back__p__p_large order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back__p__p_large order by v, id limit 5;


evaluate 'Case 5: Small first partition, ascending top five; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v limit 5;


evaluate 'Case 6: Small first partition, descending top five; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v desc, id desc limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v desc, id desc limit 5;


evaluate 'Case 7: Small first partition, LIMIT one; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v, id limit 1;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v, id limit 1;


evaluate 'Case 8: Ascending OFFSET crosses partition boundary; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v, id limit 997, 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v, id limit 997, 5;


evaluate 'Case 9: Descending OFFSET crosses partition boundary; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v desc, id desc limit 262142, 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v desc, id desc limit 262142, 5;


evaluate 'Case 10: Small last partition, descending top five; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back order by v desc, id desc limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back order by v desc, id desc limit 5;


evaluate 'Case 11: Small last partition, ascending top five; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back order by v, id limit 5;


evaluate 'Case 12: Small last partition, OFFSET crosses boundary; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back order by v desc, id desc limit 997, 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back order by v desc, id desc limit 997, 5;


evaluate 'Case 13: Tied sort values with deterministic id tie breaker; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by mod(v, 3), id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by mod(v, 3), id limit 5;
delete from t_front where id < 1000;
update statistics on t_front with fullscan;


evaluate 'Case 14: Empty first partition; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v, id limit 5;
delete from t_back where id < 300000;
update statistics on t_back with fullscan;


evaluate 'Case 15: Empty large partition and nonempty small last partition; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_back order by v desc, id desc limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_back order by v desc, id desc limit 5;
delete from t_front;
update statistics on t_front with fullscan;


evaluate 'Case 16: Both partitions empty; result = NO_PARALLEL_SCAN';
select /*+ recompile  */ id, v from t_front order by v, id limit 5;
show trace;
-- Disable tracing before the last untraced reference query to leave no stale plan
set trace off;
select /*+ recompile no_parallel_scan */ id, v from t_front order by v, id limit 5;

drop table t_front, t_back;

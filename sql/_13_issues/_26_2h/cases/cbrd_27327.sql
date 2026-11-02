/**
 *  This test case verifies CBRD-27327: MIN/MAX over a string column, and every other aggregate
 *  that a parallel scan merges without GROUP BY, must work on a partitioned table.
 *
 *  A parallel scan without GROUP BY aggregates in its workers (gather: buildvalue) and merges
 *  their partial values into one accumulator. A partitioned table is scanned one partition at a
 *  time, and from the second partition on the merge released a string accumulator with the
 *  wrong allocator, so the server aborted. An error inside the scan also released the separator
 *  of GROUP_CONCAT. The fix (engine PR #7821) moves the accumulators between the allocators once
 *  per partition and leaves the separator alone.
 *
 *  Every tested query is followed by the same query with parallel(0), which runs it serially,
 *  and the two result blocks must match. CTP runs with test_mode=yes, which lowers the parallel
 *  scan threshold to 32 pages and masks digits in the trace, so the traces assert the buildvalue
 *  gather by its token only.
 *
 *  Coverage:
 *    Case 1:  the reported query, MIN and MAX of a string column over four hash partitions
 *    Case 2:  COUNT, MIN and MAX of strings, SUM, AVG, STDDEV and VARIANCE family, BIT aggregates
 *    Case 3:  GROUP_CONCAT without ORDER BY and the JSON aggregates, compared by length
 *    Case 4:  MEDIAN, PERCENTILE, CUME_DIST, PERCENT_RANK, DISTINCT, sorted GROUP_CONCAT
 *    Case 5:  the qualifying row in one partition only, and no qualifying row at all
 *    Case 6:  the same aggregates on a table without partitions, scanned in one pass
 *    Case 7:  one statement run three times without recompile, reusing the cached plan
 *    Case 8:  a division by zero inside the scan of the table without partitions, then without it
 *    Case 9:  the same division by zero on the partitioned table
 */

drop table if exists t_part, t_flat;

-- four hash partitions of about 50000 rows each, every one far above the 32 page threshold, so
-- every partition is a parallel pass of its own. col differs on every row, so MIN and MAX depend on
-- the merge. grp has 80000, 60000, 40000 and 20000 rows. d is the divisor of Case 8 and Case 9.
create table t_part (id int, col varchar(40), grp varchar(10), v int, d int) partition by hash (id) partitions 4;
insert into t_part select rownum, 'row-' || lpad(cast(rownum as varchar), 12, '0'), case when mod(rownum, 10) < 4 then 'aa' when mod(rownum, 10) < 7 then 'bb' when mod(rownum, 10) < 9 then 'cc' else 'dd' end, mod(rownum * 7, 1000), 1 from db_class a, db_class b, db_class c, db_class d limit 200000;
-- the same rows without partitions
create table t_flat (id int, col varchar(40), grp varchar(10), v int, d int);
insert into t_flat select id, col, grp, v, d from t_part;
update statistics on t_part, t_flat with fullscan;

set trace on;


evaluate 'Case 1: the reported query, MIN and MAX of a string column over four partitions; result = parallel(0)';
select /*+ recompile */ min(col), max(col) from t_part;
show trace;
select /*+ recompile parallel(0) */ min(col), max(col) from t_part;


evaluate 'Case 2: COUNT, string MIN and MAX, SUM, AVG, STDDEV and VARIANCE family, BIT aggregates; result = parallel(0)';
select /*+ recompile */ count(*), count(col), min(grp), max(grp), sum(v), round(avg(v), 2), round(stddev(v), 2), round(stddev_pop(v), 2), round(stddev_samp(v), 2), round(variance(v), 2), round(var_pop(v), 2), round(var_samp(v), 2), bit_and(v), bit_or(v), bit_xor(v) from t_part;
show trace;
select /*+ recompile parallel(0) */ count(*), count(col), min(grp), max(grp), sum(v), round(avg(v), 2), round(stddev(v), 2), round(stddev_pop(v), 2), round(stddev_samp(v), 2), round(variance(v), 2), round(var_pop(v), 2), round(var_samp(v), 2), bit_and(v), bit_or(v), bit_xor(v) from t_part;


evaluate 'Case 3: GROUP_CONCAT without ORDER BY and the JSON aggregates, compared by length; result = parallel(0)';
-- the partial values are merged in worker order, so only lengths are compared: 40 values of 16
-- characters joined by 39 separators of 4 characters, and 40 JSON members
select /*+ recompile */ length(group_concat(col separator '<<>>')), length(replace(group_concat(col separator '<<>>'), '<<>>', '')), json_length(json_arrayagg(col)), json_length(json_objectagg(col, v)) from t_part where mod(id, 5000) = 0;
show trace;
select /*+ recompile parallel(0) */ length(group_concat(col separator '<<>>')), length(replace(group_concat(col separator '<<>>'), '<<>>', '')), json_length(json_arrayagg(col)), json_length(json_objectagg(col, v)) from t_part where mod(id, 5000) = 0;


evaluate 'Case 4: MEDIAN, PERCENTILE, CUME_DIST, PERCENT_RANK, DISTINCT and sorted GROUP_CONCAT; result = parallel(0)';
select /*+ recompile */ round(median(v), 2), round(percentile_cont(0.25) within group (order by v), 2), percentile_disc(0.75) within group (order by v), round(cume_dist(500) within group (order by v), 4), round(percent_rank(500) within group (order by v), 4), count(distinct grp), sum(distinct v), min(distinct col), max(distinct col), group_concat(distinct grp order by grp separator '-|-') from t_part;
show trace;
select /*+ recompile parallel(0) */ round(median(v), 2), round(percentile_cont(0.25) within group (order by v), 2), percentile_disc(0.75) within group (order by v), round(cume_dist(500) within group (order by v), 4), round(percent_rank(500) within group (order by v), 4), count(distinct grp), sum(distinct v), min(distinct col), max(distinct col), group_concat(distinct grp order by grp separator '-|-') from t_part;


evaluate 'Case 5: the qualifying row in one partition only, then no qualifying row; result = parallel(0)';
-- col is not the partition key, so all four partitions are scanned, and the passes over the
-- partitions without the row merge nothing but NULL
select /*+ recompile */ count(*), min(col), max(col), group_concat(grp separator '<<>>') from t_part where col = 'row-000000000007';
show trace;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(grp separator '<<>>') from t_part where col = 'row-000000000007';
select /*+ recompile */ count(*), min(col), max(col), group_concat(grp separator '<<>>') from t_part where col = 'none';
show trace;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(grp separator '<<>>') from t_part where col = 'none';


evaluate 'Case 6: the same aggregates on a table without partitions, scanned in one pass; result = parallel(0)';
select /*+ recompile */ min(col), max(col), min(grp), max(grp), count(*), sum(v), round(stddev(v), 2), round(variance(v), 2), group_concat(distinct grp order by grp separator '-|-') from t_flat;
show trace;
-- trace goes off before the next query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ min(col), max(col), min(grp), max(grp), count(*), sum(v), round(stddev(v), 2), round(variance(v), 2), group_concat(distinct grp order by grp separator '-|-') from t_flat;


evaluate 'Case 7: one statement three times without recompile, reusing the cached plan; result = parallel(0)';
-- no recompile: the second and third runs take the plan cached by the first, with its accumulators
-- and its separator, over the same partitioned scan as Case 2 and Case 4
select min(col), max(col), min(grp), max(grp), count(*), sum(v), group_concat(distinct grp order by grp separator '-|-') from t_part;
select min(col), max(col), min(grp), max(grp), count(*), sum(v), group_concat(distinct grp order by grp separator '-|-') from t_part;
select min(col), max(col), min(grp), max(grp), count(*), sum(v), group_concat(distinct grp order by grp separator '-|-') from t_part;
select /*+ recompile parallel(0) */ min(col), max(col), min(grp), max(grp), count(*), sum(v), group_concat(distinct grp order by grp separator '-|-') from t_part;


evaluate 'Case 8: a division by zero inside the parallel scan of the table without partitions, then the same statement without it; result = parallel(0)';
-- one pass only, so the error path is tested apart from the partition passes. d is 0 on one
-- qualifying row while the error is wanted, and 1 again afterwards. The statement text never changes
-- and has no recompile, so every run after the first takes the cached plan whose separator the error
-- must leave intact. The 100 qualifying rows hold all four grp values.
update t_flat set d = 0 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;
update t_flat set d = 1 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;
update t_flat set d = 0 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;
update t_flat set d = 1 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_flat where mod(id, 20000) < 10 and 100 / d > 0;


evaluate 'Case 9: the same division by zero on the partitioned table, then the same statement without it; result = parallel(0)';
-- the error stops a scan that merges one partition after another, so the values merged so far are
-- released on the error path as well
update t_part set d = 0 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;
update t_part set d = 1 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;
update t_part set d = 0 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;
update t_part set d = 1 where id = 100000;
select count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;
select /*+ recompile parallel(0) */ count(*), min(col), max(col), group_concat(distinct grp order by grp separator '-|-') from t_part where mod(id, 20000) < 10 and 100 / d > 0;


drop table t_part, t_flat;

/**
 *  This test case verifies CBRD-27732: serial rows survive repeated partition merges.
 *  One-row partitions alternate with large partitions, exercising both nonempty
 *  and empty leader inputs before the next parallel merge.
 *  Ordered rows are checked against NO_PARALLEL_SCAN and literal expectations.
 *  TRACE asserts PARTITION and mergeable list tokens, not exact worker counts.
 *  Coverage:
 *    Case 1: Two large partitions separated by a one-row partition
 *    Case 2: Descending order selects only large-partition rows
 *    Case 3: Predicates reject both serial rows
 *    Case 4: Exactly one serial row qualifies
 *    Case 5: LIMIT zero is an empty-result control
 *    Case 6: OFFSET must not be applied while preserving the first serial row
 *    Case 7: ORDERBY_NUM projection after the final sort
 *    Case 8: Numeric and nullable string output values
 *    Case 9: NULL sort keys and hidden sort expressions
 *    Case 10: No LIMIT, hence no top-N heap
 *    Case 11: Empty first partition before repeated merges
 */

drop table if exists t_chain;

-- Each large partition has 262144 SHA-padded rows, far above 3 times the 32-page test-mode floor
-- Each serial partition has one short row, far below one fifth of that floor
create table t_chain (id int, v int, pad varchar(200)) partition by range (id) (partition p_first values less than (1000), partition p_large values less than (300000), partition p_middle values less than (301000), partition p_last values less than MAXVALUE);
insert into t_chain values (1, -1, NULL), (300001, -2, NULL);
insert into t_chain select 1000 + rownum, 1000 + rownum, sha2(cast(rownum as varchar), 256) from db_class aa, db_class bb, db_class cc limit 2048;
insert into t_chain select id + 2048, v + 2048, pad from t_chain where v > 0;
insert into t_chain select id + 4096, v + 4096, pad from t_chain where v > 0;
insert into t_chain select id + 8192, v + 8192, pad from t_chain where v > 0;
insert into t_chain select id + 16384, v + 16384, pad from t_chain where v > 0;
insert into t_chain select id + 32768, v + 32768, pad from t_chain where v > 0;
insert into t_chain select id + 65536, v + 65536, pad from t_chain where v > 0;
insert into t_chain select id + 131072, v + 131072, pad from t_chain where v > 0;
insert into t_chain select id + 300000, v + 300000, pad from t_chain where v > 0;
update statistics on t_chain with fullscan;
set trace on;


evaluate 'Case 1: Repeated merges preserve both serial rows; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by v, id limit 5;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by v, id limit 5;


evaluate 'Case 2: Descending large-partition rows; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by v desc, id desc limit 3;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by v desc, id desc limit 3;


evaluate 'Case 3: No qualifying serial rows; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain where v > 0 order by v, id limit 3;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain where v > 0 order by v, id limit 3;


evaluate 'Case 4: One qualifying serial row; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain where v >= -1 order by v, id limit 3;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain where v >= -1 order by v, id limit 3;


evaluate 'Case 5: LIMIT zero control; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by v, id limit 0;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by v, id limit 0;


evaluate 'Case 6: OFFSET retains the serial candidate; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by v, id limit 1, 3;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by v, id limit 1, 3;


evaluate 'Case 7: Final ORDERBY_NUM projection; result = NO_PARALLEL_SCAN';
select /*+ recompile */ orderby_num() as pos, id, v from t_chain order by v, id limit 1, 3;
show trace;
select /*+ recompile no_parallel_scan */ orderby_num() as pos, id, v from t_chain order by v, id limit 1, 3;


evaluate 'Case 8: Numeric and nullable string projection; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, cast(v as numeric(20,0)) as amount, case when v < 0 then cast(NULL as varchar(20)) else cast(v as varchar(20)) end as payload from t_chain order by v, id limit 3;
show trace;
select /*+ recompile no_parallel_scan */ id, cast(v as numeric(20,0)) as amount, case when v < 0 then cast(NULL as varchar(20)) else cast(v as varchar(20)) end as payload from t_chain order by v, id limit 3;


evaluate 'Case 9: Hidden NULL sort keys with id tie breaker; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by case when v < 0 then NULL else v end, id limit 3;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by case when v < 0 then NULL else v end, id limit 3;


evaluate 'Case 10: Full sort without top-N; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain where v < 0 or v between 1001 and 1003 order by v, id;
show trace;
select /*+ recompile no_parallel_scan */ id, v from t_chain where v < 0 or v between 1001 and 1003 order by v, id;
delete from t_chain where id = 1;
update statistics on t_chain with fullscan;


evaluate 'Case 11: Empty first partition; result = NO_PARALLEL_SCAN';
select /*+ recompile */ id, v from t_chain order by v, id limit 3;
show trace;
-- Disable tracing before the final untraced reference to avoid leaking a plan
set trace off;
select /*+ recompile no_parallel_scan */ id, v from t_chain order by v, id limit 3;

drop table t_chain;

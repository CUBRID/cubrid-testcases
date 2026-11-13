-- Verification for CBRD-27821
-- A hash join whose probe evaluates a join term that holds a session variable must keep
-- the probe serial, as a parallel scan does. Before the fix the parallel probe workers updated the
-- session variable list of the leader concurrently and the server crashed.
--   Case 1-4, 6 : a session variable reaches the probe workers -> COUNT(*) is 4096 and PROBE has no parallel workers
--   Case 5      : a serial NEXT_VALUE -> PROBE keeps its parallel workers
--   Case 7      : a plain hash join -> PROBE keeps its parallel workers
-- Sizing: CTP runs with test_mode=yes, which lowers parallel_hash_join_page_threshold to its 2-page
-- floor; 4096 rows give a probe list above it, so Case 7 shows the parallel probe.

drop table if exists t_sv;
drop serial if exists s_sv;

create table t_sv (id int, c int);
insert into t_sv select rownum, rownum from db_root connect by level <= 4096;
create serial s_sv;
set @v = 0;
set @w = 0;

set trace on;

evaluate 'Case 1 : session variable assignment in a WHERE residual join term';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a join t_sv b on a.id = b.id where (@v := a.c + b.c) > 0;
show trace;

evaluate 'Case 2 : session variable assignment in an ON residual join term';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a join t_sv b on a.id = b.id and (@v := a.c + b.c) > 0;
show trace;

evaluate 'Case 3 : session variable assignment in a LEFT JOIN ON term (during join)';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a left join t_sv b on a.id = b.id and (@v := a.c + b.c) > 0;
show trace;

evaluate 'Case 4 : session variable read in a residual join term keeps the probe serial';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a join t_sv b on a.id = b.id where a.c + @w >= b.c;
show trace;

evaluate 'Case 5 : serial NEXT_VALUE in a residual join term keeps the parallel probe';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a join t_sv b on a.id = b.id where a.c + b.c + 0 * s_sv.next_value > 0;
show trace;

evaluate 'Case 6 : the PARALLEL hint does not override the restriction';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery parallel(4) */ count(*) from t_sv a join t_sv b on a.id = b.id where (@v := a.c + b.c) > 0;
show trace;

evaluate 'Case 7 : a hash join without session variables keeps the parallel probe';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_sv a join t_sv b on a.id = b.id where a.c + b.c > 0;
show trace;

set trace off;

drop variable @v, @w;
drop table t_sv;
drop serial s_sv;

/**
 *  This test case verifies CBRD-27100: an index scan runs in parallel only when the
 *  estimate behind it is backed by a histogram or a PARALLEL hint asks for it, and
 *  never when the index file itself is smaller than the parallel scan page threshold.
 *
 *  Before the fix a range without a histogram used the default selectivity (0.1 for a
 *  one-sided range), so a 199-row range over a large index was scanned in parallel. With
 *  a PARALLEL hint the server trusted the requested degree, even for a 3-page index.
 *  Now a range without a hint is a parallel candidate only when its selectivity comes
 *  from a histogram, and the server keeps any index scan serial while the b-tree file
 *  has fewer user pages than parallel_scan_page_threshold (32 under test_mode).
 *
 *  Each query is followed by its parallel(0) twin, whose result must be the same. The
 *  trace tells the path: a parallel index scan prints a parallel workers line with
 *  index time under its SCAN line. CTP masks the digits, so only that line is asserted.
 *  On develop UPDATE STATISTICS also builds histograms, which estimate the range of
 *  case 1 below the threshold but cannot estimate the subquery bound of case 2.
 *
 *  Coverage:
 *    Case 1:  a narrow constant range over a large index without a hint stays serial
 *    Case 2:  a range bounded by a subquery has no histogram estimate and stays serial
 *    Case 3:  the PARALLEL hint skips the estimate, the narrow range of case 1 runs in parallel
 *    Case 4:  the PARALLEL hint on an index of 3 pages stays serial
 *    Case 5:  the PARALLEL hint on a 2-page b-tree whose keys fill the overflow key file stays serial
 */

drop table if exists t_big, t_small, t_long;

-- 100,000 rows; the 256-character pad (two sha2 strings, which do not compress) makes the (k, pad)
-- index about 1,900 pages, so the default estimate of a one-sided range (0.1 x pages) is far above
-- the threshold of 32 pages
create table t_big (k int, pad varchar(256));
insert into t_big select rownum, concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c, db_class d limit 100000;
create index i_big on t_big (k, pad);

-- 1,000 rows; the index on k has 3 pages, far below the threshold
create table t_small (k int, v int);
insert into t_small select rownum, rownum from db_class a, db_class b limit 1000;
create index i_small on t_small (k);

-- 200 keys of 3,008 characters, 94 distinct md5 strings each so they do not compress. A key
-- longer than 2,048 bytes is kept in the overflow key file, one page or more per key, and the
-- b-tree file itself has 2 pages
set system parameters 'group_concat_max_len=8192';
create table t_long (s varchar(4000));
insert into t_long select (select group_concat(md5(o.k * 1000 + i.k) separator '') from t_small i where i.k <= 94) from t_small o where o.k <= 200;
create index i_long on t_long (s);
set system parameters 'group_concat_max_len=default';

update statistics on t_big, t_small, t_long with fullscan;

set trace on;


evaluate 'Case 1: a narrow constant range over a large index without a hint stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 2: a range bounded by a subquery has no histogram estimate and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k > (select 1000) using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > (select 1000) using index i_big;


evaluate 'Case 3: the PARALLEL hint skips the estimate and the narrow range runs in parallel; result = parallel(0)';
select /*+ recompile parallel(4) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 4: the PARALLEL hint on an index of 3 pages stays serial; result = parallel(0)';
select /*+ recompile parallel(4) */ count(*), sum(k) from t_small where k > 0 using index i_small;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(k) from t_small where k > 0 using index i_small;


evaluate 'Case 5: the PARALLEL hint on a 2-page b-tree whose keys fill the overflow key file stays serial; result = parallel(0)';
select /*+ recompile parallel(4) */ count(*), sum(char_length(s)) from t_long where s > '' using index i_long;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ count(*), sum(char_length(s)) from t_long where s > '' using index i_long;


drop table t_big, t_small, t_long;

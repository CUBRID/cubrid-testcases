/**
 *  This test case verifies CBRD-27100: an index scan runs in parallel only when a histogram
 *  estimate or a PARALLEL(N) hint asks for it, and never on an index under the page threshold.
 *
 *  Before the fix a range without a histogram used a default selectivity (0.1 one-sided) and a
 *  hint ran on any index. Now a range without a hint stays serial unless every key-range term
 *  has a histogram estimate, and the server keeps a b-tree file under 32 pages serial.
 *
 *  Each query is followed by its parallel(0) twin, whose result must be the same. A parallel
 *  index scan prints a parallel workers line under its SCAN line; CTP masks the digits.
 *  Develop builds histograms in UPDATE STATISTICS; each no-hint case stays serial with them.
 *
 *  Coverage:
 *    Case 1:  no hint, a narrow constant range over a large index stays serial
 *    Case 2:  no hint, a range bounded by a subquery has no histogram estimate, serial
 *    Case 3:  PARALLEL(4) skips the estimate, the narrow range of case 1 runs in parallel
 *    Case 4:  PARALLEL(4) on an index of 3 pages stays serial
 *    Case 5:  PARALLEL(4) on a 2-page b-tree whose keys fill the overflow key file, serial
 *    Case 6:  a PARALLEL hint without a degree is no hint, case 1 stays serial
 *    Case 7:  PARALLEL(1) stays serial
 *    Case 8:  PARALLEL(2), the smallest degree, runs in parallel
 *    Case 9:  no hint, a range over a function index has no histogram estimate, serial
 *    Case 10: no hint, an equality with a subquery has no histogram estimate, serial
 *    Case 11: no hint, an IN list with a subquery element, serial
 *    Case 12: no hint, an IN list over a column pair has no histogram estimate, serial
 *    Case 13: PARALLEL(4) with a list result on the index of case 4 stays serial
 *    Case 14: PARALLEL(4) with a list result on a large index runs in parallel
 *    Case 15: PARALLEL(4) on 16 partitions whose indexes are each under 32 pages, serial
 *    Case 16: PARALLEL(4) on partitions where one index is large runs in parallel
 */

drop table if exists t_big, t_small, t_long, t_part, t_mix;

-- 150,000 rows, k = 1..150000, g = k mod 2, v = k mod 3; the 256-character pad (two sha2 strings,
-- which do not compress) makes each index about 2,800 pages. Without a histogram a one-sided range
-- is estimated at 0.1 x 2,800 = 280 pages and an equality on g at 0.5 x 2,800, at least 8x the
-- threshold of 32, so the build before the fix ran every no-hint case in parallel. On develop the
-- histogram puts case 1 at about 4 pages, 1/8 of the threshold
create table t_big (k int, g int, v int, pad varchar(256));
insert into t_big select rownum, mod(rownum, 2), mod(rownum, 3), concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c, db_class d limit 150000;
create index i_big on t_big (k, pad);
create index i_grp on t_big (g, v, pad);
create index i_fn on t_big (lower(pad));

-- 1,000 rows; the index on k has 3 pages, 1/8 of the threshold
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

-- 16 partitions of 250 rows; each local index has 6 pages (1/5 of the threshold), all of them
-- together about 100 pages (3x the threshold)
create table t_part (k int, pad varchar(256)) partition by range (k) (partition pa values less than (251), partition pb values less than (501), partition pc values less than (751), partition pd values less than (1001), partition pe values less than (1251), partition pf values less than (1501), partition pg values less than (1751), partition ph values less than (2001), partition pi values less than (2251), partition pj values less than (2501), partition pk values less than (2751), partition pl values less than (3001), partition pm values less than (3251), partition pn values less than (3501), partition po values less than (3751), partition pp values less than maxvalue);
insert into t_part select rownum, concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c limit 4000;
create index i_part on t_part (k, pad);

-- 3 partitions; the middle one holds 12,000 rows and its index about 230 pages (7x the threshold)
create table t_mix (k int, pad varchar(256)) partition by range (k) (partition pa values less than (251), partition pb values less than (12251), partition pc values less than maxvalue);
insert into t_mix select rownum, concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c limit 12500;
create index i_mix on t_mix (k, pad);

update statistics on t_big, t_small, t_long, t_part, t_mix with fullscan;

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
select /*+ recompile parallel(0) */ count(*), sum(char_length(s)) from t_long where s > '' using index i_long;


evaluate 'Case 6: a PARALLEL hint without a degree is not a hint and the narrow range stays serial; result = parallel(0)';
select /*+ recompile parallel */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 7: PARALLEL(1) asks for one thread and stays serial; result = parallel(0)';
select /*+ recompile parallel(1) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 8: PARALLEL(2), the smallest parallel degree, runs in parallel; result = parallel(0)';
select /*+ recompile parallel(2) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 9: a range over a function index has no histogram estimate and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where lower(pad) < '1' using index i_fn;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where lower(pad) < '1' using index i_fn;


evaluate 'Case 10: an equality with a subquery has no histogram estimate and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = (select 1) using index i_grp;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = (select 1) using index i_grp;


evaluate 'Case 11: an IN list with a subquery element has no histogram estimate and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g in ((select 0), 1) using index i_grp;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g in ((select 0), 1) using index i_grp;


evaluate 'Case 12: an IN list over a column pair has no histogram estimate and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where (g, v) in ((0, 0), (1, 1)) using index i_grp;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where (g, v) in ((0, 0), (1, 1)) using index i_grp;


evaluate 'Case 13: the PARALLEL hint with a list result on the 3-page index stays serial; result = parallel(0)';
select /*+ recompile parallel(4) */ k, v from t_small force index (i_small) where k < 6 order by v, k;
show trace;
select /*+ recompile parallel(0) */ k, v from t_small force index (i_small) where k < 6 order by v, k;


evaluate 'Case 14: the PARALLEL hint with a list result on a large index runs in parallel; result = parallel(0)';
select /*+ recompile parallel(4) */ k, g from t_big force index (i_big) where k < 6 order by g, k;
show trace;
select /*+ recompile parallel(0) */ k, g from t_big force index (i_big) where k < 6 order by g, k;


evaluate 'Case 15: the PARALLEL hint on partitions whose indexes are each under the threshold stays serial; result = parallel(0)';
select /*+ recompile parallel(4) */ count(*), sum(cast(k as bigint)) from t_part where k > 0 using index i_part;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_part where k > 0 using index i_part;


evaluate 'Case 16: the PARALLEL hint on partitions where one index is large runs in parallel; result = parallel(0)';
select /*+ recompile parallel(4) */ count(*), sum(cast(k as bigint)) from t_mix where k > 0 using index i_mix;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_mix where k > 0 using index i_mix;


drop table t_big, t_small, t_long, t_part, t_mix;

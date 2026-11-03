-- CBRD-27236: an index build merges its runs from as many temp files as half the sort buffer holds pages
--
-- The merge of an index build sort used to read 4 runs at a time whatever the sort buffer. It now reads up to
-- index_build_buffer_size / 2 pages of runs, one run per page at full fan-in, and index_build_merge_fanin caps
-- that number (256 by default, 0 sets no cap, 1 is taken as 2). The SQL cases of CBRD-27381 sort with 64K and
-- 128K, a fan-in of 2 and 4 as before, so they never reach a pass of more than 4 runs.
--
-- Each index here is built on the same rows once with a 16M buffer, which sorts them in memory with no merge,
-- and again under each merge setting. Every build is read in index order into sig as the row count and a sum
-- that weighs each id by its position, so a build that loses a row or moves one gives another sum: every index
-- must give one count and one sum over all its builds.
--
-- Rows: 150000, a scattered INT, a VARCHAR of signed numbers with a suffix of up to 29 characters (NULL every
-- 101st row), and an INT of 7 values, whose index i_g merges keys that tie across 8 and 16 runs in the order of
-- their OIDs. The passes each setting takes (merge log of log_btree_operations on a debug build, whose radix
-- sorter flushes more runs than the merge sorter of a release build):
--   256K (16 pages, fan-in 8):      i_k 20 runs: 8 at a time to 3, then 3 into the index
--                                   i_s 37 runs: to 5, then 5; i_gs 42 runs: to 6, then 6; i_g 20 runs: to 3, then 3
--   512K (32 pages, fan-in 16):     i_k 10 runs: 10 into the index in one pass
--                                   i_s 18 runs: to 2, then 2; i_gs 21 runs: to 2, then 2; i_g 10 runs: one pass
--   256K, index_build_merge_fanin 3: i_k 20 runs: to 7, to 3, then 3
--   256K, index_build_merge_fanin 1: i_s 37 runs, 2 at a time in six passes
--   256K, index_build_merge_fanin 2147483647 and 0: no cap, the passes of 256K
-- A value below 0 or above 2147483647, or one that is not a number, is refused and leaves the value as it was.

drop table if exists t;
drop table if exists sig;

create table t (id int not null, k int, s varchar(60) collate utf8_bin, g int);
insert into t
  select n, mod (n * 7919, 1000003) - 500000,
         case when mod (n, 101) = 0 then null
              else concat (mod (n * 104729, 2000003) - 1000000, repeat ('x', mod (n, 30))) end,
         mod (n, 7)
  from (select rownum as n from db_class a, db_class b, db_class c limit 150000) x;

-- one row per build of an index: the setting, the rows read in index order, and their position-weighted sum
create table sig (tag varchar(10), cfg varchar(20), cnt int, sg bigint);

-- the reference: one run sorted in memory
set system parameters 'index_build_buffer_size=16M';
create index i_k on t (k);
create index i_kd on t (k desc);
create index i_s on t (s);
create index i_gs on t (g, s desc);
create index i_g on t (g);
insert into sig select 'k', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 'kd', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_kd) x;
insert into sig select 's', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
insert into sig select 'gs', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_gs) x;
insert into sig select 'g', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_g) x;
drop index i_k on t;
drop index i_kd on t;
drop index i_s on t;
drop index i_gs on t;
drop index i_g on t;

-- fan-in 8
set system parameters 'index_build_buffer_size=256K';
create index i_k on t (k);
create index i_kd on t (k desc);
create index i_s on t (s);
create index i_gs on t (g, s desc);
create index i_g on t (g);
insert into sig select 'k', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 'kd', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_kd) x;
insert into sig select 's', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
insert into sig select 'gs', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_gs) x;
insert into sig select 'g', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_g) x;
drop index i_k on t;
drop index i_kd on t;
drop index i_s on t;
drop index i_gs on t;
drop index i_g on t;

-- fan-in 16
set system parameters 'index_build_buffer_size=512K';
create index i_k on t (k);
create index i_kd on t (k desc);
create index i_s on t (s);
create index i_gs on t (g, s desc);
create index i_g on t (g);
insert into sig select 'k', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 'kd', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_kd) x;
insert into sig select 's', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
insert into sig select 'gs', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_gs) x;
insert into sig select 'g', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where g >= 0 using index i_g) x;
drop index i_k on t;
drop index i_kd on t;
drop index i_s on t;
drop index i_gs on t;
drop index i_g on t;

-- the cap: 3, then 1 (taken as 2), then the largest value and 0 (no cap)
set system parameters 'index_build_buffer_size=256K';
set system parameters 'index_build_merge_fanin=3';
create index i_k on t (k);
create index i_s on t (s);
insert into sig select 'k', '256K cap 3', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 's', '256K cap 3', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
drop index i_k on t;
drop index i_s on t;
set system parameters 'index_build_merge_fanin=1';
create index i_k on t (k);
create index i_s on t (s);
insert into sig select 'k', '256K cap 1', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 's', '256K cap 1', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
drop index i_k on t;
drop index i_s on t;
set system parameters 'index_build_merge_fanin=2147483647';
create index i_k on t (k);
create index i_s on t (s);
insert into sig select 'k', '256K cap max', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 's', '256K cap max', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
drop index i_k on t;
drop index i_s on t;
set system parameters 'index_build_merge_fanin=0';
create index i_k on t (k);
create index i_s on t (s);
insert into sig select 'k', '256K cap 0', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where k >= -500000 using index i_k) x;
insert into sig select 's', '256K cap 0', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from t where s >= '' using index i_s) x;
drop index i_k on t;
drop index i_s on t;

-- refused values
set system parameters 'index_build_merge_fanin=-1';
set system parameters 'index_build_merge_fanin=2147483648';
set system parameters 'index_build_merge_fanin=two';

set system parameters 'index_build_merge_fanin=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- every build of an index holds the same rows in the same order: 1 sum per index, and its count
select tag, count (*) as builds, count (distinct sg) as sums, min (cnt), max (cnt) from sig group by tag order by tag;

drop table t;
drop table sig;

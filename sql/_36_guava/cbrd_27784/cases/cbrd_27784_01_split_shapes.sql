-- CBRD-27784: a run the merge sorter splits into buckets (sample sort) comes out in the order of the run it merges whole
--
-- An index build sorts each run of its sort buffer in memory. With index_sort_method=compare and a run of 4MB or
-- more, the merge sorter picks splitters from a sample, puts each record in the bucket between two splitters or in
-- the bucket of a splitter's key, and merges the buckets one by one. A run that arrives nearly in order is merged
-- whole instead. index_build_buffer_size 64K holds a few hundred records a run, which are never split.
--
-- Each index here is built on one table with compare and index_build_buffer_size 64K, read in index order into d
-- with the row's position and id, then dropped and built again with 8M and read again. The two builds hold the same
-- OIDs, so they must return the same ids in the same positions (0 rows differ) and find as many rows: keys the
-- compare function calls equal lie in OID order in both.
--
-- Rows: 60000. Each key ends in w, a CHAR(200), so a sort record takes about 230 bytes and 8M sorts the rows in two
-- runs. The heap stays under the page threshold of a parallel build. Rows inserted in id order need not reach the
-- build in id order (before CBRD-27311 the heap filled some of its new pages out of chain order), so up numbers the
-- rows in the order a heap scan reads them (a serial in an UPDATE) and the keys that arrive nearly in order are made
-- from it. The keys of few values are taken from krand, as keys repeating in id order can look to the sorter as if
-- they arrived in order.
--
-- Covers:
--   - keys spread over the rows, ascending and descending
--   - few values: 4, 7 and 50 values, one value in 99 rows of 100, values repeating every 64 rows
--   - a NULL key column in a third of the rows, read through (z, nz, w)
--   - runs merged whole as they arrive nearly in order: rising, falling, one row out of place in 1024;
--     a run split though it rises: one row out of place in 32
--   - the buffers around the smallest split: 4M (a run stays under 4MB, never split) and 5M (split)

drop table if exists t;
drop table if exists d;

create table t (id int not null, z int, krand int, few4 int, few7 int, few50 int, one99 int, nz int, per64 int,
                up int, near32 int, near1024 int, down int, w char(200));

insert into t
  select n, 0, k, mod (k, 4), mod (k, 7), mod (k, 50),
         case when mod (k, 100) = 0 then k else 0 end,
         case when mod (k, 3) = 0 then null else mod (k, 5) end,
         mod (n, 64), 0, 0, 0, 0, 'w'
  from (select rownum as n, mod (rownum * 7919, 60013) as k
        from db_class a, db_class b, db_class c limit 60000) x
  order by n;

-- the position of each row in a heap scan, and the keys made from it
drop serial if exists s_up;
create serial s_up start with 1;
update t set up = s_up.next_value;
update t set down = -up, near32 = case when mod (up, 32) = 0 then 60001 - up else up end,
             near1024 = case when mod (up, 1024) = 0 then 60001 - up else up end;
drop serial s_up;

-- the 64K build of each index read in index order: the index, the position and the id
create table d (tag varchar(10), r int, id int);

set system parameters 'index_sort_method=compare';
set system parameters 'index_build_buffer_size=64K';
create index i_rand on t (krand, w);
create index i_randd on t (krand desc, w);
create index i_few4 on t (few4, w);
create index i_few7 on t (few7, w);
create index i_few50 on t (few50, w);
create index i_one99 on t (one99, w);
create index i_nz on t (z, nz, w);
create index i_per64 on t (per64, w);
create index i_up on t (up, w);
create index i_down on t (down, w);
create index i_near32 on t (near32, w);
create index i_near1024 on t (near1024, w);

insert into d select 'rand', r, id from (select rownum as r, id from t where krand >= 0 using index i_rand) x;
insert into d select 'randd', r, id from (select rownum as r, id from t where krand >= 0 using index i_randd) x;
insert into d select 'few4', r, id from (select rownum as r, id from t where few4 >= 0 using index i_few4) x;
insert into d select 'few7', r, id from (select rownum as r, id from t where few7 >= 0 using index i_few7) x;
insert into d select 'few50', r, id from (select rownum as r, id from t where few50 >= 0 using index i_few50) x;
insert into d select 'one99', r, id from (select rownum as r, id from t where one99 >= 0 using index i_one99) x;
insert into d select 'nz', r, id from (select rownum as r, id from t where z >= 0 using index i_nz) x;
insert into d select 'per64', r, id from (select rownum as r, id from t where per64 >= 0 using index i_per64) x;
insert into d select 'up', r, id from (select rownum as r, id from t where up >= 0 using index i_up) x;
insert into d select 'down', r, id from (select rownum as r, id from t where down >= -60000 using index i_down) x;
insert into d select 'near32', r, id from (select rownum as r, id from t where near32 >= 0 using index i_near32) x;
insert into d select 'near1024', r, id from (select rownum as r, id from t where near1024 >= 0 using index i_near1024) x;

-- the same indexes built again with 8M
set system parameters 'index_build_buffer_size=8M';
drop index i_rand on t;
create index i_rand on t (krand, w);
drop index i_randd on t;
create index i_randd on t (krand desc, w);
drop index i_few4 on t;
create index i_few4 on t (few4, w);
drop index i_few7 on t;
create index i_few7 on t (few7, w);
drop index i_few50 on t;
create index i_few50 on t (few50, w);
drop index i_one99 on t;
create index i_one99 on t (one99, w);
drop index i_nz on t;
create index i_nz on t (z, nz, w);
drop index i_per64 on t;
create index i_per64 on t (per64, w);
drop index i_up on t;
create index i_up on t (up, w);
drop index i_down on t;
create index i_down on t (down, w);
drop index i_near32 on t;
create index i_near32 on t (near32, w);
drop index i_near1024 on t;
create index i_near1024 on t (near1024, w);

-- positions and ids of the 64K build that the 8M build does not have: 0 each
select 'rand', count(*) from ((select r, id from d where tag = 'rand')
  difference (select rownum, id from t where krand >= 0 using index i_rand)) x;
select 'randd', count(*) from ((select r, id from d where tag = 'randd')
  difference (select rownum, id from t where krand >= 0 using index i_randd)) x;
select 'few4', count(*) from ((select r, id from d where tag = 'few4')
  difference (select rownum, id from t where few4 >= 0 using index i_few4)) x;
select 'few7', count(*) from ((select r, id from d where tag = 'few7')
  difference (select rownum, id from t where few7 >= 0 using index i_few7)) x;
select 'few50', count(*) from ((select r, id from d where tag = 'few50')
  difference (select rownum, id from t where few50 >= 0 using index i_few50)) x;
select 'one99', count(*) from ((select r, id from d where tag = 'one99')
  difference (select rownum, id from t where one99 >= 0 using index i_one99)) x;
select 'nz', count(*) from ((select r, id from d where tag = 'nz')
  difference (select rownum, id from t where z >= 0 using index i_nz)) x;
select 'per64', count(*) from ((select r, id from d where tag = 'per64')
  difference (select rownum, id from t where per64 >= 0 using index i_per64)) x;
select 'up', count(*) from ((select r, id from d where tag = 'up')
  difference (select rownum, id from t where up >= 0 using index i_up)) x;
select 'down', count(*) from ((select r, id from d where tag = 'down')
  difference (select rownum, id from t where down >= -60000 using index i_down)) x;
select 'near32', count(*) from ((select r, id from d where tag = 'near32')
  difference (select rownum, id from t where near32 >= 0 using index i_near32)) x;
select 'near1024', count(*) from ((select r, id from d where tag = 'near1024')
  difference (select rownum, id from t where near1024 >= 0 using index i_near1024)) x;

-- rows each 8M build finds: every row. With 0 rows differing above, the same count means the two builds hold
-- the same rows in the same order
select count(*) from t where krand >= 0 using index i_rand;
select count(*) from t where krand >= 0 using index i_randd;
select count(*) from t where few4 >= 0 using index i_few4;
select count(*) from t where few7 >= 0 using index i_few7;
select count(*) from t where few50 >= 0 using index i_few50;
select count(*) from t where one99 >= 0 using index i_one99;
select count(*) from t where z >= 0 using index i_nz;
select count(*) from t where per64 >= 0 using index i_per64;
select count(*) from t where up >= 0 using index i_up;
select count(*) from t where down >= -60000 using index i_down;
select count(*) from t where near32 >= 0 using index i_near32;
select count(*) from t where near1024 >= 0 using index i_near1024;

-- the buffers around the smallest split, against the 64K build of i_rand
set system parameters 'index_build_buffer_size=4M';
drop index i_rand on t;
create index i_rand on t (krand, w);
select 'rand 4M', count(*) from ((select r, id from d where tag = 'rand')
  difference (select rownum, id from t where krand >= 0 using index i_rand)) x;
select count(*) from t where krand >= 0 using index i_rand;

set system parameters 'index_build_buffer_size=5M';
drop index i_rand on t;
create index i_rand on t (krand, w);
select 'rand 5M', count(*) from ((select r, id from d where tag = 'rand')
  difference (select rownum, id from t where krand >= 0 using index i_rand)) x;
select count(*) from t where krand >= 0 using index i_rand;

set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows each 64K build found
select tag, count(*) from d group by tag order by 1;

drop table t;
drop table d;

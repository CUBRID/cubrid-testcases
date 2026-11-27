-- CBRD-27236: keys longer than a page go through merges of more than 4 runs
--
-- A sort record longer than a page is kept outside the run, and the run holds a pointer to it: such a key
-- makes a run of its own, and the merge reads the record back while it compares and copies. lk holds 30000
-- rows, every 100th with a key of 17000 characters. A long key is a run of SHA-512 digests, which the string
-- compression cannot shrink below a page, and an update gives it to rows already in place, so the long keys lie
-- among the short ones in the heap and a build flushes 600 runs: the 300 long keys in runs of their own and the
-- 300 runs of short keys between them. Every row also carries a pad of 768 characters (6 digests), which is not
-- indexed: a sort makes no more run files than its heap holds data sectors (a temp file takes a sector at least),
-- and the long records live in the overflow file apart from the heap, so the pad keeps the heap at 28 sectors,
-- above the 16 run files of 512K, and below the 2048 pages from which a build goes parallel by default. lk is
-- built with 2M (fan-in 28, the sectors of the heap, below the 64 of the buffer: to 22, then 22), 256K (fan-in
-- 8: to 75, 10, 2, then 2), 512K (fan-in 16: to 38, 3, then 3) and 256K with index_build_merge_fanin 2 (ten
-- passes), and every build must read back the same rows in the same order, the long keys among them. Every
-- build merges, so the reference is the heap sorted by the query sort, which is apart from the sort of an index
-- build: the first 6 characters of the keys differ from row to row, so the keys have one order.
--
-- Two more tables take the rows of lk with id <= 800, which hold 8 long keys and so make 16 runs (the long keys
-- and the short runs before them), merged only by fan-in and run count:
--   lk_small, those rows without the pad: 5 heap pages in 1 sector, so at 256K (fan-in 8 by the buffer) the
--     sectors leave a fan-in of 1, which a merge cannot take, and the build merges at the floor of 2: 16 runs
--     to 8, 4, 2, then 2.
--   filter indexes on lk at 512K (fan-in 16): id <= 800 makes 16 runs, as many as the fan-in, which go into
--     the index in one pass; id <= 850 adds the short run after the last long key, 17 runs, so the first pass
--     merges 16 of them and copies the 17th, and a second pass puts the 2 runs. The rows the filter leaves out
--     make no runs. A filter index must name an indexed column, hence s is not null.
-- lk_one holds one row of lk, with a long key: the only record of the sort is outside the run, so the build
-- has no merge and reads the record back from the run file before it puts it in the index.
-- The passes are from the merge log of log_btree_operations, the same on a release and a debug build.

drop table if exists lk;
drop table if exists lk_small;
drop table if exists lk_one;
drop table if exists lv;
drop table if exists nums;
drop table if exists sig;

create table lk (id int not null, s varchar(20000) collate utf8_bin, p varchar(768));
insert into lk
  select n, concat (lpad (mod (n * 7919, 30011), 6, '0'), repeat ('a', mod (n, 20))),
         concat (sha2 (n * 8 + 1, 512), sha2 (n * 8 + 2, 512), sha2 (n * 8 + 3, 512), sha2 (n * 8 + 4, 512),
                 sha2 (n * 8 + 5, 512), sha2 (n * 8 + 6, 512))
  from (select rownum as n from db_class a, db_class b, db_class c limit 30000) x;

-- the long keys: 140 digests of 128 characters each, cut to 16994 after the 6 characters of the short key
create table nums (i int);
insert into nums select rownum from db_class a, db_class b limit 140;
create table lv (id int primary key, v varchar(20000));
set system parameters 'group_concat_max_len=40000';
insert into lv select n, substr ((select group_concat (sha2 (n * 1000 + i, 512) order by 1 separator '') from nums), 1, 16994)
  from (select rownum * 100 as n from db_class a, db_class b limit 300) x;
set system parameters 'group_concat_max_len=DEFAULT';
update lk inner join lv on lk.id = lv.id set lk.s = concat (substr (lk.s, 1, 6), lv.v);

create table lk_small (id int not null, s varchar(20000) collate utf8_bin);
insert into lk_small select id, s from lk where id <= 800;
create table lk_one (id int not null, s varchar(20000) collate utf8_bin);
insert into lk_one select id, s from lk where id = 100;

create table sig (tag varchar(10), cfg varchar(20), cnt int, sg bigint, nlong int);

-- the reference: the heap in key order, with no index
insert into sig select 's', 'heap', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from (select id, s from lk where s >= '' using index none order by s) y) x;

set system parameters 'index_build_buffer_size=2M';
create index i_s on lk (s);
insert into sig select 's', '2M', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' using index i_s) x;
drop index i_s on lk;

set system parameters 'index_build_buffer_size=256K';
create index i_s on lk (s);
insert into sig select 's', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' using index i_s) x;
drop index i_s on lk;

set system parameters 'index_build_buffer_size=512K';
create index i_s on lk (s);
insert into sig select 's', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' using index i_s) x;
drop index i_s on lk;

set system parameters 'index_build_buffer_size=256K';
set system parameters 'index_build_merge_fanin=2';
create index i_s on lk (s);
insert into sig select 's', '256K cap 2', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' using index i_s) x;
drop index i_s on lk;
set system parameters 'index_build_merge_fanin=DEFAULT';

-- a heap of 1 sector: the fan-in goes to its floor of 2
insert into sig select 'small', 'heap', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from (select id, s from lk_small where s >= '' using index none order by s) y) x;
set system parameters 'index_build_buffer_size=256K';
create index i_small on lk_small (s);
insert into sig select 'small', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk_small where s >= '' using index i_small) x;

-- one row with a long key
insert into sig select 'one', 'heap', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from (select id, s from lk_one where s >= '' using index none order by s) y) x;
create index i_one on lk_one (s);
insert into sig select 'one', 'index', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk_one where s >= '' using index i_one) x;
select id, length (s), s = (select s from lk where id = 100) from lk_one where s >= '' using index i_one;

-- as many runs as the fan-in, and one more
insert into sig select 'f800', 'heap', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from (select id, s from lk where s is not null and id <= 800 using index none order by s) y) x;
insert into sig select 'f850', 'heap', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from (select id, s from lk where s is not null and id <= 850 using index none order by s) y) x;
set system parameters 'index_build_buffer_size=512K';
create index i_f on lk (s) where s is not null and id <= 800;
insert into sig select 'f800', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' and s is not null and id <= 800 using index i_f) x;
drop index i_f on lk;
create index i_f on lk (s) where s is not null and id <= 850;
insert into sig select 'f850', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)), sum (case when length (s) > 16000 then 1 else 0 end)
  from (select rownum as r, id, s from lk where s >= '' and s is not null and id <= 850 using index i_f) x;
drop index i_f on lk;
set system parameters 'index_build_buffer_size=DEFAULT';

-- every build holds the rows of the heap in the same order: 1 sum, of 30000 rows with 300 long (s), 800 with 8
-- long (small, f800), 850 with 8 long (f850) and 1 with 1 long (one)
select tag, count (*) as builds, count (distinct sg) as sums, min (cnt), max (cnt), min (nlong), max (nlong) from sig group by tag order by tag;

drop table lk;
drop table lk_small;
drop table lk_one;
drop table lv;
drop table nums;
drop table sig;

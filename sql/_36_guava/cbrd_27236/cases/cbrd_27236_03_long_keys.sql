-- CBRD-27236: keys longer than a page go through merges of more than 4 runs
--
-- A sort record longer than a page is kept outside the run, and the run holds a pointer to it: such a key
-- makes a run of its own, and the merge reads the record back while it compares and copies. lk holds 30000
-- rows, every 100th with a key of 17000 characters. A long key is a run of SHA-512 digests, which the string
-- compression cannot shrink below a page, and an update gives it to rows already in place, so the long keys lie
-- among the short ones in the heap and a build flushes 600 runs: the 300 long keys in runs of their own and the
-- 300 runs of short keys between them. lk is built with 2M (fan-in 64: to 10, then 10), 256K (fan-in 8: to 75,
-- 10, 2, then 2), 512K (fan-in 16: to 38, 3, then 3) and 256K with index_build_merge_fanin 2 (ten passes), and
-- every build must read back the same rows in the same order, the long keys among them.

drop table if exists lk;
drop table if exists lv;
drop table if exists nums;
drop table if exists sig;

create table lk (id int not null, s varchar(20000) collate utf8_bin);
insert into lk
  select n, concat (lpad (mod (n * 7919, 30011), 6, '0'), repeat ('a', mod (n, 20)))
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

create table sig (tag varchar(10), cfg varchar(20), cnt int, sg bigint, nlong int);

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
set system parameters 'index_build_buffer_size=DEFAULT';

-- every build holds the same rows in the same order: 1 sum, 30000 rows of which 300 long
select tag, count (*) as builds, count (distinct sg) as sums, min (cnt), max (cnt), min (nlong), max (nlong) from sig group by tag order by tag;

drop table lk;
drop table lv;
drop table nums;
drop table sig;

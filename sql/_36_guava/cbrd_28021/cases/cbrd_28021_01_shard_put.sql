-- CBRD-28021: with the default settings a logged parallel index build puts its leaves with the shard workers
--
-- s holds 150000 rows of about 300 bytes: its heap takes about 3,200 data pages, over the 2,048 of
-- parallel_index_build_page_threshold, so a build takes 2 workers where the machine has more than 2 cores, and each
-- worker puts the leaves of one key range (fewer cores: the build sorts serially, and reads the same). Each index is
-- built with index_build_parallel_leaf on (the shard put) and off (the merge of the main thread), and both builds
-- must read back the same rows in the same order: the count and a position-weighted sum of the ids, by tag, give
-- one sum. k is in utf8_en_ci and gives every two rows one key in two cases: the shards split the keys by the
-- collation, so the unique index on k fails with the violation either way, while the one on id builds.

drop table if exists s;
drop table if exists sig;

create table s (id int not null, k varchar(40) collate utf8_en_ci, g int, n int, p char(240));
insert into s
  select r, concat (lpad (r div 2, 7, '0'), case when mod (r, 2) = 0 then 'abcdefghij' else 'ABCDEFGHIJ' end),
         mod (r, 7), case when mod (r, 10) = 0 then null else r end, 'p'
  from (select rownum as r from db_class a, db_class b, db_class c limit 150000) x;

create table sig (tag varchar(10), cfg varchar(10), cnt int, sg bigint);

-- id
set system parameters 'index_build_parallel_leaf=yes';
create index i_s on s (id);
insert into sig select 'id', 'on', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where id >= 0 using index i_s) x;
drop index i_s on s;
set system parameters 'index_build_parallel_leaf=no';
create index i_s on s (id);
insert into sig select 'id', 'off', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where id >= 0 using index i_s) x;
drop index i_s on s;

-- (g, id desc)
set system parameters 'index_build_parallel_leaf=yes';
create index i_s on s (g, id desc);
insert into sig select 'g id desc', 'on', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where g >= 0 using index i_s) x;
drop index i_s on s;
set system parameters 'index_build_parallel_leaf=no';
create index i_s on s (g, id desc);
insert into sig select 'g id desc', 'off', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where g >= 0 using index i_s) x;
drop index i_s on s;

-- n: NULL on every tenth row, which the index leaves out
set system parameters 'index_build_parallel_leaf=yes';
create index i_s on s (n);
insert into sig select 'n', 'on', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where n >= 0 using index i_s) x;
drop index i_s on s;
set system parameters 'index_build_parallel_leaf=no';
create index i_s on s (n);
insert into sig select 'n', 'off', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where n >= 0 using index i_s) x;
drop index i_s on s;

-- k: two rows to a key, in two cases. The optimizer reads a range of a utf8_en_ci column from the heap; the ORDER BY
-- with a LIMIT makes it read the index, in its order, which orderby_num numbers
set system parameters 'index_build_parallel_leaf=yes';
create index i_s on s (k);
insert into sig select 'k', 'on', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select orderby_num () as r, id from s where k >= '' using index i_s order by k limit 1000000000) x;
drop index i_s on s;
set system parameters 'index_build_parallel_leaf=no';
create index i_s on s (k);
insert into sig select 'k', 'off', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select orderby_num () as r, id from s where k >= '' using index i_s order by k limit 1000000000) x;
drop index i_s on s;

-- unique: on id it builds, on k it fails with the violation and leaves no index
set system parameters 'index_build_parallel_leaf=yes';
create unique index u_s on s (id);
insert into sig select 'unique id', 'on', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where id >= 0 using index u_s) x;
drop index u_s on s;
create unique index u_s on s (k);
set system parameters 'index_build_parallel_leaf=no';
create unique index u_s on s (id);
insert into sig select 'unique id', 'off', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from s where id >= 0 using index u_s) x;
drop index u_s on s;
create unique index u_s on s (k);
set system parameters 'index_build_parallel_leaf=DEFAULT';
select count (*) from db_index where class_name = 's';

-- each tag: 2 builds, 1 sum; 150000 rows, 135000 for n
select tag, count (*) as builds, count (distinct sg) as sums, min (cnt), max (cnt) from sig group by tag order by tag;

drop table s;
drop table sig;

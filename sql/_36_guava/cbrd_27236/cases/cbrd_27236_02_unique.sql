-- CBRD-27236: a unique violation between two runs is caught by the last pass of a merge of more than 4 runs
--
-- u holds 150000 rows whose k is unique but for the first and the last row, which share k = 1. The two rows lie
-- at the two ends of the heap, so they go to different runs and meet only in the last pass of the merge, the
-- one that builds the leaves. A build sorts 256K (fan-in 8: 25 runs to 4, then 4), 512K (fan-in 16: 12 runs in
-- one pass) or 256K with index_build_merge_fanin 3 (25 runs to 9, to 3, then 3), and each must fail with the
-- unique violation and leave no index. With the last row changed to a k of its own, the same builds succeed
-- and read back every row in the order of the 16M build, which sorts the rows in memory with no merge. A pad
-- of 100 characters keeps the heap at 23 sectors: a sort makes no more run files than its heap holds data
-- sectors, and two INTs alone would leave 6, below the 8 and 16 of the buffers.

drop table if exists u;
drop table if exists sig;

create table u (id int not null, k int, p char(100));
insert into u select n, n, 'p' from (select rownum as n from db_class a, db_class b, db_class c limit 150000) x;
update u set k = 1 where id = 150000;

create table sig (tag varchar(10), cfg varchar(20), cnt int, sg bigint);

-- the shared k makes every build fail
set system parameters 'index_build_buffer_size=256K';
create unique index u_k on u (k);
alter table u add constraint pk_u primary key (k);
set system parameters 'index_build_buffer_size=512K';
create unique index u_k on u (k);
set system parameters 'index_build_buffer_size=256K';
set system parameters 'index_build_merge_fanin=3';
create unique index u_k on u (k);
set system parameters 'index_build_merge_fanin=DEFAULT';
select count (*) from db_index where class_name = 'u';

-- positive control: the last row gets a k of its own
update u set k = 150000 where id = 150000;
set system parameters 'index_build_buffer_size=16M';
create unique index u_k on u (k);
insert into sig select 'k', 'one run', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from u where k >= 0 using index u_k) x;
drop index u_k on u;
set system parameters 'index_build_buffer_size=256K';
create unique index u_k on u (k);
insert into sig select 'k', '256K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from u where k >= 0 using index u_k) x;
drop index u_k on u;
alter table u add constraint pk_u primary key (k);
insert into sig select 'k', '256K pk', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from u where k >= 0 using index pk_u) x;
alter table u drop primary key;
set system parameters 'index_build_buffer_size=512K';
create unique index u_k on u (k);
insert into sig select 'k', '512K', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from u where k >= 0 using index u_k) x;
drop index u_k on u;
set system parameters 'index_build_buffer_size=256K';
set system parameters 'index_build_merge_fanin=3';
create unique index u_k on u (k);
insert into sig select 'k', '256K cap 3', count (*), sum (mod (cast (r as bigint) * id, 1000003)) from (select rownum as r, id from u where k >= 0 using index u_k) x;
drop index u_k on u;
set system parameters 'index_build_merge_fanin=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- every build holds the same rows in the same order: 1 sum, 150000 rows
select tag, count (*) as builds, count (distinct sg) as sums, min (cnt), max (cnt) from sig group by tag order by tag;

drop table u;
drop table sig;

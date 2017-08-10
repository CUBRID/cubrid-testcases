-- setup
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

-- create tables
create table ai (j int, k int, l int, s int);
create table a (i int, j int, k int, l int, s int);

-- populate iss generator table
insert into ai values (null, null, null, null);
insert into ai values (1, 1, 1, 1);
insert into ai values (2, 2, 2, 2);
insert into ai values (3, 3, 3, 3);
insert into ai values (4, 4, 4, 4);
insert into ai select j + 4, k + 4, l + 4, s + 4 from ai;
insert into ai select j + 8, k + 8, l + 8, s + 8 from ai;
insert into ai select j + 16, k + 16, l + 16, s + 16 from ai;
insert into ai select j + 32, k + 32, l + 32, s + 32 from ai;
insert into ai select j + 64, k + 64, l + 64, s + 64 from ai;
insert into ai select j + 128, k + 128, l + 128, s + 128 from ai;
insert into ai select j + 256, k + 256, l + 256, s + 256 from ai;
insert into ai select j + 512, k + 512, l + 512, s + 512 from ai;
insert into ai values (null, null, null, null);

-- populate a and b
insert into a select null, j, k, l, s from ai;
insert into a select 1, j, k, l, s from ai;
insert into a select 2, j, k, l, s from ai;
insert into a select null, j, k, l, s from ai;

-- ascending index
create index i_a_i_j_k on a (i, j, k);
update statistics on all classes;

-- nulls tests
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 and k > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 and k > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 and k > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 and k > 1023 order by i desc;

-- descending index
drop index i_a_i_j_k on a (i, j, k);
create index idx50 on a (i desc, j desc, k desc);
update statistics on all classes;

-- nulls tests
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 and k > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k from a where j > 1023 and k > 1023 order by i desc;

select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 and k > 1023 order by i asc;
select /*+ recompile INDEX_SS */ i, j, k, l from a where j > 1023 and k > 1023 order by i desc;

-- cleanup
drop table ai, a;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

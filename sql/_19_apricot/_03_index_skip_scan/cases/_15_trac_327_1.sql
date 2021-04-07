-- setup
--+ holdcas on;

-- create tables
create table ai (j int, k int, l int, s int);
create table a (i int, j int, k int, l int, s int);
create table b (i int, j int, k int, l int, s int);

-- populate iss generator table
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

-- populate a and b
insert into a select 1, j, k, l, s from ai;
insert into a select 2, j, k, l, s from ai;
insert into b select 1, j, k, l, s from ai;
insert into b select 2, j, k, l, s from ai;


-- ascending index
create index i_a_i_j_k_l on a (i, j, k, l);
update statistics on all classes;

-- iss, range
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i, a.j, a.s, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i desc, a.j desc, a.s desc, b.k desc;

select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i, a.j, a.s, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i desc, a.j desc, a.s desc, b.k desc;

-- iss, covering, range
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i, a.j, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i desc, a.j desc, b.k desc;

select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i, a.j, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i desc, a.j desc, b.k desc;

-- iss, range, key filter
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i, a.j, a.s, b.k;

select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i desc, a.j desc, a.s desc, b.k desc;

-- iss, covering, range, key filter
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i, a.j, b.k;

select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i desc, a.j desc, b.k desc;


-- descending index
drop index i_a_i_j_k_l on a (i, j, k, l);
create index i_a_i_d_j_d_k_d_l_d  on a (i desc, j desc, k desc, l desc);
update statistics on all classes;

-- iss, range
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i, a.j, a.s, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i desc, a.j desc, a.s desc, b.k desc;

select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i, a.j, a.s, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i desc, a.j desc, a.s desc, b.k desc;

-- iss, covering, range
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i, a.j, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1022 and b.k > 1022 order by a.i desc, a.j desc, b.k desc;

select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i, a.j, b.k;
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.k > 1022 and b.k > 1023 order by a.i desc, a.j desc, b.k desc;

-- iss, range, key filter
select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i, a.j, a.s, b.k;

select /*+ recompile INDEX_SS */ a.i, a.j, a.s, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i desc, a.j desc, a.s desc, b.k desc;

-- iss, covering, range, key filter
select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i, a.j, b.k;

select /*+ recompile INDEX_SS */ a.i, a.j, b.k from b, a where a.j > 1020 and a.l > 1022 and b.k > 1023 order by a.i desc, a.j desc, b.k desc;

-- cleanup
drop table ai, a, b;
commit;
--+ holdcas off;

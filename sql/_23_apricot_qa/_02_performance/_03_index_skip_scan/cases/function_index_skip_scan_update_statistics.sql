--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table a (i int auto_increment);
insert into a (i) values(NULL);
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;

create table t (i char(255), j int, k int, s string);
create index idx on t(i,j,k);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select 1, i, i, i from a;
insert into t(i,j,k, s) select 2, i, i, i from a;
insert into t(i,j,k, s) select 3, i, i, i from a;
insert into t(i,j,k, s) select 4, i, i, i from a;
insert into t(i,j,k, s) select 5, i, i, i from a;

select /*+ recompile INDEX_SS */ i, j from t where j = '2'order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1'order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' or j = 3 order by i desc;


update statistics on all classes;

--Test ISS
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1'order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by 1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' or j = 3 order by i desc;

--Test ISS
select /*+ recompile  */ i, j from t where j is NULL and k = '3'order by i;
--Test
select /*+ recompile  */ i, j from t where j <=> NULL and k = '2' order by i;
--Test
select /*+ recompile  */ i, j from t where k = 3 order by i, j;

drop table t;

drop table a;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

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

create table t (i date, j int, k varchar, s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-02', i, i, i from a;
insert into t(i,j,k, s) select '2011-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-11', i, i, i from a;
insert into t(i,j,k, s) select '2015-01-01', i, i, i from a;
insert into t(i,j,k, s) values('2015-01-03', 1,1,1);

create index idx on t(i,j,k) where i<date'2015-01-03';

update statistics on all classes;

--Test ISS
select /*+ recompile */ i, j from t where j = '2'order by i;
--Test
select /*+ recompile */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile */ i, j from t where j <= '1'order by i;
--Test
select /*+ recompile */ i, j from t where j <= '1' or j = 3 order by i,j;
--Test
select /*+ recompile */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile */ i, j from t where j <= '1' or j = 3 order by i,j;
--Test
select /*+ recompile */ i, j from t where j < '2' order by i desc;
--Test
select /*+ recompile */ i, j from t where j < '2' or j = 3 order by i desc,j;

--Test no ISS
select /*+ recompile */ i, j from t where j is NULL and k = '3'order by i;
--Test
select /*+ recompile */ i, j from t where j <=> NULL and k = '2' order by i;
--Test
select /*+ recompile */ i, j from t where k = 3 order by i, j;

drop index idx on t;
create index idx on t(i,j,k) where i=date'2015-01-03';
--Test no ISS

select /*+ recompile */ i, j from t where j = '2'order by i;
--Test
select /*+ recompile */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile */ i, j from t where j <= '1'order by i;
--Test
select /*+ recompile */ i, j from t where j <= '1' or j = 3 order by i,j;
--Test
select /*+ recompile */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile */ i, j from t where j <= '1' or j = 3 order by i,j;
--Test
select /*+ recompile */ i, j from t where j < '2' order by i desc;
--Test
select /*+ recompile */ i, j from t where j < '2' or j = 3 order by i desc,j;
select /*+ recompile */ i, j from t where j is NULL and k = '3'order by i;
--Test
select /*+ recompile */ i, j from t where j <=> NULL and k = '2' order by i;
--Test
select /*+ recompile */ i, j from t where k = 3 order by i, j;
drop table t;

drop table a;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

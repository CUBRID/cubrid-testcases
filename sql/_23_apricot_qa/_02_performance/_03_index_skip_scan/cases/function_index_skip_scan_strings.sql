--+ holdcas on;
--create a table with a large number of incremental values
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

create table t (i varchar(255), j int, k int, s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select 1, i, i, i from a;
insert into t(i,j,k, s) select 2, i, i, i from a;
insert into t(i,j,k, s) select 3, i, i, i from a;
insert into t(i,j,k, s) select 4, i, i, i from a;
insert into t(i,j,k, s) select 5, i, i, i from a;

create index idx on t(i,j,k);

update statistics on all classes;

--Test ISS
select /*+ recompile INDEX_SS */ i, j from t where j = '2'order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1'order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < '2' or j = 3 order by i desc;

--Test ISS
select /*+ recompile INDEX_SS */ i, j from t where j is NULL and k = '3'order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <=> NULL and k = '2' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where k = 3 order by i, j;

drop table t;

--Test should not use ISS
create table t (i int, j int, k int, s string);

insert into t(i,j,k, s) select i, i, i, i from a;

create index idx on t(i,j,k);

update statistics on all classes;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;

drop table t;

create table t (i varchar(255), j varchar(255), k varchar(255), s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select 1, i, i, i from a;
insert into t(i,j,k, s) select 2, i, i, i from a;
insert into t(i,j,k, s) select 3, i, i, i from a;
insert into t(i,j,k, s) select 4, i, i, i from a;
insert into t(i,j,k, s) select 5, i, i, i from a;

create index idx on t(i,j,k);

update statistics on all classes;

--TestISS
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i desc;

--Test no ISS
select /*+ recompile INDEX_SS */ i, j from t where j is NULL and k = '3' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <=> NULL and k = '2' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where k = 3 order by i, j;

drop table t;

create table t (i varchar(255), j date, k varchar(255), s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, date'1900-01-01' + i, i, i from a;
insert into t(i,j,k, s) select 1, date'2000-01-01', i, i from a;
insert into t(i,j,k, s) select 2, date'2100-01-01', i, i from a;
insert into t(i,j,k, s) select 3, date'2200-01-01', i, i from a;
insert into t(i,j,k, s) select 4, date'2300-01-01', i, i from a;
insert into t(i,j,k, s) select 5, date'2400-01-01', i, i from a;

create index idx on t(i,j,k);

update statistics on all classes;

--Test ISS
select /*+ recompile INDEX_SS */ i, j from t where j = date'1900-01-01' + 2 order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j = date'1900-01-01' + 2 order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3 order by  1;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3 order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 order by i desc;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3 order by i desc;

--Test no ISS
select /*+ recompile INDEX_SS */ i, j from t where j is NULL and k = '3' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where j <=> NULL and k = '3' order by i;
--Test
select /*+ recompile INDEX_SS */ i, j from t where k = 3 order by i, j;

drop table t;

drop table a;
commit;
--+ holdcas off;

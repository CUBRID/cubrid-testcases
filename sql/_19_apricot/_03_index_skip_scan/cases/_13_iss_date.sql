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

create table t (i date, j int, k varchar, s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-02', i, i, i from a;
insert into t(i,j,k, s) select '2011-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-11', i, i, i from a;
insert into t(i,j,k, s) select '2015-01-01', i, i, i from a;

create index i_t_i_j_k on t(i,j,k);

update statistics on all classes;

-- ISS
select /*+ recompile INDEX_SS */ i, j from t where j = '2';

select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1';

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;

select /*+ recompile INDEX_SS */ i, j from t where j < '2' order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j < '2' or j = 3 order by i desc;

--no ISS
select /*+ recompile  */ i, j from t where j is NULL and k = '3'order by i;

select /*+ recompile  */ i, j from t where j <=> NULL and k = '2' order by i;

select /*+ recompile  */ i, j from t where k = 3 order by i, j;

drop table t;

--should not use ISS
create table t (i int, j int, k int, s string);

insert into t(i,j,k, s) select i, i, i, i from a;

create index i_t_i_j_k on t(i,j,k);

update statistics on all classes;

select /*+ recompile */ i, j from t where j = '2' order by i;

select /*+ recompile */ i, j from t where j = '2' order by i desc;

select /*+ recompile */ i, j from t where j <= '1' order by i desc;

select /*+ recompile */ i, j from t where j <= '1' order by i;

drop table t;

create table t (i date, j varchar(255), k varchar(255), s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-02', i, i, i from a;
insert into t(i,j,k, s) select '2011-01-01', i, i, i from a;
insert into t(i,j,k, s) select '2010-01-11', i, i, i from a;
insert into t(i,j,k, s) select '2015-01-01', i, i, i from a;

create index i_t_i_j_k on t(i,j,k);

update statistics on all classes;

-- ISS
select /*+ recompile INDEX_SS */ i, j from t where j = '2';

select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1';

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j <= '1' or j = 3 order by i desc;

--no ISS
select /*+ recompile  */ i, j from t where j is NULL and k = '3' order by i;

select /*+ recompile */ i, j from t where j <=> NULL and k = '2' order by i;

select /*+ recompile  */ i, j from t where k = 3 order by i, j;

drop table t;

create table t (i datetime, j date, k varchar(255), s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, date'1900-01-01' + i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01 12:00:01 ', date'2000-01-01' + i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01 12:00:02', date'2100-01-01' + i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01 12:00:03', date'2200-01-01' + i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01 12:00:04', date'2300-01-01' + i, i, i from a;
insert into t(i,j,k, s) select '2010-01-01 12:00:05', date'2400-01-01' + i, i, i from a;

create index i_t_i_j_k on t(i,j,k);

update statistics on all classes;

-- ISS
select /*+ recompile INDEX_SS */ i, j from t where j = date'1900-01-01' + 2;

select /*+ recompile INDEX_SS */ i, j from t where j = date'1900-01-01' + 2 order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 order by i;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3 order by i;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 order by i desc;

select /*+ recompile INDEX_SS */ i, j from t where j < date'1900-01-01' + 2 or j = date'1900-01-01' + 3 order by i desc;

--no ISS
select /*+ recompile  */ i, j from t where j is NULL and k = '3' order by i;

select /*+ recompile  */ i, j from t where j <=> NULL and k = '3' order by i;

select /*+ recompile  */ i, j from t where k = 3 order by i, j;

drop table t;

drop table a;

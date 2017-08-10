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
create index i_t_i_j_k on t(i,j,k) ;

update statistics on a, t;
select /*+ recompile  INDEX_SS */ i, j from t where j = '2'order by i;
drop a;
drop t;


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
create index i_t_i_j_k on t(i,j,k) ;

update statistics on a, t;
--Test : we expect ISS will be used
select /*+ recompile INDEX_SS */ * from t where j = '2'order by i;
drop table t;
drop table a;
commit;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

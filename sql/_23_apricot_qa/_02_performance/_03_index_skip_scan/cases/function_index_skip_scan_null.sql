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
insert into t(i,j,k, s) value('2010-01-01',1,1,1);
create index idx on t(i,j,k) ;

update statistics on all classes;
--Test : we expect ISS will be used
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i;
drop table t;
create table t (i date, j int, k varchar, s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
create index idx on t(i,j,k) ;
update statistics on all classes;

--Test : we expect ISS will be used
select /*+ recompile INDEX_SS */ i, j from t where j = '2' using index idx(+) order by i;
select /*+ recompile INDEX_SS */ i, j from t where j = '2' order by i;
drop table t;
drop table a;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;


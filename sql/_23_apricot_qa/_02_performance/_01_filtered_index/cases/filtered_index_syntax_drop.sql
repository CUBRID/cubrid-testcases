--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t(d int);
--test
create index idx on t(d) where d>0;
--test
drop index on t(d);
--test
create index idx on t(d) where d>0;
--test
drop index on t(d) where d>0;

--test
create index idx on t(d) where d>0;
--test
drop index idx on t(d);
--test
create index idx on t(d) where d>0;
--test
drop index idx on t(d) where d>0;
drop index idx on t(d);
drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

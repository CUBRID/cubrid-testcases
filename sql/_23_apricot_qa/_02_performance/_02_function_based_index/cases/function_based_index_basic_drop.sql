--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t(d double);
--test
create index idx on t(ceil(d));
--test
drop index idx on t(ceil(d));
create index idx on t(ceil(d));
--test
drop index idx on t;
drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

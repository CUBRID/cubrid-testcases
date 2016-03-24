--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (i int, d double);
create unique index idx on t1 (i,sqrt(d));
--test insert fail
insert into t1 value(1,-1);
--test insert successfully
insert into t1 value(1,1);
insert into t1 value(1,2);
insert into t1 value(2,1);
--test insert fail
insert into t1 value(1,1);
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

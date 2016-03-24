--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(a int)
PARTITION BY RANGE (a)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));
create index i_a on t1(a);

insert into t1 values (null);
insert into t1 values (7);
insert into t1 values (9);
insert into t1 values (8);
insert into t1 values (17);
insert into t1 values (19);
insert into t1 values (18);

select /*+ recompile use_desc_idx */ * from t1 where a>0 order by 1;

drop table t1;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

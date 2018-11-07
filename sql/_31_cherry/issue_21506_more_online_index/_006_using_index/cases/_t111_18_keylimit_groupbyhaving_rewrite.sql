--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(a int not null, b int, c int);
insert into t1 values (2, 2, 2);
insert into t1 values (1, 2, 2);
insert into t1 values (1, 2, 1);
insert into t1 values (1, 1, 2);
insert into t1 values (1, 1, 1);
insert into t1 values (1, 1, null);
insert into t1 values (1, null, 1);
insert into t1 values (1, null, null);

create index i_abc on t1(a,b,c) with online;

select /*+ recompile */ a, count(*), sum(b), sum(c) from t1 group by a asc using index i_abc keylimit 2,10;
select /*+ recompile */ a, count(*), sum(b), sum(c) from t1 group by a asc having a>1 using index i_abc keylimit 2,10;

drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

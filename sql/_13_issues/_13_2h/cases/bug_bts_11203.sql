--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;
create table t (i int, j int, k int, l int);
insert into t values (0,0,0,0), (0,0,1,1), (0,1,0,2), (0,1,1,3), (1,0,0,4), (1,0,1,5), (1,1,0,6), (1,1,1,7), (null, 0, 0, 8), (null, 1, 1, 9), (0, null, 0, 10), (1, null, 1, 11), (0, 0, null, 12), (1, 1, null, 13), (null, null, null, 14);
select * from t where i in (select k from t order by k desc limit 1) order by l;;

drop table if exists t;

set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
commit;


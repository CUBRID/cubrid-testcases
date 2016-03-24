--
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));
insert into t1 values (1, 1), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5);
create index idx1 on t1(e1);
update statistics on t1;

create table t2(i int, s string);
insert into t2 select * from t1;
insert into t2 values (10, 'kkk');
insert into t2 values (4, 'kkk');
insert into t2 values (10, 'Monday');

select /*+ recompile */ * from t1, t2 where t1.e1 < t2.s order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 < t2.i order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 <= t2.s order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 <= t2.i order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 > t2.s order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 > t2.i order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 >= t2.s order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 >= t2.i order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 in (t2.i, t2.s) order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 in (1, t2.s, 'Friday') order by 1, 2, 3, 4;
select /*+ recompile */ * from t1, t2 where t1.e1 =t2.s order by 1, 2, 3, 4;
select /*+ recompile */ e1 from t1 where e1 in (select s from t2) order by i;
select /*+ recompile */ e1 from t1 where e1 in (select s from t2 where t2.s = 'Saturday') order by i;
select /*+ recompile */ e1 from t1 where e1 in (select s from t2 where t2.s = 'Saturday' union select s from t2 where t2.s <> 'Saturday') order by i;
select /*+ recompile */ e1 from t1 where not e1 in (select s from t2) order by i;
select /*+ recompile */ e1 from t1 where not e1 in (select s from t2 where t2.s = 'Saturday') order by i;
select /*+ recompile */ e1 from t1 where not e1 in (select s from t2 where t2.s = 'Saturday' union select s from t2 where t2.s <> 'Saturday') order by i;

drop table t1;
drop table t2;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

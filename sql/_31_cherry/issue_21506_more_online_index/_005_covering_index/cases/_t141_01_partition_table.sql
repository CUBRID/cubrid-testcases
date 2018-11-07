--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t( i int, a varchar(10))
PARTITION BY RANGE (i)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));

create table s( i int, a varchar(10))
PARTITION BY RANGE (i)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));

create index i_t_a  on t(a,i) with online;
create index i_s_a  on s(a,i) with online;

insert into t values (1,'t-1');
insert into t values (9,'t-9');
insert into t values (11,'t-11');
insert into t values (19,'t-19');

insert into s values (1,'t-1');
insert into s values (9,'t-9');
insert into s values (11,'t-11');
insert into s values (19,'t-19');


select /*+ recompile ordered */ * from t,s where t.i=s.i order by t.i;

select /*+ recompile ordered */ t.a,s.a  from t,s where t.a=s.a and t.a>'t-1' order by t.a;

drop table t;
drop table s;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

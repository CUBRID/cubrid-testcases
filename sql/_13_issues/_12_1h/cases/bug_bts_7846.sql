--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;
create table t(i int primary key, e enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'));
create index t_1 on t(e);
set optimization level 513;
select * from t where e between 'Tuesday' and 'Wednesday';
drop t;

create table t(i int primary key, e enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'));
create index t_1 on t(e,i);
set optimization level 513;
select * from t where e between 'Tuesday' and 'Wednesday';

drop t;
create table t(i  enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), e enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'));
create index t_1 on t(i);
create index t_2 on t(e);
create index t_3 on t(i,e);
select * from t where e between 'Tuesday' and 'Wednesday';
drop t;

create table t(i int auto_increment, e enum ('11', '22', '33', '44', '55', '66', '77'), s varchar(2555));

insert into t(i) values(null);
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;

update t set e = (i % 7) + 1;
update t set s = e;

create index  t_1 on t(i);
create index  t_2 on t(i, e);
create index t_3 on t(i, e, s);
create index t_4 on t(e, s);
create index t_5 on t(e, i);
create index t_6 on t(e);

update statistics on t;

select /*+ recompile */ e from t where e < 2 order by 1 ;

select /*+ recompile */ i, e from t where i = 2 and e < 3 order by 1;

select /*+ recompile */ i, e from t where i = 2 and e < 'Wednesday' order by 1;

select /*+ recompile */ e from t where e between 'Tuesday' and 'Saturday' order by 1;

select /*+ recompile */ i, e from t where e = 3 and s < 'x' order by 1;

select /*+ recompile */ i, e from t where e = 'Wednesday' and s < 'x' order by 1;

select /*+ recompile */ e from t where e < 10 order by 1;

select /*+ recompile */ e from t where e in ('Tuesday', 'Thursday') order by 1;

select i, e, s from t where i < 10 order by i, e, s;
drop t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

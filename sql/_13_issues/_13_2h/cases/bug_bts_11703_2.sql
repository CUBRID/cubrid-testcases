--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t; 

create table t(i int);

create table u(i int);

insert into t select rownum from _db_class limit 40;
insert into u select rownum from _db_class limit 40;

update statistics on all classes;

select /*+ recompile, use_merge */ t .i from t left join u on t.i = u.i order by t.i limit 5;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i limit 1, 5;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i limit 5 offset 1;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num () between 2 and 6;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num () between 6 and 2;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() >= 2 and orderby_num() <= 6;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() >= 6 and orderby_num() <= 2;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() = 2;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() + 1 between 2 and 6;

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() in {2, 3, 9, 8};

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() < cast (10 as bigint);

select /*+ recompile, use_merge */ t.i from t left join u on t.i = u.i order by t.i  for orderby_num() = some {1, 4, 5};

drop t;
drop u;

set system parameters 'dont_reuse_heap_file=no';
autocommit on

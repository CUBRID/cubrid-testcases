--+ holdcas on;

create table t_basic001(i1 integer, i2 integer, i3 integer);
create index basic001_idx_one on t_basic001(i1);
create index basic001_idx_two on t_basic001(i2);
create index basic001_idx_one_two on t_basic001(i1, i2);
create index basic001_idx_two_three on t_basic001(i2, i3);
create index basic001_idx_one_three on t_basic001(i1, i3);
create index basic001_idx_all on t_basic001(i1, i2, i3);

insert into t_basic001 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t_basic001 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t_basic001;

select /*+ recompile */ i1 from t_basic001 where i1 < 4 order by 1;
select /*+ recompile */ * from t_basic001 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one_two) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one_three) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_all) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_two) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_two_three) where i1 < 4 order by 1;

select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one, basic001_idx_two) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one, basic001_idx_one_two) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one, basic001_idx_one_three) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one, basic001_idx_all) where i1 < 4 order by 1;
select /*+ recompile */ i1 from t_basic001 use index (basic001_idx_one, basic001_idx_two_three) where i1 < 4 order by 1;

select /*+ recompile */ i1 from t_basic001 where i1 < 4 using index none order by 1;

drop index basic001_idx_one on t_basic001;
drop index basic001_idx_two on t_basic001;
drop index basic001_idx_one_two on t_basic001;
drop index basic001_idx_one_three on t_basic001;
drop index basic001_idx_two_three on t_basic001;
drop index basic001_idx_all on t_basic001;
drop table t_basic001;

commit;
--+ holdcas off;

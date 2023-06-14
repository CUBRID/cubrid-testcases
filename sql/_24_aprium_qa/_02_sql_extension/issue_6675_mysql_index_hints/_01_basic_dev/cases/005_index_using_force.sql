set system parameters 'deduplicate_key_level=0';

--+ holdcas on;

create table t_basic005(i1 integer, i2 integer, i3 integer);
create index basic005_idx_one on t_basic005(i1);
create index basic005_idx_two on t_basic005(i2);
create index basic005_idx_one_two on t_basic005(i1, i2);
create index basic005_idx_two_three on t_basic005(i2, i3);
create index basic005_idx_one_three on t_basic005(i1, i3);
create index basic005_idx_all on t_basic005(i1, i2, i3);

insert into t_basic005 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t_basic005 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t_basic005;

select /*+ recompile */ i1 from t_basic005 where i1 < 4 order by 1;
select /*+ recompile */ * from t_basic005 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_all(+) order by 1;

select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_two(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_two_three(+) order by 1;


select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+), basic005_idx_two(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+), basic005_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+), basic005_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+), basic005_idx_all(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1 < 4 using index basic005_idx_one(+), basic005_idx_two_three(+) order by 1;

select /*+ recompile */ i1 from t_basic005 where i1<4 using index basic005_idx_one, basic005_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1<4 using index basic005_idx_one_two, basic005_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t_basic005 where i1<4 using index basic005_idx_one_three(+), basic005_idx_one_two order by 1;
select /*+ recompile */ i1 from t_basic005 where i1<4 using index basic005_idx_one_two, basic005_idx_all(+) order by 1;

drop index basic005_idx_one on t_basic005;
drop index basic005_idx_two on t_basic005;
drop index basic005_idx_one_two on t_basic005;
drop index basic005_idx_one_three on t_basic005;
drop index basic005_idx_two_three on t_basic005;
drop index basic005_idx_all on t_basic005;
drop table t_basic005;

commit;
--+ holdcas off;

set system parameters 'deduplicate_key_level=32';

--+ holdcas on;

create table t21(i1 integer, i2 integer, i3 integer);
create index t21_idx_one on t21(i1);
create index t21_idx_two on t21(i2);
create index t21_idx_one_two on t21(i1, i2);
create index t21_idx_two_three on t21(i2, i3);
create index t21_idx_one_three on t21(i1, i3);
create index t21_idx_all on t21(i1, i2, i3);

insert into t21 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t21 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t21;

select /*+ recompile */ i1 from t21 where i1 < 4 order by 1;
select /*+ recompile */ * from t21 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t21 use index (t21_idx_one) where i1 < 4 using index t21_idx_one(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one_two) where i1 < 4 using index t21_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one_three) where i1 < 4 using index t21_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_all) where i1 < 4 using index t21_idx_all(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_two) where i1 < 4 using index t21_idx_two(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_two_three) where i1 < 4 using index t21_idx_two_three(+) order by 1;

select /*+ recompile */ i1 from t21 use index (t21_idx_one, t21_idx_two) where i1 < 4 using index t21_idx_one(+), t21_idx_two(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one, t21_idx_one_two) where i1 < 4 using index t21_idx_one(+), t21_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one, t21_idx_one_three) where i1 < 4 using index t21_idx_one(+), t21_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one, t21_idx_all) where i1 < 4 using index t21_idx_one(+), t21_idx_all(+) order by 1;
select /*+ recompile */ i1 from t21 use index (t21_idx_one, t21_idx_two_three) where i1 < 4 using index t21_idx_one(+), t21_idx_two_three(+) order by 1;

drop index t21_idx_one on t21;
drop index t21_idx_two on t21;
drop index t21_idx_one_two on t21;
drop index t21_idx_one_three on t21;
drop index t21_idx_two_three on t21;
drop index t21_idx_all on t21;
drop table t21;

commit;
--+ holdcas off;

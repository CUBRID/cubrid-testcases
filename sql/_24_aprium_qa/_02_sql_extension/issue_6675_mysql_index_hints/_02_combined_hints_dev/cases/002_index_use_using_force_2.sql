--+ holdcas on;

create table t22(i1 integer, i2 integer, i3 integer);
create index t22_idx_one on t22(i1);
create index t22_idx_two on t22(i2);
create index t22_idx_one_two on t22(i1, i2);
create index t22_idx_two_three on t22(i2, i3);
create index t22_idx_one_three on t22(i1, i3);
create index t22_idx_all on t22(i1, i2, i3);

insert into t22 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t22 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t22;

select /*+ recompile */ i1 from t22 where i1 < 4;
select /*+ recompile */ * from t22 where i1 < 4;

select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_two(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_all(+);

select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two(+), t22_idx_one_two(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two(+), t22_idx_two_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two(+), t22_idx_one_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two(+), t22_idx_all(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_two(+), t22_idx_two_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_two(+), t22_idx_one_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_two(+), t22_idx_all(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two_three(+), t22_idx_one_three(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_two_three(+), t22_idx_all(+);
select /*+ recompile */ i1 from t22 use index (t22_idx_one) where i1 < 4 using index t22_idx_one_three(+), t22_idx_all(+);


drop index t22_idx_one on t22;
drop index t22_idx_two on t22;
drop index t22_idx_one_two on t22;
drop index t22_idx_one_three on t22;
drop index t22_idx_two_three on t22;
drop index t22_idx_all on t22;
drop table t22;

commit;
--+ holdcas off;

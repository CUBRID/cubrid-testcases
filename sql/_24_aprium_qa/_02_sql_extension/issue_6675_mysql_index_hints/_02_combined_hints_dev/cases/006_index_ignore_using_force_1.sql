--+ holdcas on;

create table t61(i1 integer, i2 integer, i3 integer);
create index t61_idx_one on t61(i1);
create index t61_idx_two on t61(i2);
create index t61_idx_one_two on t61(i1, i2);
create index t61_idx_two_three on t61(i2, i3);
create index t61_idx_one_three on t61(i1, i3);
create index t61_idx_all on t61(i1, i2, i3);

insert into t61 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t61 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t61;

select /*+ recompile */ i1 from t61 where i1 < 4;
select /*+ recompile */ * from t61 where i1 < 4;

select /*+ recompile */ i1 from t61 ignore index (t61_idx_one) where i1 < 4 using index t61_idx_one(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one_two) where i1 < 4 using index t61_idx_one_two(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one_three) where i1 < 4 using index t61_idx_one_three(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_all) where i1 < 4 using index t61_idx_all(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_two) where i1 < 4 using index t61_idx_two(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_two_three) where i1 < 4 using index t61_idx_two_three(+);

select /*+ recompile */ i1 from t61 ignore index (t61_idx_one, t61_idx_two) where i1 < 4 using index t61_idx_one(+), t61_idx_two(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one, t61_idx_one_two) where i1 < 4 using index t61_idx_one(+), t61_idx_one_two(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one, t61_idx_one_three) where i1 < 4 using index t61_idx_one(+), t61_idx_one_three(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one, t61_idx_all) where i1 < 4 using index t61_idx_one(+), t61_idx_all(+);
select /*+ recompile */ i1 from t61 ignore index (t61_idx_one, t61_idx_two_three) where i1 < 4 using index t61_idx_one(+), t61_idx_two_three(+);

drop index t61_idx_one on t61;
drop index t61_idx_two on t61;
drop index t61_idx_one_two on t61;
drop index t61_idx_one_three on t61;
drop index t61_idx_two_three on t61;
drop index t61_idx_all on t61;
drop table t61;

commit;
--+ holdcas off;

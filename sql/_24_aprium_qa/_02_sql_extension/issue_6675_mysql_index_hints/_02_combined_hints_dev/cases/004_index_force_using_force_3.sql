--+ holdcas on;

create table t43(i1 integer, i2 integer, i3 integer);
create index t43_idx_one on t43(i1);
create index t43_idx_two on t43(i2);
create index t43_idx_one_two on t43(i1, i2);
create index t43_idx_two_three on t43(i2, i3);
create index t43_idx_one_three on t43(i1, i3);
create index t43_idx_all on t43(i1, i2, i3);

insert into t43 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t43 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t43;

select /*+ recompile */ i1 from t43 where i1 < 4;
select /*+ recompile */ * from t43 where i1 < 4;

select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one(+), t43_idx_one_two(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one(+), t43_idx_two_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one_two(+), t43_idx_two_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one_two(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one_two(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_two_three(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_two_three(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_two) where i1 < 4 using index t43_idx_one_three(+), t43_idx_all(+);

select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_one_two(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_two_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_two_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two_three(+), t43_idx_one_three(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_two_three(+), t43_idx_all(+);
select /*+ recompile */ i1 from t43 force index (t43_idx_one_two) where i1 < 4 using index t43_idx_one_three(+), t43_idx_all(+);

drop index t43_idx_one on t43;
drop index t43_idx_two on t43;
drop index t43_idx_one_two on t43;
drop index t43_idx_one_three on t43;
drop index t43_idx_two_three on t43;
drop index t43_idx_all on t43;
drop table t43;

commit;
--+ holdcas off;

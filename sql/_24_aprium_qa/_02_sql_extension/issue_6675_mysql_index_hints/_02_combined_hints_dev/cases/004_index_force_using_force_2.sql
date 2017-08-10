--+ holdcas on;

create table t42(i1 integer, i2 integer, i3 integer);
create index t42_idx_one on t42(i1);
create index t42_idx_two on t42(i2);
create index t42_idx_one_two on t42(i1, i2);
create index t42_idx_two_three on t42(i2, i3);
create index t42_idx_one_three on t42(i1, i3);
create index t42_idx_all on t42(i1, i2, i3);

insert into t42 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t42 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t42;

select /*+ recompile */ i1 from t42 where i1 < 4;
select /*+ recompile */ * from t42 where i1 < 4;

select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_two(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_all(+);

select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two(+), t42_idx_one_two(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two(+), t42_idx_two_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two(+), t42_idx_one_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two(+), t42_idx_all(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_two(+), t42_idx_two_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_two(+), t42_idx_one_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_two(+), t42_idx_all(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two_three(+), t42_idx_one_three(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_two_three(+), t42_idx_all(+);
select /*+ recompile */ i1 from t42 force index (t42_idx_one) where i1 < 4 using index t42_idx_one_three(+), t42_idx_all(+);


drop index t42_idx_one on t42;
drop index t42_idx_two on t42;
drop index t42_idx_one_two on t42;
drop index t42_idx_one_three on t42;
drop index t42_idx_two_three on t42;
drop index t42_idx_all on t42;
drop table t42;

commit;
--+ holdcas off;

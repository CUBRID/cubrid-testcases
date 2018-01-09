--+ holdcas on;

create table t63(i1 integer, i2 integer, i3 integer);
create index t63_idx_one on t63(i1);
create index t63_idx_two on t63(i2);
create index t63_idx_one_two on t63(i1, i2);
create index t63_idx_two_three on t63(i2, i3);
create index t63_idx_one_three on t63(i1, i3);
create index t63_idx_all on t63(i1, i2, i3);

insert into t63 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t63 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t63;

select /*+ recompile */ i1 from t63 where i1 < 4 order by 1;
select /*+ recompile */ * from t63 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one(+), t63_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one(+), t63_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one_two(+), t63_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one_two(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one_two(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_two_three(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_two_three(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_two) where i1 < 4 using index t63_idx_one_three(+), t63_idx_all(+) order by 1;

select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two_three(+), t63_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_two_three(+), t63_idx_all(+) order by 1;
select /*+ recompile */ i1 from t63 ignore index (t63_idx_one_two) where i1 < 4 using index t63_idx_one_three(+), t63_idx_all(+) order by 1;

drop index t63_idx_one on t63;
drop index t63_idx_two on t63;
drop index t63_idx_one_two on t63;
drop index t63_idx_one_three on t63;
drop index t63_idx_two_three on t63;
drop index t63_idx_all on t63;
drop table t63;

commit;
--+ holdcas off;

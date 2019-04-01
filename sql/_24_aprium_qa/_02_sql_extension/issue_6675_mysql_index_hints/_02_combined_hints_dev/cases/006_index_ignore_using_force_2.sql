--+ holdcas on;

create table t62(i1 integer, i2 integer, i3 integer);
create index t62_idx_one on t62(i1);
create index t62_idx_two on t62(i2);
create index t62_idx_one_two on t62(i1, i2);
create index t62_idx_two_three on t62(i2, i3);
create index t62_idx_one_three on t62(i1, i3);
create index t62_idx_all on t62(i1, i2, i3);

insert into t62 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t62 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t62;

select /*+ recompile */ i1 from t62 where i1 < 4 order by 1;
select /*+ recompile */ * from t62 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_all(+) order by 1;

select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two(+), t62_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two(+), t62_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two(+), t62_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two(+), t62_idx_all(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_two(+), t62_idx_two_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_two(+), t62_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_two(+), t62_idx_all(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two_three(+), t62_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_two_three(+), t62_idx_all(+) order by 1;
select /*+ recompile */ i1 from t62 ignore index (t62_idx_one) where i1 < 4 using index t62_idx_one_three(+), t62_idx_all(+) order by 1;


drop index t62_idx_one on t62;
drop index t62_idx_two on t62;
drop index t62_idx_one_two on t62;
drop index t62_idx_one_three on t62;
drop index t62_idx_two_three on t62;
drop index t62_idx_all on t62;
drop table t62;

commit;
--+ holdcas off;

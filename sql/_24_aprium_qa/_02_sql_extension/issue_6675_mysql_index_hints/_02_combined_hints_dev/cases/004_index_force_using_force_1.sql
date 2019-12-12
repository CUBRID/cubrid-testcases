--+ holdcas on;

create table t41(i1 integer, i2 integer, i3 integer);
create index t41_idx_one on t41(i1);
create index t41_idx_two on t41(i2);
create index t41_idx_one_two on t41(i1, i2);
create index t41_idx_two_three on t41(i2, i3);
create index t41_idx_one_three on t41(i1, i3);
create index t41_idx_all on t41(i1, i2, i3);

insert into t41 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t41 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t41;

select /*+ recompile */ i1 from t41 where i1 < 4 order by 1;
select /*+ recompile */ * from t41 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t41 force index (t41_idx_one) where i1 < 4 using index t41_idx_one(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one_two) where i1 < 4 using index t41_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one_three) where i1 < 4 using index t41_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_all) where i1 < 4 using index t41_idx_all(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_two) where i1 < 4 using index t41_idx_two(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_two_three) where i1 < 4 using index t41_idx_two_three(+) order by 1;

select /*+ recompile */ i1 from t41 force index (t41_idx_one, t41_idx_two) where i1 < 4 using index t41_idx_one(+), t41_idx_two(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one, t41_idx_one_two) where i1 < 4 using index t41_idx_one(+), t41_idx_one_two(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one, t41_idx_one_three) where i1 < 4 using index t41_idx_one(+), t41_idx_one_three(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one, t41_idx_all) where i1 < 4 using index t41_idx_one(+), t41_idx_all(+) order by 1;
select /*+ recompile */ i1 from t41 force index (t41_idx_one, t41_idx_two_three) where i1 < 4 using index t41_idx_one(+), t41_idx_two_three(+) order by 1;

drop index t41_idx_one on t41;
drop index t41_idx_two on t41;
drop index t41_idx_one_two on t41;
drop index t41_idx_one_three on t41;
drop index t41_idx_two_three on t41;
drop index t41_idx_all on t41;
drop table t41;

commit;
--+ holdcas off;

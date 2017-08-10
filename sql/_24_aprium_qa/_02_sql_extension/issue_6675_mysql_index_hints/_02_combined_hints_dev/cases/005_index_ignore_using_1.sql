--+ holdcas on;

create table t51(i1 integer, i2 integer, i3 integer);
create index t51_idx_one on t51(i1);
create index t51_idx_two on t51(i2);
create index t51_idx_one_two on t51(i1, i2);
create index t51_idx_two_three on t51(i2, i3);
create index t51_idx_one_three on t51(i1, i3);
create index t51_idx_all on t51(i1, i2, i3);

insert into t51 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t51 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t51;

select /*+ recompile */ i1 from t51 where i1 < 4;
select /*+ recompile */ * from t51 where i1 < 4;

select /*+ recompile */ i1 from t51 ignore index (t51_idx_one) where i1 < 4 using index t51_idx_one;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one_two) where i1 < 4 using index t51_idx_one_two;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one_three) where i1 < 4 using index t51_idx_one_three;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_all) where i1 < 4 using index t51_idx_all;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_two) where i1 < 4 using index t51_idx_two;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_two_three) where i1 < 4 using index t51_idx_two_three;

select /*+ recompile */ i1 from t51 ignore index (t51_idx_one, t51_idx_two) where i1 < 4 using index t51_idx_one, t51_idx_two;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one, t51_idx_one_two) where i1 < 4 using index t51_idx_one, t51_idx_one_two;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one, t51_idx_one_three) where i1 < 4 using index t51_idx_one, t51_idx_one_three;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one, t51_idx_all) where i1 < 4 using index t51_idx_one, t51_idx_all;
select /*+ recompile */ i1 from t51 ignore index (t51_idx_one, t51_idx_two_three) where i1 < 4 using index t51_idx_one, t51_idx_two_three;

drop index t51_idx_one on t51;
drop index t51_idx_two on t51;
drop index t51_idx_one_two on t51;
drop index t51_idx_one_three on t51;
drop index t51_idx_two_three on t51;
drop index t51_idx_all on t51;
drop table t51;

commit;
--+ holdcas off;

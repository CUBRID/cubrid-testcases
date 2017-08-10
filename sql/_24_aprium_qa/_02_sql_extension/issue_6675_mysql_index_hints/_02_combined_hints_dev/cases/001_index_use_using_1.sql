--+ holdcas on;

create table t11(i1 integer, i2 integer, i3 integer);
create index t11_idx_one on t11(i1);
create index t11_idx_two on t11(i2);
create index t11_idx_one_two on t11(i1, i2);
create index t11_idx_two_three on t11(i2, i3);
create index t11_idx_one_three on t11(i1, i3);
create index t11_idx_all on t11(i1, i2, i3);

insert into t11 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t11 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t11;

select /*+ recompile */ i1 from t11 where i1 < 4;
select /*+ recompile */ * from t11 where i1 < 4;

select /*+ recompile */ i1 from t11 use index (t11_idx_one) where i1 < 4 using index t11_idx_one;
select /*+ recompile */ i1 from t11 use index (t11_idx_one_two) where i1 < 4 using index t11_idx_one_two;
select /*+ recompile */ i1 from t11 use index (t11_idx_one_three) where i1 < 4 using index t11_idx_one_three;
select /*+ recompile */ i1 from t11 use index (t11_idx_all) where i1 < 4 using index t11_idx_all;
select /*+ recompile */ i1 from t11 use index (t11_idx_two) where i1 < 4 using index t11_idx_two;
select /*+ recompile */ i1 from t11 use index (t11_idx_two_three) where i1 < 4 using index t11_idx_two_three;

select /*+ recompile */ i1 from t11 use index (t11_idx_one, t11_idx_two) where i1 < 4 using index t11_idx_one, t11_idx_two;
select /*+ recompile */ i1 from t11 use index (t11_idx_one, t11_idx_one_two) where i1 < 4 using index t11_idx_one, t11_idx_one_two;
select /*+ recompile */ i1 from t11 use index (t11_idx_one, t11_idx_one_three) where i1 < 4 using index t11_idx_one, t11_idx_one_three;
select /*+ recompile */ i1 from t11 use index (t11_idx_one, t11_idx_all) where i1 < 4 using index t11_idx_one, t11_idx_all;
select /*+ recompile */ i1 from t11 use index (t11_idx_one, t11_idx_two_three) where i1 < 4 using index t11_idx_one, t11_idx_two_three;

drop index t11_idx_one on t11;
drop index t11_idx_two on t11;
drop index t11_idx_one_two on t11;
drop index t11_idx_one_three on t11;
drop index t11_idx_two_three on t11;
drop index t11_idx_all on t11;
drop table t11;

commit;
--+ holdcas off;

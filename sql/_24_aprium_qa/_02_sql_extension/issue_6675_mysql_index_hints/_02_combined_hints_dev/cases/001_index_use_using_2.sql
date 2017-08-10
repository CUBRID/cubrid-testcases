--+ holdcas on;

create table t12(i1 integer, i2 integer, i3 integer);
create index t12_idx_one on t12(i1);
create index t12_idx_two on t12(i2);
create index t12_idx_one_two on t12(i1, i2);
create index t12_idx_two_three on t12(i2, i3);
create index t12_idx_one_three on t12(i1, i3);
create index t12_idx_all on t12(i1, i2, i3);

insert into t12 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t12 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t12;

select /*+ recompile */ i1 from t12 where i1 < 4;
select /*+ recompile */ * from t12 where i1 < 4;

select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_two;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_all;

select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two, t12_idx_one_two;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two, t12_idx_two_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two, t12_idx_one_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two, t12_idx_all;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_two, t12_idx_two_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_two, t12_idx_one_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_two, t12_idx_all;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two_three, t12_idx_one_three;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_two_three, t12_idx_all;
select /*+ recompile */ i1 from t12 use index (t12_idx_one) where i1 < 4 using index t12_idx_one_three, t12_idx_all;


drop index t12_idx_one on t12;
drop index t12_idx_two on t12;
drop index t12_idx_one_two on t12;
drop index t12_idx_one_three on t12;
drop index t12_idx_two_three on t12;
drop index t12_idx_all on t12;
drop table t12;

commit;
--+ holdcas off;

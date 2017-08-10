--+ holdcas on;

create table t32(i1 integer, i2 integer, i3 integer);
create index t32_idx_one on t32(i1);
create index t32_idx_two on t32(i2);
create index t32_idx_one_two on t32(i1, i2);
create index t32_idx_two_three on t32(i2, i3);
create index t32_idx_one_three on t32(i1, i3);
create index t32_idx_all on t32(i1, i2, i3);

insert into t32 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t32 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t32;

select /*+ recompile */ i1 from t32 where i1 < 4;
select /*+ recompile */ * from t32 where i1 < 4;

select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_two;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_all;

select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two, t32_idx_one_two;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two, t32_idx_two_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two, t32_idx_one_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two, t32_idx_all;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_two, t32_idx_two_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_two, t32_idx_one_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_two, t32_idx_all;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two_three, t32_idx_one_three;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_two_three, t32_idx_all;
select /*+ recompile */ i1 from t32 force index (t32_idx_one) where i1 < 4 using index t32_idx_one_three, t32_idx_all;

select /*+ recompile */ i1 from t32 force index (t32_idx_one_two) where i1 < 4 using index t32_idx_one, t32_idx_all;

drop index t32_idx_one on t32;
drop index t32_idx_two on t32;
drop index t32_idx_one_two on t32;
drop index t32_idx_one_three on t32;
drop index t32_idx_two_three on t32;
drop index t32_idx_all on t32;
drop table t32;

commit;
--+ holdcas off;

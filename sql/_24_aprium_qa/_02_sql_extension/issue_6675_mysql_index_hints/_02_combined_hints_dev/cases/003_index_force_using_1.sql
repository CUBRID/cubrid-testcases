--+ holdcas on;

create table t31(i1 integer, i2 integer, i3 integer);
create index t31_idx_one on t31(i1);
create index t31_idx_two on t31(i2);
create index t31_idx_one_two on t31(i1, i2);
create index t31_idx_two_three on t31(i2, i3);
create index t31_idx_one_three on t31(i1, i3);
create index t31_idx_all on t31(i1, i2, i3);

insert into t31 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t31 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t31;

select /*+ recompile */ i1 from t31 where i1 < 4 order by 1;
select /*+ recompile */ * from t31 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t31 force index (t31_idx_one) where i1 < 4 using index t31_idx_one order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one_two) where i1 < 4 using index t31_idx_one_two order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one_three) where i1 < 4 using index t31_idx_one_three order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_all) where i1 < 4 using index t31_idx_all order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_two) where i1 < 4 using index t31_idx_two order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_two_three) where i1 < 4 using index t31_idx_two_three order by 1;

select /*+ recompile */ i1 from t31 force index (t31_idx_one, t31_idx_two) where i1 < 4 using index t31_idx_one, t31_idx_two order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one, t31_idx_one_two) where i1 < 4 using index t31_idx_one, t31_idx_one_two order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one, t31_idx_one_three) where i1 < 4 using index t31_idx_one, t31_idx_one_three order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one, t31_idx_all) where i1 < 4 using index t31_idx_one, t31_idx_all order by 1;
select /*+ recompile */ i1 from t31 force index (t31_idx_one, t31_idx_two_three) where i1 < 4 using index t31_idx_one, t31_idx_two_three order by 1;

drop index t31_idx_one on t31;
drop index t31_idx_two on t31;
drop index t31_idx_one_two on t31;
drop index t31_idx_one_three on t31;
drop index t31_idx_two_three on t31;
drop index t31_idx_all on t31;
drop table t31;

commit;
--+ holdcas off;

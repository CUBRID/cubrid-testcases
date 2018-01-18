--+ holdcas on;

create table t52(i1 integer, i2 integer, i3 integer);
create index t52_idx_one on t52(i1);
create index t52_idx_two on t52(i2);
create index t52_idx_one_two on t52(i1, i2);
create index t52_idx_two_three on t52(i2, i3);
create index t52_idx_one_three on t52(i1, i3);
create index t52_idx_all on t52(i1, i2, i3);

insert into t52 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t52 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t52;

select /*+ recompile */ i1 from t52 where i1 < 4 order by 1;
select /*+ recompile */ * from t52 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_two order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_all order by 1;

select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two, t52_idx_one_two order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two, t52_idx_two_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two, t52_idx_one_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two, t52_idx_all order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_two, t52_idx_two_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_two, t52_idx_one_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_two, t52_idx_all order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two_three, t52_idx_one_three order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_two_three, t52_idx_all order by 1;
select /*+ recompile */ i1 from t52 ignore index (t52_idx_one) where i1 < 4 using index t52_idx_one_three, t52_idx_all order by 1;


drop index t52_idx_one on t52;
drop index t52_idx_two on t52;
drop index t52_idx_one_two on t52;
drop index t52_idx_one_three on t52;
drop index t52_idx_two_three on t52;
drop index t52_idx_all on t52;
drop table t52;

commit;
--+ holdcas off;

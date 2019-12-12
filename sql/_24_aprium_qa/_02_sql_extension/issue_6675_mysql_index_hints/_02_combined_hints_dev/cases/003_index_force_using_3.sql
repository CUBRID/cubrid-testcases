--+ holdcas on;

create table t33(i1 integer, i2 integer, i3 integer);
create index t33_idx_one on t33(i1);
create index t33_idx_two on t33(i2);
create index t33_idx_one_two on t33(i1, i2);
create index t33_idx_two_three on t33(i2, i3);
create index t33_idx_one_three on t33(i1, i3);
create index t33_idx_all on t33(i1, i2, i3);

insert into t33 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t33 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t33;

select /*+ recompile */ i1 from t33 where i1 < 4;
select /*+ recompile */ * from t33 where i1 < 4;

select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one, t33_idx_one_two;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one, t33_idx_two_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one_two, t33_idx_two_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one_two, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one_two, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_two_three, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_two_three, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_two) where i1 < 4 using index t33_idx_one_three, t33_idx_all;

select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_one_two;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_two_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_two_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two_three, t33_idx_one_three;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_two_three, t33_idx_all;
select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_one_three, t33_idx_all;

select /*+ recompile */ i1 from t33 force index (t33_idx_one_two) where i1 < 4 using index t33_idx_one, t33_idx_one_three;

drop index t33_idx_one on t33;
drop index t33_idx_two on t33;
drop index t33_idx_one_two on t33;
drop index t33_idx_one_three on t33;
drop index t33_idx_two_three on t33;
drop index t33_idx_all on t33;
drop table t33;

commit;
--+ holdcas off;

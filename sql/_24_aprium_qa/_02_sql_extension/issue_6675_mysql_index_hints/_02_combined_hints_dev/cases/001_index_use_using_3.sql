--+ holdcas on;

create table t13(i1 integer, i2 integer, i3 integer);
create index t13_idx_one on t13(i1);
create index t13_idx_two on t13(i2);
create index t13_idx_one_two on t13(i1, i2);
create index t13_idx_two_three on t13(i2, i3);
create index t13_idx_one_three on t13(i1, i3);
create index t13_idx_all on t13(i1, i2, i3);

insert into t13 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t13 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t13;

select /*+ recompile */ i1 from t13 where i1 < 4;
select /*+ recompile */ * from t13 where i1 < 4;

select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one, t13_idx_one_two;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one, t13_idx_two_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one_two, t13_idx_two_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one_two, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one_two, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_two_three, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_two_three, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_two) where i1 < 4 using index t13_idx_one_three, t13_idx_all;

select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_one_two;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_two_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_two_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two_three, t13_idx_one_three;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_two_three, t13_idx_all;
select /*+ recompile */ i1 from t13 use index (t13_idx_one_two) where i1 < 4 using index t13_idx_one_three, t13_idx_all;

drop index t13_idx_one on t13;
drop index t13_idx_two on t13;
drop index t13_idx_one_two on t13;
drop index t13_idx_one_three on t13;
drop index t13_idx_two_three on t13;
drop index t13_idx_all on t13;
drop table t13;

commit;
--+ holdcas off;

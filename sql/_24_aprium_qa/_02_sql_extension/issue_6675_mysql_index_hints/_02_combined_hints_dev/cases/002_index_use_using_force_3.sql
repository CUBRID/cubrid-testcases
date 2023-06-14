set system parameters 'deduplicate_key_level=0';

--+ holdcas on;

create table t23(i1 integer, i2 integer, i3 integer);
create index t23_idx_one on t23(i1);
create index t23_idx_two on t23(i2);
create index t23_idx_one_two on t23(i1, i2);
create index t23_idx_two_three on t23(i2, i3);
create index t23_idx_one_three on t23(i1, i3);
create index t23_idx_all on t23(i1, i2, i3);

insert into t23 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t23 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t23;

select /*+ recompile */ i1 from t23 where i1 < 4;
select /*+ recompile */ * from t23 where i1 < 4;

select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one(+), t23_idx_one_two(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one(+), t23_idx_two_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one_two(+), t23_idx_two_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one_two(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one_two(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_two_three(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_two_three(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_two) where i1 < 4 using index t23_idx_one_three(+), t23_idx_all(+);

select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_one_two(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_two_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_two_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two_three(+), t23_idx_one_three(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_two_three(+), t23_idx_all(+);
select /*+ recompile */ i1 from t23 use index (t23_idx_one_two) where i1 < 4 using index t23_idx_one_three(+), t23_idx_all(+);

drop index t23_idx_one on t23;
drop index t23_idx_two on t23;
drop index t23_idx_one_two on t23;
drop index t23_idx_one_three on t23;
drop index t23_idx_two_three on t23;
drop index t23_idx_all on t23;
drop table t23;

commit;
--+ holdcas off;

set system parameters 'deduplicate_key_level=32';

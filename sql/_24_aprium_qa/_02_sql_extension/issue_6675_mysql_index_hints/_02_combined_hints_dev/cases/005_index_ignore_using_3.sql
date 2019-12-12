--+ holdcas on;

create table t53(i1 integer, i2 integer, i3 integer);
create index t53_idx_one on t53(i1);
create index t53_idx_two on t53(i2);
create index t53_idx_one_two on t53(i1, i2);
create index t53_idx_two_three on t53(i2, i3);
create index t53_idx_one_three on t53(i1, i3);
create index t53_idx_all on t53(i1, i2, i3);

insert into t53 values (1, 3, 2), (1, 2, 3), (1, 1, 1);
insert into t53 values (2, 3, 2), (2, 2, 3), (2, 1, 1);

commit;
update statistics on t53;

select /*+ recompile */ i1 from t53 where i1 < 4 order by 1;
select /*+ recompile */ * from t53 where i1 < 4 order by 1,2,3;

select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one, t53_idx_one_two order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one, t53_idx_two_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one_two, t53_idx_two_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one_two, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one_two, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_two_three, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_two_three, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_two) where i1 < 4 using index t53_idx_one_three, t53_idx_all order by 1;

select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_one_two order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_two_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_two_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two_three, t53_idx_one_three order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_two_three, t53_idx_all order by 1;
select /*+ recompile */ i1 from t53 ignore index (t53_idx_one_two) where i1 < 4 using index t53_idx_one_three, t53_idx_all order by 1;

drop index t53_idx_one on t53;
drop index t53_idx_two on t53;
drop index t53_idx_one_two on t53;
drop index t53_idx_one_three on t53;
drop index t53_idx_two_three on t53;
drop index t53_idx_all on t53;
drop table t53;

commit;
--+ holdcas off;

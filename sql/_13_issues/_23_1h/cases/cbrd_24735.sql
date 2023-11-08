drop table if exists t_a, t_b;

create table t_a (x int);
insert into t_a values (1);

create table t_b (x int, y int);
insert into t_b
select a.*, b.*
from
  table ({1}) as a,
  table ({1, 2}) as b;
create index idx_desc on t_b (x, y);

update statistics on all classes with fullscan;


-- CBRD-24914 : core dumped caused by revert cbrd-24735
-- After core fixed this case will be included again.
--select /*+ recompile ordered */ t.y
--from t_a inner join t_b as t on t_a.x = t.x and t_a.x = 1
--where t.x = 1
--order by t.y
--limit 1;

select /*+ recompile ordered no_multi_range_opt */ t.y
from t_a inner join t_b as t on t_a.x = t.x and t_a.x = 1
where t.x = 1
order by t.y
limit 1;

drop table t_a, t_b;

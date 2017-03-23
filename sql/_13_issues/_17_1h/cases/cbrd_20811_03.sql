drop if exists t;
create table t(Parent int, Child int);
insert into t values (1, 2), (1, 3), (2, 4), (2, 5), (3, 6), (3, 7), (7, 1);

with cte as (
    select t1.Parent, t1.Child, t2.Child as Grandchild
    from t t1
    inner join t t2 on t2.Parent = t1.Child
    union all
    select cte.Parent, t1.Child, t3.Child as Grandchild
    from cte
    inner join t t1 on t1.Parent = cte.Child
    inner join t t2 on t2.Parent = cte.Grandchild
    inner join t t3 on t3.Parent = t2.Child
    where cte.Child <> cte.Grandchild
)
select Parent, Child
from cte
where Child = Grandchild order by 1,2;
drop if exists t;

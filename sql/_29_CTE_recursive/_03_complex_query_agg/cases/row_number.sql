drop if exists t,x;
create table t as (select 1 as id, 1 as d

union all select 1, 2 as d
union all select 1, 3 as d
union all select 1, 4 as d
union all select 1, 5 as d
union all select 1, 6 as d
union all select 1, 7 as d
union all select 2, 1 as d
union all select 2, 2 as d
union all select 2, 3 as d
union all select 2, 4 as d
union all select 2, 5 as d
union all select 2, 6 as d
union all select 2, 7 as d);
 
create table x as select *, row_number() over( order by 1 ,2  ) as rn from t;
with t2 ( id, d, rn )
as (
    select *
    from x order by 1,2,3
    )
select *
from t2 a
    inner join t2 b
        on b.id = a.id
       and b.d  = a.d
order by a.rn, a.d, a.id, b.rn, b.id, b.d;


with t2 ( id, d, rn )
as (
    select *, row_number() over( order by 1,2) as rn from t order by 1,2,3
    )
select *
from t2 a
    inner join t2 b
        on b.id = a.id
       and b.d  = a.d
order by a.rn, a.d, a.rn, b.rn, b.id, b.d;

with t2 ( id, d, rn )
as (
    select *, row_number() over( order by id, 2) as rn from t order by 1,2,3
    )
select *
from t2 a
    inner join t2 b
        on b.id = a.id
       and b.d  = a.d
order by a.rn, a.d, a.id, b.rn, b.id, b.d;

with t2 ( id, d, rn )
as (
    select *, row_number() over( order by d, id) as rn from t order by 1,2,3
    )
select *
from t2 a
    inner join t2 b
        on b.id = a.id
       and b.d  = a.d
order by a.rn, a.d, a.id, b.rn, b.id, b.d;

with t2 ( id, d, rn )
as (
    select *, row_number() over( order by 1,2) as rn from t order by 1,2,3
    )
select *
from t2 a
    inner join t2 b
        on b.id = a.id
       and b.d  = a.d
order by a.rn, a.d, a.id, b.rn, b.id, b.d;
drop if exists t,x;

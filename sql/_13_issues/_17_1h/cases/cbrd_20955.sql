with 
c0 (a) as (
    select 1 a
    union all
    select a+1 from c0 where a < (select count(*) from c1)
),
c1(a) as (    
    select * from c0
    union all
    select a+1 from c1 where a<10
) 
select * from c1;


with 
c0 (a) as (
    select 1 a 
    union all
    select a+1 from c0 where a < (select count(*) from c0)
),
c1(a) as (    
    select * from c0
    union all
    select a+1 from c1 where a<10
) 
select * from c1;

with
c0 (a) as (
    select 1 a
    union all
    select a+1 from c0 where a in (select distinct * from c1)
),
c1(a) as (
    select * from c0
    union all
    select a+1 from c1 where a<10
)
select * from c1;


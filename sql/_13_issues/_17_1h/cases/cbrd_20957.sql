with c1 (m, n) as (
        select 1 m, 1 n 
        union all
        select m+1,row_number()over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,VAR_SAMP(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,VAR_POP(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,VAR_POP(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;


with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,sum(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,STDDEV_SAMP(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;



with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,STDDEV_POP(m)over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,RANK()over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,ntile(5) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,ntile(5) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;


with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,nth_value(m,2) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,min(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;


with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,median(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;
with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,median(m) over(partition by m )from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,max(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,lead(m,2) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,last_value(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,lag(m,2) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,first_value(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,dense_rank() over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,cume_dist() over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,count(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n
        union all
        select m+1,avg(m) over(partition by m order by n)from c1 where m<10
)
select * from c1 order by 1,2;


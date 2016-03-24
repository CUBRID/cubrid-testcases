--01_percent_rank_001.sql

drop view test;
create view test(score int) as 
(
    select NULL 
    UNION ALL
    select 10
    UNION ALL
    select 40
    UNION ALL
    select 40
    UNION ALL
    select 50
    UNION ALL
    select 50
    UNION ALL
    select 60
    UNION ALL
    select 90 
);

select * from test;

select score,PERCENT_RANK() over(order by score) "per_rnk" from test;
select score,PERCENT_RANK() over(order by score) as per_rnk from test;
select score,PERCENT_RANK() over(partition by score order by score) as per_rnk from test;
select score,PERCENT_RANK() over(order by score nulls first) as per_rnk from test;
select score,PERCENT_RANK() over(order by score nulls last) as per_rnk from test;
select score,PERCENT_RANK() over(order by score desc nulls first) as per_rnk from test;
select score,PERCENT_RANK() over(order by score asc nulls first) as per_rnk from test;
select score,PERCENT_RANK() over(order by score asc nulls last) as per_rnk from test;
select score,PERCENT_RANK() over(order by score desc nulls last) as per_rnk from test;

select score,PERCENT_RANK() over(order by score desc) as per_rnk from test;
select score,PERCENT_RANK() over(order by score asc) as per_rnk from test;

=============
select PERCENT_RANK(40) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(-1) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(-100000) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(1) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(100000) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(1000000) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(2147483647)within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(2147483648) within group (order by score) as "per_rnk" from test;

select PERCENT_RANK(1*0) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(1+39) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK((1+39)) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(1>1) within group (order by score) as "per_rnk" from test;

select PERCENT_RANK(max(score)) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(select 40) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK((select 40)>40) within group (order by score) as "per_rnk" from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score) as "per_rnk" from test;

=============
select PERCENT_RANK(40) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(-1) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(-100000) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(1) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(100000) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(1000000) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(2147483647)within group (order by score) "per_rnk" from test;
select PERCENT_RANK(2147483648) within group (order by score) "per_rnk" from test;

select PERCENT_RANK(1*0) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(1+39) within group (order by score) "per_rnk" from test;
select PERCENT_RANK((1+39)) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(1>1) within group (order by score) "per_rnk" from test;

select PERCENT_RANK(max(score)) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(select 40) within group (order by score) "per_rnk" from test;
select PERCENT_RANK((select 40)>40) within group (order by score) "per_rnk" from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score) "per_rnk" from test;


=============
select PERCENT_RANK(40) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score nulls first) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score nulls first) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score nulls first) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score nulls first) as per_rnk from test;

=============
select PERCENT_RANK(40) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score nulls last) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score nulls last) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score nulls last) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score nulls last) as per_rnk from test;

=============
select PERCENT_RANK(40) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score desc nulls first) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score desc nulls first) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score desc nulls first) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score desc nulls first) as per_rnk from test;


=============
select PERCENT_RANK(40) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score asc nulls first) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score asc nulls first) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score asc nulls first) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score asc nulls first) as per_rnk from test;


=============
select PERCENT_RANK(40) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score asc nulls last) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score asc nulls last) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score asc nulls last) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score asc nulls last) as per_rnk from test;


=============
select PERCENT_RANK(40) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score desc nulls last) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score desc nulls last) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score desc nulls last) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score desc nulls last) as per_rnk from test;


=============
select PERCENT_RANK(40) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score desc) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score desc) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score desc) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score desc) as per_rnk from test;

=============
select PERCENT_RANK(40) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(-1) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(-100000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(-100000000000000000000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(100000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1000000000000000000000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1000000) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(2147483647) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(2147483648) within group (order by score asc) as per_rnk from test;

select PERCENT_RANK(1*0) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1+39) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK((1+39)) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(1>1) within group (order by score asc) as per_rnk from test;

select PERCENT_RANK(max(score)) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(select 40) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK((select 40)) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK((select 40)>40) within group (order by score asc) as per_rnk from test;
select PERCENT_RANK(((select 40)>40)) within group (order by score asc) as per_rnk from test;


drop view test;

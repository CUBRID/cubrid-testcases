--01_percent_rank_007.sql
drop view test;
create view test(score int,score1 timestamp) as
(
    select NULL,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select NULL,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select NULL,NULL
    UNION ALL
    select NULL,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select 10,NULL
    UNION ALL
    select 40,timestamp'01/31/1994 8:15:01 pm'
    UNION ALL
    select 40,timestamp'01/31/1994 8:15:02 pm'
    UNION ALL
    select 40,timestamp'07/31/1994 8:15:00 pm'
    UNION ALL
    select 50,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select 50,timestamp'05/31/1994 8:15:00 pm'
    UNION ALL
    select 60,timestamp'01/31/1994 8:15:00 pm'
    UNION ALL
    select 90,timestamp'03/31/1994 8:15:00 pm'
    UNION ALL
    select 90,timestamp'01/31/1994 8:15:00 pm'
);


select score,score1,PERCENT_RANK() over(order by score,score1) "per_rnk" from test;
select score,score1,PERCENT_RANK() over(order by score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score1 order by score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score,score1,score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score,score1,score,score1,score1 nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score,score1,score,score1,score1 nulls last) as per_rnk from test;

select score,score1,PERCENT_RANK() over(partition by score1 order by score,score1,score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score1 order by score,score1,score,score1,score1 nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score1 order by score,score1,score,score1,score1 nulls last) as per_rnk from test;

select score,score1,PERCENT_RANK() over(order by score nulls first,score1 nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score nulls last,score1 nulls last) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score desc nulls first,score1 desc nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score asc nulls first,score1 asc nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score asc nulls last,score1 asc nulls last) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score desc nulls last,score1 desc nulls last) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score asc nulls last,score1 asc nulls first) as per_rnk from test;


select score,score1,PERCENT_RANK() over(order by score desc,score1 desc) as per_rnk from test;
select score,score1,PERCENT_RANK() over(order by score asc,score1 asc) as per_rnk from test;

select score,score1,PERCENT_RANK() over(partition by score order by score nulls first,score1 nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score nulls last,score1 nulls last) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score desc nulls first,score1 desc nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score asc nulls first,score1 asc nulls first) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score asc nulls last,score1 asc nulls last) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score desc nulls last,score1 desc nulls last) as per_rnk from test;

select score,score1,PERCENT_RANK() over(partition by score order by score desc,score1 desc) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score asc,score1 asc) as per_rnk from test;


select PERCENT_RANK(40,1) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score,score1) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group ( order by score,score1) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,0x3) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'0x3') within group (order by score,score1) as "per_rnk" from test;

select PERCENT_RANK(null,1000000000000000000000000000000000000000000000000000000000000000000000) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'1000000000000000000000000000000000000000000000000000000000000000000000') within group (order by score,score1) as "per_rnk" from test;

select PERCENT_RANK(40,1) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score desc,score1 desc) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,'01/31/1994 8:15:01 pm') within group (order by score asc,score1 asc) as "per_rnk" from test;

drop view test;

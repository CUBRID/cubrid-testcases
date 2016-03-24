--01_percent_rank_008.sql
drop view test;
create view test(score int,score1 set) as
(
    select 40,set{80,90,100}
    UNION ALL
    select 40,set{80,90,110}
)
;


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

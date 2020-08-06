--01_percent_rank_006.sql
drop view if exists test;
create view test(score int,score1 bit(8)) as 
(
    select NULL,b'00001'
    UNION ALL
    select NULL,b'00011'
    UNION ALL
    select NULL,NULL
    UNION ALL
    select NULL,b'00101'
    UNION ALL
    select 10,b'01001'
    UNION ALL
    select 40,b'10001'
    UNION ALL
    select 40,b'00001'
    UNION ALL
    select 40,b'00011'
    UNION ALL
    select 50,b'00101'
    UNION ALL
    select 50,b'01001'
    UNION ALL
    select 60,b'10001'
    UNION ALL
    select 90,b'00001'
    UNION ALL
    select 90,b'00001'
);



select * from test;

select score,score1,PERCENT_RANK() over(order by score,score1) "per_rnk" from test;
select score,score1,PERCENT_RANK() over(order by score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score order by score,score1) as per_rnk from test;
select score,score1,PERCENT_RANK() over(partition by score1 order by score,score1) as per_rnk from test;
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
select PERCENT_RANK(null,b'011101010101') within group (order by score,score1) as "per_rnk" from test;


select PERCENT_RANK(40,1) b'0within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,null) b'0within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,10) b'0within group ( order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') b'0within group ( order by score,score1) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,0x3) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'0x3') within group (order by score,score1) as "per_rnk" from test;

select PERCENT_RANK(null,1000000000000000000000000000000000000000000000000000000000000000000000) within group (order by score,score1) as "per_rnk" from test;
select PERCENT_RANK(null,'1000000000000000000000000000000000000000000000000000000000000000000000') within group (order by score,score1) as "per_rnk" from test;

select PERCENT_RANK(40,1) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score nulls first,score1 nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score nulls last,score1 nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score desc nulls first,score1 desc nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score asc nulls first,score1 asc nulls first) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score asc nulls last,score1 asc nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score desc nulls last,score1 desc nulls last) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score desc,score1 desc) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score desc,score1 desc) as "per_rnk" from test;


select PERCENT_RANK(40,1) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,null) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,10) within group (order by score asc,score1 asc) as "per_rnk" from test;
select PERCENT_RANK(null,b'011101010101') within group (order by score asc,score1 asc) as "per_rnk" from test;

drop view test;

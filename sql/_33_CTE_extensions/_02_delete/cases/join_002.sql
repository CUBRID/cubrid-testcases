drop table if exists o_1,o_2,o_3,o_4,o_5;
create class o_1 (i int, j int);
create class o_2 (i int, j int);
create class o_3 (i int, j int);
create class o_4 (i int, j int);
create class o_5 (i int, j int);
insert into o_1 values (1, 11);
insert into o_1 values (2, 12);
insert into o_1 values (3, 13);
insert into o_1 values (4, 14);
insert into o_1 values (5, 15);
insert into o_2 select i+1, j+1 from o_1;
insert into o_3 select i+2, j+2 from o_1;
insert into o_4 select i+3, j+3 from o_1;
insert into o_5 select i+4, j+4 from o_1;
drop table if exists t;
create table t as
with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i ), 
cte2(col1,col2,col3,col4,col5,col6) as 
(select * from cte1 w inner join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x inner join o_4 y on x.col1 = y.i) 
select * from cte3 order by 1,2,3,4,5,6,7,8;  

with recursive cte1(col1,col2,col3,col4) as
(select * from o_1 v inner join o_2 w on v.i = w.i ), 
cte2(col1,col2,col3,col4,col5,col6) as 
(select * from cte1 w inner join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x inner join o_4 y on x.col1 = y.i) 
delete from t where t.col1 in (select col1 from cte3 order by 1);

insert into t 
with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w inner join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x left join o_4 y on x.col1 = y.i) 
select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w inner join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x left join o_4 y on x.col1 = y.i) 
delete from t where t.col2 in (select col2 from cte3 order by 1);

insert into t
with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i ),
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w inner join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x right join o_4 y on x.col1 = y.i)
select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i ),
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w inner join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x right join o_4 y on x.col1 = y.i)
delete t,o_1 from t,o_1,cte3 where o_1.i=cte3.col1 and o_1.j=cte3.col2 and t.col1=cte3.col1;

select * from t order by 1;
select * from o_1 order by 1;

insert into t 
with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w left join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x  inner join o_4 y on x.col1 = y.i)
select * from cte3 
union all
select col1,col2,col3,col4,col5,col6,3,13 from cte2
union all 
select col1,col2,col3,col4,4,14,4,14 from cte1;


with recursive cte1(col1,col2,col3,col4) as
(select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as
( select * from cte1 w left join o_3 x on w.col1 = x.i),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as
(select * from cte2 x  inner join o_4 y on x.col1 = y.i)
delete from t where t.col1 in (select col1 from cte1
union all
select col1 from cte2
union all
select col1 from cte1);

replace into t 
with recursive cte1(col1,col2,col3,col4) as 
(select * from o_1 v inner join o_2 w on v.i = w.i) ,
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x left join o_4 y on x.col1 = y.i )
select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as
(select * from o_1 v inner join o_2 w on v.i = w.i) ,
cte2(col1,col2,col3,col4,col5,col6) as 
( select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as 
(select * from cte2 x left join o_4 y on x.col1 = y.i )
update t,cte1 set t.col1=cte1.col1 where cte1.col2=t.col2 and cte1.col3=t.col3;

with recursive cte1(col1,col2,col3,col4) as
(select * from o_1 v inner join o_2 w on v.i = w.i) ,
cte2(col1,col2,col3,col4,col5,col6) as
( select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as
(select * from cte2 x left join o_4 y on x.col1 = y.i )
update t,cte1,cte2,cte3 set t.col1=cte1.col1 where cte2.col2=t.col2 and cte3.col3=t.col3 and cte1.col4 is not null;

with recursive cte1(col1,col2,col3,col4) as
(select * from o_1 v inner join o_2 w on v.i = w.i) ,
cte2(col1,col2,col3,col4,col5,col6) as
( select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as
(select * from cte2 x left join o_4 y on x.col1 = y.i )
update t,cte1,cte2,cte3 set t.col1=-1,t.col2=-2 where t.col1 is null and t.col2 is null;


with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v inner join o_2 w on v.i = w.i ),
cte2(col1,col2,col3,col4,col5,col6) as (
    select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x right join o_4 y on x.col1 = y.i )
delete from t;

insert into t
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w right join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x inner join o_4 y on x.col1 = y.i )
select * from cte3 order by 1,2,3,4,5,6,7,8;

alter table t col1 col1 int unique;
replace into t
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v inner join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w right join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x inner join o_4 y on x.col1 = y.i )
select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  left join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i ),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  right join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i ),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  inner join o_4 y on x.col1 = y.i)select * from cte3  order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  left join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i)select * from cte3  order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  right join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v left join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i)select * from cte3  order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;

drop table if exists yoo;
create table yoo as
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v right join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
insert into t
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v right join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x left join o_4 y on x.col1 = y.i)  
select * from cte1 order by 1,2,3,4;

insert into t
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v right join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x right join o_4 y on x.col1 = y.i) 
select * from cte3 order by 1,2,3,4,5,6,7,8;

alter table t change col7 col7 int unique;
replace into t
with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v right join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x right join o_4 y on x.col1 = y.i) 
select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as (
    select * from o_1 v right join o_2 w on v.i = w.i),
cte2(col1,col2,col3,col4,col5,col6) as ( 
    select * from cte1 w left join o_3 x on w.col1 = x.i ),
cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (
    select * from cte2 x right join o_4 y on x.col1 = y.i)
update t set col1=-10,col2=-9 where col1 is null and col2 is null ;

drop if exists o_1,o_2,o_3,o_4,o_5;

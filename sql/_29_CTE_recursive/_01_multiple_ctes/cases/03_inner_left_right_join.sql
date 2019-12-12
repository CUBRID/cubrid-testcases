autocommit off;
drop if exists o_1,o_2,o_3,o_4,o_5;
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
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i ), cte2(col1,col2,col3,col4,col5,col6) as (select * from cte1 w inner join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;  

with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i ),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w inner join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;

with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x  inner join o_4 y on x.col1 = y.i)select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i) ,cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i ),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v inner join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
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
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i )select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i)  select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w left join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x inner join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x left join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;
with recursive cte1(col1,col2,col3,col4) as (select * from o_1 v right join o_2 w on v.i = w.i),cte2(col1,col2,col3,col4,col5,col6) as ( select * from
 cte1 w right join o_3 x on w.col1 = x.i ),cte3(col1,col2,col3,col4,col5,col6,col7,col8) as (select * from cte2 x right join o_4 y on x.col1 = y.i) select * from cte3 order by 1,2,3,4,5,6,7,8;
drop if exists o_1,o_2,o_3,o_4,o_5;
rollback;

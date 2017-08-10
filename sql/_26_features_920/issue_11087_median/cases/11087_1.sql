drop table if exists median_1;

create table median_1 (a int, c1 short, c2 int, c3 bigint, c4 float, c5 double, c6 monetary, c7 numeric(38,18), c8 date, c9 datetime, c10 timestamp, c11 varchar(255), c12 varchar(255), c13 varchar(255), c14 time);

insert into median_1 values(1, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, date'2011-1-1', datetime'2011-1-1 1:1:1.111', timestamp'2011-1-1 1:1:1', '1.0', '2011-1-1 1:1:1.111', '1.0', time'0:0:1');
insert into median_1 values(1, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59');
insert into median_1 values(2, 2, 2, 2, 2.0, 2.0, 2.0, 2.0, date'2012-2-2', datetime'2012-2-2 2:2:2.222', timestamp'2012-2-2 2:2:2', '2.0', '2012-2-2 2:2:2.222', '2.0', time'0:1:2');
insert into median_1 values(3, 3, 3, 3, 3.0, 3.0, 3.0, 3.0, date'2013-3-3', datetime'2013-3-3 3:3:3.333', timestamp'2013-3-3 3:3:3', '3.0', '2013-3-3 3:3:3.333', '3.0', time'1:2:3');
insert into median_1 values(3, 4, 5, 6, 7.0, 8.0, 9.0, 10.0, date'2013-3-4', datetime'2013-3-5 3:3:3.333', timestamp'2013-3-6 3:3:3', '7.0', '2013-3-8 3:3:3.333', '9.0', time'2:3:4');
insert into median_1 values(3, 5, 7, 9, 11.0, 13.0, 15.0, 17.0, date'2013-3-5', datetime'2013-3-7 3:3:3.333', timestamp'2013-3-9 3:3:3', '11.0', '2013-3-13 3:3:3.333', '15.0', time'3:4:5');
insert into median_1 values(3, 6, 9, 12, 15.0, 18.0, 21.0, 24.0, date'2013-3-6', datetime'2013-3-9 3:3:3.333', timestamp'2013-3-12 3:3:3', '15.0', '2013-3-18 3:3:3.333', '21.0', time'4:5:6');
insert into median_1 values(3, 7, 11, 15, 19.0, 23.0, 27.0, 31.0, date'2013-3-7', datetime'2013-3-11 3:3:3.333', timestamp'2013-3-15 3:3:3', '19.0', '2013-3-23 3:3:3.333', '27.0', time'5:6:7');
insert into median_1 values(4, 4, 4, 4, 4.0, 4.0, 4.0, 4.0, date'2014-4-4', datetime'2014-4-4 4:4:4.444', timestamp'2014-4-4 4:4:4', '4.0', '2014-4-4 4:4:4.444', '4.0', time'6:7:8');
insert into median_1 values(4, 5, 6, 7, 8.0, 9.0, 10.0, 11.0, date'2014-4-5', datetime'2014-4-6 4:4:4.444', timestamp'2014-4-7 4:4:4', '8.0', '2014-4-9 4:4:4.444', '10.0', time'7:8:9');
insert into median_1 values(4, 6, 8, 10, 12.0, 14.0, 16.0, 18.0, date'2014-4-6', datetime'2014-4-8 4:4:4.444', timestamp'2014-4-10 4:4:4', '12.0', '2014-4-14 4:4:4.444', '16.0', time'8:9:10');
insert into median_1 values(4, 7, 10, 13, 16.0, 19.0, 22.0, 25.0, date'2014-4-7', datetime'2014-4-10 4:4:4.444', timestamp'2014-4-13 4:4:4', '16.0', '2014-4-19 4:4:4.444', '22.0', time'10:11:12');

-- common test
select c1 from median_1 order by 1;
select  median(a)  from median_1;
select  median(c1)  from median_1;
select  median(c2)  from median_1;
select  median(c3)  from median_1;
select  median(c4)  from median_1;
select  median(c5)  from median_1;
select  median(c6)  from median_1;
select  median(c7)  from median_1;
select  median(c8)  from median_1;
select  median(c9)  from median_1;
select  median(c10)  from median_1;
select  median(c11)  from median_1;
select  median(c12)  from median_1;
select  median(c13)  from median_1;
select  median(c14)  from median_1;
select  median(a),  median(c1), median(c2), median(c3), median(c4), median(c5), median(c6), median(c7), median(c8), median(c9), median(c10), median(c11), median(c12), median(c13), median(c14)  from median_1;
select  a, median(a) over(partition by a)  from median_1 order by 1;
select  a, median(c1) from median_1 group by a,2;
select  a, median(c1) over(partition by a)  from median_1 order by 1;
select  a, median(c2) over(partition by a)  from median_1 order by 1;
select  a, median(c3) over(partition by a)  from median_1 order by 1;
select  a, median(c4) over(partition by a)  from median_1 order by 1;
select  a, median(c5) over(partition by a)  from median_1 order by 1;
select  a, median(c6) over(partition by a)  from median_1 order by 1;
select  a, median(c7) over(partition by a)  from median_1 order by 1;
select  a, median(c8) over(partition by a)  from median_1 order by 1;
select  a, median(c9) over(partition by a)  from median_1 order by 1;
select  a, median(c10) over(partition by a)  from median_1 order by 1;
select  a, median(c11) over(partition by a)  from median_1 order by 1;
select  a, median(c12) over(partition by a)  from median_1 order by 1;
select  a, median(c13) over(partition by a)  from median_1 order by 1;
select  a, median(c14) over(partition by a)  from median_1 order by 1;
select  a, c1, median(c14) over(partition by a), median(c2) over(partition by c1)  from median_1 order by 1,2;
select  a, c1,c2, median(c14) over(partition by a), median(c13) over(partition by c1), median(c12) over(partition by c2)  from median_1 order by 1,2,3;

select  a, median(c1) from median_1 group by a; 
select  median(c1)  from median_1 where a=4;
select  a, median(c1) from median_1 where a=4 group by a;
select  a, median(c1) from median_1 group by a having a=4;
select  a, median(c1) from median_1 where a>2 group by a order by 1,2;  
select  a, median(c1) from median_1 group by a having a>2 order by 1,2;

select median(c2)  from median_1 group by a order by 1; 
select a, median(c2)  from median_1 group by a order by 1;
select newt.a, newt.c2, median(newt.c2)  from (select a,c2 from median_1 order by 1,2) newt group by newt.a having avg(newt.c2) > 7 order by 1,2;
select newt.a, newt.c2, avg(newt.c2), median(newt.c2)  from (select a,c2 from median_1 order by 1,2 )newt group by newt.a having avg(newt.c2) > 7 order by 1,2;
select newt.a, newt.c2, count(newt.c2), median(newt.c2)  from (select a,c2 from median_1 order by 1,2) newt  group by newt.a having count(newt.c2) > 2 order by 1,2;


select  a, median(c1) over(partition by a)  from median_1  where a=4 ;


-- subquery
select median(b.c1) from (select * from median_1) as b ;
select median(b.c1) from (select c1 from median_1) as b order by 1;

select median(b.m_c1) from (select  a, median(c1) over(partition by a) as m_c1 from median_1) as b ;
select b.a, median(b.m_c1) over(partition by b.a) from (select  a, median(c1) over(partition by a) as m_c1 from median_1) as b order by 1;
select distinct b.a, median(b.m_c1) over(partition by b.a) from (select  a, median(c1) over(partition by a) as m_c1 from median_1) as b order by 1;
select b.a, median(b.m_c1) over(partition by b.a) from (select distinct a, median(c1) over(partition by a) as m_c1 from median_1) as b order by 1,2;
select distinct b.a, median(b.m_c1) over(partition by b.a) from (select distinct a, median(c1) over(partition by a) as m_c1 from median_1) as b order by 1;

select  median(c.m_b_c1) from (select b.c2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_1) as b) as c order by 1;
select c.bc2,  median(c.m_b_c1) from (select b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_1) as b) as c group by c.bc2 order by 1,2;
select c.bc2,  median(c.m_b_c1) over(partition by c.bc2) from (select b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_1) as b) as c order by 1,2;
select c.ba,  median(c.m_b_c1) over(partition by c.ba) from (select b.a as ba, b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_1) as b) as c order by 1,2; 
select c.ba,  median(c.bc2) over(partition by c.ba) from (select b.a as ba, b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_1) as b) as c order by 1,2;

--analytic/aggregate functions
--- avg CUBRIDSUS-11667
select avg(c1) from median_1 ;
select avg(c2), median(c1) from median_1 ;
select a, avg(c2) over(partition by a) as a_c2, median(c1) over(partition by a) as m_c1 from median_1 order by 1;
select newt.a, avg(newt.c2) over(partition by newt.a) as a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c2,c1 from median_1 order by 1,2) newt group by newt.a order by 1;
select newt.a, avg(all newt.c2) over(partition by newt.a) as a_c2, median(distinct newt.c1) over(partition by newt.a) m_c1 from (select a,c2,c1 from median_1 order by 1,2 ) newt group by newt.a order by 1;
select newt.a, avg(distinct newt.c2) over(partition by newt.a) a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c2,c1 from median_1 order by 1,2) newt group by newt.a order by 1;

--- count
select count(c1), median(c1) from median_1 ;
select newt.a, count(newt.c3), median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c3,c1 from median_1 order by 1,2) newt group by newt.a order by 1;
select newt.a, count(newt.c3), avg(newt.c2) over(partition by newt.a) a_c2, median(newt.c1) over(partition by newt.a) m_c1 from (select a,c3,c2,c1 from median_1 order by 1,2,3)newt group by newt.a order by 1;

--- rank and  dense rank
select a, rank() over ( order by a asc ) as d_a from median_1 order by 1;
select a, rank() over (partition by a order by c1 desc ) as d_a from median_1 order by 1;
select a, median(c1) over(partition by a) as m_c1, rank() over (partition by a order by c1 desc ) as d_a from median_1 order by 1;

select a, dense_rank() over ( order by a asc ) as d_a from median_1 order by 1;
select a, dense_rank() over (partition by a order by c1 desc ) as d_a from median_1 order by 1;
select a, median(c1) over(partition by a) as m_c1, dense_rank() over (partition by a order by c1 desc ) as d_a from median_1 order by 1;

--- group contact
SELECT GROUP_CONCAT(newt.c11) FROM (select c11 from median_1 order by 1) newt ;
SELECT median(newt.c1),GROUP_CONCAT(newt.c11) FROM (select c1,c11 from median_1 order by 2) newt  order by 1;
SELECT newt.a, median(newt.c1) over (partition by newt.a) as m_c1, GROUP_CONCAT(newt.c11 order by newt.c11 separator ':') as g_c11 FROM (select a,c1,c11 from  median_1 order by 1,2) newt group by newt.a order by 1; 
SELECT newt.a, median(newt.c1) over (partition by newt.a) as m_c1, GROUP_CONCAT(newt.c11 order by 1 separator ':') as g_c11 FROM (select a,c1,c11 from median_1 order by 1,2) newt group by newt.a order by 1;   

--- lag
select  a, LAG(a, 1) over (order by a), median(a) over(partition by a)  from median_1 order by 1,2;
select  a, LAG(a, 2) over (order by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- lead
select  a, LEAD(a, 1) over (order by a), median(a) over(partition by a)  from median_1 order by 1,2;
select  a, LEAD(a, 2) over (order by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- max
SELECT median(c1), max(c2) FROM median_1;
select  a, max(c1) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- min
SELECT median(c1), min(c2) FROM median_1;
select  a, min(c1) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- ntile
select  a, NTILE(5) over(order by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- row_number
select  a, median(a) over(partition by a), row_number() over (order by a) from median_1 order by 1,2;
select  a, median(a) over(partition by a), row_number() over (partition by a order by a) from median_1 order by 1,2;

--- sum
SELECT median(c1), sum(cast(c2 as double)) FROM median_1 order by 1,2;
select  a, sum(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- stddev, stddev_pop, stddev_samp
SELECT median(c1), stddev(cast(c2 as double)) FROM median_1;
select  a, stddev(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;
SELECT median(c1), stddev_pop(cast(c2 as double)) FROM median_1;
select  a, stddev_pop(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;
SELECT median(c1), stddev_samp(cast(c2 as double)) FROM median_1 order by 1,2;
select  a, stddev_samp(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;

--- variance, var_pop, var_samp
SELECT median(c1), variance(cast(c2 as double)) FROM median_1;
select  a, variance(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;
SELECT median(c1), var_pop(cast(c2 as double)) FROM median_1;
select  a, var_pop(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;
SELECT median(c1), var_samp(cast(c2 as double)) FROM median_1;
select  a, var_samp(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_1 order by 1,2;



drop table if exists median_1;


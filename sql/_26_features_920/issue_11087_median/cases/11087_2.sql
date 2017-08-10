drop table if exists median_2;

create table median_2 (a int, c1 short, c2 int, c3 bigint, c4 float, c5 double, c6 monetary, c7 numeric(38,18));

insert into median_2
 values(1, 3276, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(2, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(2, -32768, -2147483648, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(4, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(3, -32768, -2147483648, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(4, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(3, -32768, -2147483648, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(5, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');
insert into median_2
 values(6, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999');

--common test
select c1 from median_2 order by 1;
select  median(a)  from median_2 order by 1;
select  median(c1)  from median_2 order by 1;
select  median(c2)  from median_2 order by 1;
select  median(c3)  from median_2 order by 1;
select  median(c4)  from median_2 order by 1;
select  median(c5)  from median_2 order by 1;
select  median(c6)  from median_2 order by 1;
select  median(c7)  from median_2 order by 1;


--analytic/aggregate functions
--- avg CUBRIDSUS-11667
select avg(c1) from median_2 order by 1;
select avg(cast(c1 as double)) from median_2 order by 1;
select avg(c2), median(c1) from median_2 order by 1;
select avg(cast(c2 as double)), median(c1) from median_2 order by 1;
select a, avg(c2) over(partition by a), median(c1) over(partition by a) from median_2 order by 1;
select a, avg(cast(c2 as double)) over(partition by a), median(c1) over(partition by a) from median_2 order by 1;
select a, avg(c2) over(partition by a), median(c1) over(partition by a) from median_2 group by a order by 1;
select a, avg(all c2) over(partition by a), median(distinct c1) over(partition by a) from median_2 group by a order by 1;
select a, avg(distinct c2) over(partition by a), median(c1) over(partition by a) from median_2 group by a order by 1;

drop table if exists median_2;

-- median in partition table
drop table if exists median_p;
create table median_p (
  a int, c1 short, c2 int, c3 bigint, c4 float, c5 double, 
  c6 monetary, c7 numeric(38,18), c8 date, c9 datetime, c10 timestamp, 
  c11 varchar(255), c12 varchar(255), c13 varchar(255), c14 time, c15 bit(1), 
  c16 bit varying(8), c17 string, c18 enum('Yes', 'NO','Cancel'), c19 SET(CHAR(1)), c20 MULTISET(CHAR(1)),
  c21 LIST(CHAR(1))
)
partition by RANGE(a)(
  partition par_a1 values less than (5),
  partition par_a2 values less than (10),
  partition par_a3 values less than (20),
  partition par_a4 values less than MAXVALUE
);

insert into median_p values(
  1, 1, 1, 1, 1.0, 
  1.0, 1.0, 1.0, date'2011-1-1', datetime'2011-1-1 1:1:1.111',
  timestamp'2011-1-1 1:1:1', '1.0', '2011-1-1 1:1:1.111', '1.0', time'0:0:1', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'}
);

insert into median_p values(
  1, 3276, 214999, 9223372036854775807, +3.402823466E+38, 
  +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(3, 3, 3, 3, 3.0, 3.0, 3.0, 3.0, date'2013-3-3', datetime'2013-3-3 3:3:3.333', timestamp'2013-3-3 3:3:3', '3.0', '2013-3-3 3:3:3.333', '3.0', time'1:2:3', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
insert into median_p values(3, 4, 5, 6, 7.0, 8.0, 9.0, 10.0, date'2013-3-4', datetime'2013-3-5 3:3:3.333', timestamp'2013-3-6 3:3:3', '7.0', '2013-3-8 3:3:3.333', '9.0', time'2:3:4', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
insert into median_p values(3, 5, 7, 9, 11.0, 13.0, 15.0, 17.0, date'2013-3-5', datetime'2013-3-7 3:3:3.333', timestamp'2013-3-9 3:3:3', '11.0', '2013-3-13 3:3:3.333', '15.0', time'3:4:5', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
insert into median_p values(3, 6, 9, 12, 15.0, 18.0, 21.0, 24.0, date'2013-3-6', datetime'2013-3-9 3:3:3.333', timestamp'2013-3-12 3:3:3', '15.0', '2013-3-18 3:3:3.333', '21.0', time'4:5:6', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
insert into median_p values(3, 7, 11, 15, 19.0, 23.0, 27.0, 31.0, date'2013-3-7', datetime'2013-3-11 3:3:3.333', timestamp'2013-3-15 3:3:3', '19.0', '2013-3-23 3:3:3.333', '27.0', time'5:6:7', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});

insert into median_p values(4, 4, 4, 4, 4.0, 4.0, 4.0, 4.0, date'2014-4-4', datetime'2014-4-4 4:4:4.444', timestamp'2014-4-4 4:4:4', '4.0', '2014-4-4 4:4:4.444', '4.0', time'6:7:8', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(4, 5, 6, 7, 8.0, 9.0, 10.0, 11.0, date'2014-4-5', datetime'2014-4-6 4:4:4.444', timestamp'2014-4-7 4:4:4', '8.0', '2014-4-9 4:4:4.444', '10.0', time'7:8:9', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(4, 6, 8, 10, 12.0, 14.0, 16.0, 18.0, date'2014-4-6', datetime'2014-4-8 4:4:4.444', timestamp'2014-4-10 4:4:4', '12.0', '2014-4-14 4:4:4.444', '16.0', time'8:9:10', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(4, 7, 10, 13, 16.0, 19.0, 22.0, 25.0, date'2014-4-7', datetime'2014-4-10 4:4:4.444', timestamp'2014-4-13 4:4:4', '16.0', '2014-4-19 4:4:4.444', '22.0', time'10:11:12', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   

insert into median_p values(5, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(5, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(5, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(5, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(5, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(6, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(6, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(6, 3276, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(7, 3277, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(7, 3277, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   

insert into median_p values(11, 32711, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(11, 32711, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(12, 32711, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(15, 32711, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(17, 32711, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(21, 32721, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(231, 32721, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(4331, 32721, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(65651, 32721, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   
insert into median_p values(5566565, 32721, 214999, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, 99999999999999999999.999999999999999999, date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59', B'1', 
   B'1010','NHN CHina', 'Yes', {'c','c','c','b','b','a'}, {'c','c','c','b','b', 'a'}, 
  {'c','c','c','b','b', 'a'});
   


-- common test
select c1 from median_p order by c1;
select  median(a)  from median_p order by 1;
select  median(c1)  from median_p order by 1;
select  median(c2)  from median_p order by 1;
select  median(c3)  from median_p order by 1;
select  median(c4)  from median_p order by 1;
select  median(c5)  from median_p order by 1;
select  median(c6)  from median_p order by 1;
select  median(c7)  from median_p order by 1;
select  median(c8)  from median_p order by 1;
select  median(c9)  from median_p order by 1;
select  median(c10)  from median_p order by 1;
select  median(c11)  from median_p order by 1;
select  median(c12)  from median_p order by 1;
select  median(c13)  from median_p order by 1;
select  median(c14)  from median_p order by 1;
select  median(a),  median(c1), median(c2), median(c3), median(c4), median(c5), median(c6), median(c7), median(c8), median(c9), median(c10), median(c11), median(c12), median(c13), median(c14)  from median_p order by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
select  a, median(a) over(partition by a)  from median_p order by 1,2;
select  a, median(c1) from median_p group by a order by 1,2;
select  a, median(c1) over(partition by a)  from median_p order by 1,2;
select  a, median(c2) over(partition by a)  from median_p order by 1,2;
select  a, median(c3) over(partition by a)  from median_p order by 1,2;
select  a, median(c4) over(partition by a)  from median_p order by 1,2;
select  a, median(c5) over(partition by a)  from median_p order by 1,2;
select  a, median(c6) over(partition by a)  from median_p order by 1,2;
select  a, median(c7) over(partition by a)  from median_p order by 1,2;
select  a, median(c8) over(partition by a)  from median_p order by 1,2;
select  a, median(c9) over(partition by a)  from median_p order by 1,2;
select  a, median(c10) over(partition by a)  from median_p order by 1,2;
select  a, median(c11) over(partition by a)  from median_p order by 1,2;
select  a, median(c12) over(partition by a)  from median_p order by 1,2;
select  a, median(c13) over(partition by a)  from median_p order by 1,2;
select  a, median(c14) over(partition by a)  from median_p order by 1,2;
select  a, c1, median(c14) over(partition by a), median(c2) over(partition by c1)  from median_p order by 1,2;
select  a, c1,c2, median(c14) over(partition by a), median(c13) over(partition by c1), median(c12) over(partition by c2)  from median_p order by 1,2;

select  a, median(c1) from median_p group by a order by 1,2;
select  median(c1)  from median_p where a=4 order by 1;
select  a, median(c1) from median_p where a=4 group by a order by 1,2;
select  a, median(c1) from median_p group by a having a=4 order by 1,2;
select  a, median(c1) from median_p where a>2 group by a order by 1,2;  
select  a, median(c1) from median_p group by a having a>2 order by 1,2;

select median(c2)  from median_p group by a order by 1; 
select a, median(c2)  from median_p group by a order by 1,2;
select a, c2, median(c2)  from median_p group by a having avg(c2) > 7 order by 1,2;
select a, c2, avg(c2), median(c2)  from median_p group by a having avg(c2) > 7 order by 1,2;
select a, count(c2), median(c2)  from median_p group by a having count(c2) > 2 order by 1,2;

select  a, median(c1) over(partition by a)  from median_p  where a=4 order by 1,2;


-- subquery
select  median(b.c1) from (select * from median_p) as b order by 1;
select  median(b.c1) from (select c1 from median_p) as b order by 1;

select  median(b.m_c1) from (select  a, median(c1) over(partition by a) as m_c1 from median_p) as b;
select b.a, median(b.m_c1) over(partition by b.a) from (select  a, median(c1) over(partition by a) as m_c1 from median_p) as b;
select distinct b.a, median(b.m_c1) over(partition by b.a) from (select  a, median(c1) over(partition by a) as m_c1 from median_p) as b;
select b.a, median(b.m_c1) over(partition by b.a) from (select distinct a, median(c1) over(partition by a) as m_c1 from median_p) as b;
select distinct b.a, median(b.m_c1) over(partition by b.a) from (select distinct a, median(c1) over(partition by a) as m_c1 from median_p) as b;

select  median(c.m_b_c1) from (select b.c2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_p) as b) as c;
select c.bc2,  median(c.m_b_c1) from (select b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_p) as b) as c group by c.bc2;
select c.bc2,  median(c.m_b_c1) over(partition by c.bc2) from (select b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_p) as b) as c;
select c.ba,  median(c.m_b_c1) over(partition by c.ba) from (select b.a as ba, b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_p) as b) as c; 
select c.ba,  median(c.bc2) over(partition by c.ba) from (select b.a as ba, b.c2 as bc2, median(b.m_c1) over(partition by b.c2) as m_b_c1 from (select  a, c2, median(c1) over(partition by a) as m_c1 from median_p) as b) as c;

--analytic/aggregate functions
--- avg CUBRIDSUS-11667
select avg(c1) from median_p;
select avg(c2), median(c1) from median_p;
select a, avg(c2) over(partition by a) as a_c2, median(c1) over(partition by a) as m_c1 from median_p;
select newt.a, avg(newt.c2) over(partition by newt.a) as a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c2,c1 from  median_p order by 1,2,3) newt  group by newt.a;
select newt.a, avg(all newt.c2) over(partition by newt.a) as a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c2,c1 from  median_p order by 1,2,3) newt  group by newt.a;
select newt.a, avg(distinct newt.c2) over(partition by newt.a) as a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c2,c1 from  median_p order by 1,2,3) newt  group by newt.a;

--- count
select count(c1), median(c1) from median_p;
select newt.a, count(newt.c3), median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c3,c1 from  median_p order by 1,2,3) newt  group by newt.a;
select newt.a, count(newt.c3), avg(newt.c2) over(partition by newt.a) as a_c2, median(newt.c1) over(partition by newt.a) as m_c1 from (select a,c3,c1,c2 from  median_p order by 1,2,3,4) newt  group by newt.a;


--- rank and  dense rank
select a, rank() over ( order by a asc ) as d_a from median_p;
select a, rank() over (partition by a order by c1 desc ) as d_a from median_p;
select a, median(c1) over(partition by a) as m_c1, rank() over (partition by a order by c1 desc ) as d_a from median_p;

select a, dense_rank() over ( order by a asc ) as d_a from median_p;
select a, dense_rank() over (partition by a order by c1 desc ) as d_a from median_p;
select a, median(c1) over(partition by a) as m_c1, dense_rank() over (partition by a order by c1 desc ) as d_a from median_p;

--- group contact
SELECT GROUP_CONCAT(newt.c11) FROM (select c11 from median_p order by 1) newt ;
SELECT median(newt.c1),GROUP_CONCAT(newt.c11) FROM (select c1,c11 from median_p order by 2 ) newt;
SELECT newt.a, median(newt.c1) over (partition by newt.a) as m_c1, GROUP_CONCAT(newt.c11 order by newt.c11 separator ':') as g_c11 FROM (select a,c1,c11 from median_p order by 1,2 ) newt group by newt.a;
SELECT newt.a, median(newt.c1) over (partition by newt.a) as m_c1, GROUP_CONCAT(newt.c11 order by newt.c11 separator ':') as g_c11 FROM (select a,c1,c11 from median_p order by 1 ,2 ) newt group by newt.a;

--- lag
select  a, LAG(a, 1) over (order by a), median(a) over(partition by a)  from median_p order by 1,2;
select  a, LAG(a, 2) over (order by a), median(a) over(partition by a)  from median_p order by 1,2;

--- lead
select  a, LEAD(a, 1) over (order by a), median(a) over(partition by a)  from median_p order by 1,2;
select  a, LEAD(a, 2) over (order by a), median(a) over(partition by a)  from median_p order by 1,2;

--- max
SELECT median(c1), max(c2) FROM median_p order by 1,2;
select  a, max(c1) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;

--- min
SELECT median(c1), min(c2) FROM median_p order by 1,2;
select  a, min(c1) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;

--- ntile
select  a, NTILE(5) over(order by a), median(a) over(partition by a)  from median_p order by 1,2;

--- row_number
select  a, median(a) over(partition by a), row_number() over (order by a) from median_p order by 1,2;
select  a, median(a) over(partition by a), row_number() over (partition by a order by a) from median_p order by 1,2;

--- sum
SELECT median(c1), sum(cast(c2 as double)) FROM median_p order by 1,2;
select  a, sum(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;

--- stddev, stddev_pop, stddev_samp
SELECT median(c1), stddev(cast(c2 as double)) FROM median_p order by 1,2;
select  a, stddev(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;
SELECT median(c1), stddev_pop(cast(c2 as double)) FROM median_p order by 1,2;
select  a, stddev_pop(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;
SELECT median(c1), stddev_samp(cast(c2 as double)) FROM median_p order by 1,2;
select  a, stddev_samp(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;

--- variance, var_pop, var_samp
SELECT median(c1), variance(cast(c2 as double)) FROM median_p order by 1,2;
select  a, variance(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;
SELECT median(c1), var_pop(cast(c2 as double)) FROM median_p order by 1,2;
select  a, var_pop(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;
SELECT median(c1), var_samp(cast(c2 as double)) FROM median_p order by 1,2;
select  a, var_samp(cast(c1 as int)) over(partition by a), median(a) over(partition by a)  from median_p order by 1,2;


drop table if exists median_p;

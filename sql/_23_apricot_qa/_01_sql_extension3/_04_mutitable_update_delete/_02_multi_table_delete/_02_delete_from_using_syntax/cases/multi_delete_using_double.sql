--delete from 2 tables with double type column for join condition



create table md_double1(id1 double, col1 timestamp not null default CURRENT_TIMESTAMP);
insert into md_double1 values(1111111.11111, '2011-09-01 12:12:12'), (2222222.22222, '2011-09-01 12:12:13'), (33333333.33333, '2011-09-01 12:12:14'), (4444444.44444, '2011-09-01 12:12:15'), (5555555.55555, '2011-09-01 12:12:16'), (6666666.66666, '2011-09-01 12:12:17'), (7777777.77777, '2011-10-10 1:1:1'), (8888888.88888, '2011-10-10 2:2:2'), (9999999.99999, '2011-11-11 11:11:11'), (1010101010.123, '2012-12-12 8:8:8');


create table md_double2(col1 varchar(1024), id2 double primary key);
insert into md_double2 values('cubrid', 1234.12345), ('abc', 3333333456.34555), ('a', 55555.55555), ('abcabc', 4444444.12345), ('aa', 5555.1234), ('mysql', 2222222.22222);
insert into md_double2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444444), ('aaaa', 5555656.56565), ('abcabcabc', 6666666.66666), ('hello', 777777777.88777), ('hellohello', 90000.909);


select * from md_double1 order by 1;
select * from md_double2 order by 1;


--TEST: error, false join condition
delete from m1 using md_double1 m1, md_double2 m2 where m2.col1=m1.col1;


--TEST: without table aliases
delete from md_double1 using md_double1, md_double2 where truncate(md_double1.id1, -2)=truncate(md_double2.id2, -2) and second(md_double1.col1) < 14;
select * from md_double1 order by 1;
select if (count(*) = 12, 'ok', 'nok') from md_double2;


--TEST: with table aliases
delete from m2 using (select id1, col1 from (select * from md_double1 where month(col1)=9) md1) m1, md_double2 m2 where m1.id1=m2.id2 and time(m1.col1) <= '12:12:18';
select if (count(*) = 9, 'ok', 'nok') from md_double1;
select * from md_double2 order by 1;


--TEST: inner join, no matched results
delete from m1, m2 using md_double1 as m1 inner join (select id2, substr(col1, 1, 6) from md_double2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
delete from m1 using md_double1 as m1 inner join (select id2, substr(col1, 1, 6) from md_double2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
select if (count(*) = 9, 'ok', 'nok') from md_double1;
select if (count(*) = 11, 'ok', 'nok') from md_double2;

--TEST: left outer join, delete and select from the same table
delete from m1, m2 using md_double2 m2 left outer join md_double1 m1 on m1.id1=m2.id2 where m1.id1 > (select avg(id1) from md_double1);
select if (count(*) = 9, 'ok', 'nok') from md_double1;
select * from md_double2 order by 1;


--TEST: right outer join
--TEST: error, delete and select from the same table
delete from m2, m1 using md_double1 m1 right outer join md_double2 m2 on m1.id1=m2.id2 where m1.id1 < (select abs(avg(id2)) from md_double2);
select if (count(*) = 9, 'ok', 'nok') from md_double1;
select if (count(*) = 11, 'ok', 'nok') from md_double2;



drop table md_double1, md_double2;







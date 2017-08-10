--delete from 2 tables with datetime type column for join condition



create table md_datetime1(id1 double, col1 datetime not null default CURRENT_TIMESTAMP unique);
insert into md_datetime1 values(1111111.11111, '2011-09-01 12:12:12.999'), (2222222.22222, '2011-09-01 12:12:13.999'), (33333333.33333, '2011-09-01 12:12:14.999'), (4444444.44444, '2011-09-01 12:12:15.999'), (5555555.55555, '2011-09-01 12:12:16.999'), (6666666.66666, '2011-09-01 12:12:17.999'), (7777777.77777, '2011-10-10 1:1:1.999'), (8888888.88888, '2011-10-10 2:2:2.999'), (9999999.99999, '2011-11-11 11:11:11.999'), (1010101010.123, '2012-12-12 8:8:8.999');


create table md_datetime2(col1 varchar(1024), id2 double, col2 datetime, index i(col1, col2));
insert into md_datetime2 values('cubrid', 1234.12345, '2011-09-01 12:12:12.999'), ('abc', 3333333456.34555, '2011-09-01 12:12:12.999'), ('a', 55555.55555, '2011-09-01 12:12:13.999'), ('abcabc', 4444444.12345, '2011-09-01 12:12:13.999'), ('aa', 5555.1234, '2011-09-01 12:12:14.999'), ('mysql', 2222222.22222, '2011-09-01 12:12:14.999');
insert into md_datetime2 values('cubridcubrid', 666.6666, '2020-12-12 1:1:1.999'), ('mysqlmysql', 44444.44444444, '1988-10-10 2:2:2.999'), ('aaaa', 5555656.56565, '2011-09-01 12:12:17.999'), ('abcabcabc', 6666666.66666, '2011-10-10 2:2:2.999'), ('hello', 777777777.88777, '1988-10-10 3:3:3.999'), ('hellohello', 90000.909, '2012-12-12 8:8:8.999');


select * from md_datetime1 order by 1;
select * from md_datetime2 order by 1;


--error, false join condition
delete from m1 using md_datetime1 m1, md_datetime2 m2 where m2.col1=m1.col1;


--without table aliases, no matched results
delete from md_datetime1 using md_datetime1, md_datetime2 where md_datetime1.col1=md_datetime2.col2 and truncate(md_datetime1.id1, 2)=truncate(md_datetime2.id2, 2);
select if (count(*) = 10, 'ok', 'nok') from md_datetime1;
select if (count(*) = 12, 'ok', 'nok') from md_datetime2;


--with table aliases
delete from m2 using (select id1, col1 from (select * from md_datetime1 where month(col1)=9) md1) m1, md_datetime2 m2 where m1.col1=m2.col2 and (m2.id2>3333333456 or m2.id2<1235);
select if (count(*) = 10, 'ok', 'nok') from md_datetime1;
select * from md_datetime2 order by 1;


--inner join, 1 row deleted
delete from m1 using md_datetime1 as m1 inner join (select id2, substr(col1, 1, 6), col2 from md_datetime2) m2 on m1.col1=m2.col2 where m1.id1 > (select sum(id2)/5 from md_datetime2);
select * from md_datetime1 order by 1;
select if (count(*) = 10, 'ok', 'nok') from md_datetime2;


--left outer join
--success, 2 rows deleted
delete from m1 using md_datetime2 m2 left outer join md_datetime1 m1 on m1.col1=m2.col2 where m1.id1 > (select max(id2)/100 from md_datetime2);
select * from md_datetime1 order by 1;
select if (count(*) = 10, 'ok', 'nok') from md_datetime2;


--right outer join
--success, 4 rows deleted
delete from m2 using md_datetime2 m2 right outer join (select round(id1) as id1, col1 from md_datetime1 where length(col1) < 100) m1 on time(m1.col1)=time(m2.col2);
select if (count(*) = 7, 'ok', 'nok') from md_datetime1;
select if (count(*) = 6, 'ok', 'nok') from md_datetime2;



drop table md_datetime1, md_datetime2;







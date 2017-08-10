--delete from 2 tables with timestamp type column for join condition



create table md_timestamp1(id1 double, col1 timestamp not null default CURRENT_TIMESTAMP unique);
insert into md_timestamp1 values(1111111.11111, '2011-09-01 12:12:12'), (2222222.22222, '2011-09-01 12:12:13'), (33333333.33333, '2011-09-01 12:12:14'), (4444444.44444, '2011-09-01 12:12:15'), (5555555.55555, '2011-09-01 12:12:16'), (6666666.66666, '2011-09-01 12:12:17'), (7777777.77777, '2011-10-10 1:1:1'), (8888888.88888, '2011-10-10 2:2:2'), (9999999.99999, '2011-11-11 11:11:11'), (1010101010.123, '2012-12-12 8:8:8');


create table md_timestamp2(col1 varchar(1024), id2 double, col2 timestamp, index i(col1, col2));
insert into md_timestamp2 values('cubrid', 1234.12345, '2011-09-01 12:12:12'), ('abc', 3333333456.34555, '2011-09-01 12:12:12'), ('a', 55555.55555, '2011-09-01 12:12:13'), ('abcabc', 4444444.12345, '2011-09-01 12:12:13'), ('aa', 5555.1234, '2011-09-01 12:12:14'), ('mysql', 2222222.22222, '2011-09-01 12:12:14');
insert into md_timestamp2 values('cubridcubrid', 666.6666, '2020-12-12 1:1:1'), ('mysqlmysql', 44444.44444444, '1988-10-10 2:2:2'), ('aaaa', 5555656.56565, '2011-09-01 12:12:17'), ('abcabcabc', 6666666.66666, '2011-10-10 2:2:2'), ('hello', 777777777.88777, '1988-10-10 3:3:3'), ('hellohello', 90000.909, '2012-12-12 8:8:8');


select * from md_timestamp1 order by 1;
select * from md_timestamp2 order by 1;


--TEST: error, false join condition
delete from m1 using md_timestamp1 m1, md_timestamp2 m2 where m2.col1=m1.col1;


--TEST: without table aliases, no matched results
delete from md_timestamp1 using md_timestamp1, md_timestamp2 where md_timestamp1.col1=md_timestamp2.col2 and truncate(md_timestamp1.id1, 2)=truncate(md_timestamp2.id2, 2);
select if (count(*) = 10, 'ok', 'nok') from md_timestamp1;
select if (count(*) = 12, 'ok', 'nok') from md_timestamp2;


--TEST: with table aliases
delete from m2 using (select id1, col1 from (select * from md_timestamp1 where month(col1)=9) md1) m1, md_timestamp2 m2 where m1.col1=m2.col2 and (m2.id2>3333333456 or m2.id2<1235);
select if (count(*) = 10, 'ok', 'nok') from md_timestamp1;
select * from md_timestamp2 order by 1;


--TEST: inner join, 1 row deleted
delete from m1 using md_timestamp1 as m1 inner join (select id2, substr(col1, 1, 6), col2 from md_timestamp2) m2 on m1.col1=m2.col2 where m1.id1 > (select sum(id2)/5 from md_timestamp2);
select * from md_timestamp1 order by 1;
select if (count(*) = 10, 'ok', 'nok') from md_timestamp2;

--TEST: left outer join, delete and select from the same table
delete from m1, m2 using md_timestamp2 m2 left outer join md_timestamp1 m1 on m1.col1=m2.col2 where m1.id1 > (select max(id1)/3 from md_timestamp1);
select if (count(*) = 8, 'ok', 'nok') from md_timestamp1;
select if (count(*) = 8, 'ok', 'nok') from md_timestamp2;


--TEST: right outer join
delete from m2, m1 using md_timestamp1 m1 right outer join md_timestamp2 m2 on m1.col1=m2.col2 where m1.id1 < (select abs(avg(id2)) from md_timestamp2);
select if (count(*) = 5, 'ok', 'nok') from md_timestamp1;
select if (count(*) = 4, 'ok', 'nok') from md_timestamp2;



drop table md_timestamp1, md_timestamp2;







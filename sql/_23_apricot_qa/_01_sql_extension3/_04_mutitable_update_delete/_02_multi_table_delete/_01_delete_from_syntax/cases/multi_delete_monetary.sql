--TEST: delete from 2 tables with monetary type column for join condition, with composed index



create table md_monetary1(id1 monetary primary key, col1 timestamp not null default CURRENT_TIMESTAMP);
insert into md_monetary1 values(11111.11111, '2011-09-01 12:12:12'), (22222.22222, '2011-09-01 12:13:13'), (33333.33333, '2011-09-01 12:14:14'), (44444.44444, '2011-09-01 12:15:15'), (55555.55555, '2011-09-01 12:16:16'), (66666.66666, '2011-09-01 12:17:17');


create table md_monetary2(col1 varchar(30), id2 monetary, index i(col1 desc));
insert into md_monetary2 values('cubrid', 1234.12345), ('abc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_monetary2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_monetary1 order by 1;
select * from md_monetary2 order by 1;


--TEST: error, false join condition
delete m1 from md_monetary1 m1, md_monetary2 m2 where m1.col1=m2.col1;


--TEST: without table aliases
delete md_monetary1 from md_monetary1, md_monetary2 where md_monetary1.id1=md_monetary2.id2 and minute(md_monetary1.col1) < 14;
select * from md_monetary1 order by 1;
select if (count(*) = 12, 'ok', 'nok') from md_monetary2;


--TEST: with table aliases
delete m2 from md_monetary1 m1, md_monetary2 m2 where m1.id1=m2.id2 and time(m1.col1) <= '12:15:16' and last_day(m1.col1) = '2011-09-30';
select if (count(*) = 5, 'ok', 'nok') from md_monetary1;
select * from md_monetary2 order by 1;


--TEST: error, delete from a derived table
delete m1, m2 from (select id1, adddate(col1, 10) from md_monetary1) as m1 inner join (select id2, substr(col1, 1, 6) from md_monetary2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
--TEST: inner join, no matched results
delete m1 from (select id1, adddate(col1, 10) from md_monetary1) as m1 inner join (select id2, substr(col1, 1, 6) from md_monetary2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
select if (count(*) = 5, 'ok', 'nok') from md_monetary1;
select if (count(*) = 11, 'ok', 'nok') from md_monetary2;


--TEST: left outer join, delete and select from the same table
delete m1, md_monetary2 from md_monetary2 left outer join md_monetary1 m1 on m1.id1=md_monetary2.id2 where m1.id1 > (select avg(id1) from md_monetary1);
select if (count(*) = 3, 'ok', 'nok') from md_monetary1;
select * from md_monetary2 order by 1;


--TEST: right outer join
delete m2, m1 from md_monetary1 m1 right outer join md_monetary2 m2 on m1.id1=m2.id2 where m1.id1 < (select abs(avg(id2)) from md_monetary2);
select if (count(*) = 3, 'ok', 'nok') from md_monetary1;
select if (count(*) = 9, 'ok', 'nok') from md_monetary2;



drop table md_monetary1, md_monetary2;







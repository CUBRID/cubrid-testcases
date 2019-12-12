--TEST: delete from 2 tables with numeric type column for join condition, with composed index



create table md_numeric1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP);
insert into md_numeric1 values(11111.11111, '2011-09-01 12:12:12'), (22222.22222, '2011-09-01 12:12:13'), (33333.33333, '2011-09-01 12:12:14'), (44444.44444, '2011-09-01 12:12:15'), (55555.55555, '2011-09-01 12:12:16'), (66666.66666, '2011-09-01 12:12:17');


create table md_numeric2(col1 varchar(1024), id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_numeric2 values('cubrid', 1234.12345), ('abc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_numeric2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_numeric1 order by 1;
select * from md_numeric2 order by 1;


--TEST: error, false join condition
delete m1, m2 from md_numeric1 m1, md_numeric2 m2 where m1.id1=m2.col1;


--TEST: without table aliases
delete md_numeric1 from md_numeric1, md_numeric2 where md_numeric1.id1=md_numeric2.id2 and char_length(md_numeric2.col1) < 5;
select * from md_numeric1 order by 1;
select if (count(*) = 12, 'ok', 'nok') from md_numeric2;


--TEST: with table aliases
delete m2 from md_numeric1 m1, md_numeric2 m2 where m1.id1=m2.id2 and m1.col1='2011-09-01 12:12:13';
select if (count(*) = 5, 'ok', 'nok') from md_numeric1;
select * from md_numeric2 order by 1;


--TEST: error, delete from a derived table
delete m1, m2 from md_numeric1 as m1 inner join (select id2, substr(col1, 1, 6) from md_numeric2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
--TEST: inner join, no matched results
delete m1 from md_numeric1 as m1 inner join (select id2, substr(col1, 1, 6) from md_numeric2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
select if (count(*) = 5, 'ok', 'nok') from md_numeric1;
select if (count(*) = 11, 'ok', 'nok') from md_numeric2;


--TEST: left outer join, delete and select from the same table
delete m1, md_numeric2 from md_numeric1 m1 left outer join md_numeric2 on m1.id1=md_numeric2.id2 where m1.id1 > (select avg(id1) from md_numeric1);
select if (count(*) = 3, 'ok', 'nok') from md_numeric1;
select * from md_numeric2 order by 1;


--TEST: right outer join
--TEST: delete and select from the same table
delete m1, m2 from md_numeric1 m1 right outer join md_numeric2 m2 on m1.id1=m2.id2 where m1.id1 < (select abs(avg(id2)) from md_numeric2);
select if (count(*) = 3, 'ok', 'nok') from md_numeric1;
select if (count(*) = 9, 'ok', 'nok') from md_numeric2;



drop table md_numeric1, md_numeric2;







--delete from 1 normal table and 1 table with subclass



create table md_float1(id1 float, col1 timestamp not null default CURRENT_TIMESTAMP);
insert into md_float1 values(11111.11111, '2011-09-01 12:12:12'), (22222.22222, '2011-09-01 12:12:13'), (333333.33333, '2011-09-01 12:12:14'), (44444.44444, '2011-09-01 12:12:15'), (55555.55555, '2011-09-01 12:12:16'), (66666.66666, '2011-09-01 12:12:17');


create table md_float2(col1 varchar(1024), id2 float, index i(id2 desc, col1));
insert into md_float2 values('cubrid', 1234.12345), ('abc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_float2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);

--create subclass
create table sub_md_float2 under md_float2(col2 int, col3 time not null);
insert into sub_md_float2 values('abcd', 1234.5678, 567, '17:18:19');


select * from md_float1 order by 1;
select * from md_float2 order by 1;


--TEST: error, false join condition
delete m1 from md_float1 m1, md_float2 m2 where m2.id2=m1.col1;


--TEST: without table aliases, 1 row deleted
delete md_float1 from md_float1, md_float2 where md_float1.id1=md_float2.id2 and second(md_float1.col1) < 14;
select * from md_float1 order by 1;
select if (count(*) = 12, 'ok', 'nok') from md_float2;


--TEST: with table aliases
delete m2 from md_float1 m1, md_float2 m2 where m1.id1=m2.id2 and time(m1.col1) <= '12:12:15';
select if (count(*) = 5, 'ok', 'nok') from md_float1;
select * from md_float2 order by 1;


--TEST: error, inner join, delete from a derived table
delete m1, m2 from md_float1 as m1 inner join (select id2, substr(col1, 1, 6) from md_float2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
select if (count(*) = 5, 'ok', 'nok') from md_float1;
select if (count(*) = 11, 'ok', 'nok') from md_float2;


--TEST: left outer join, success
delete m1, m2 from md_float2 m2 left outer join md_float1 m1 on m1.id1=m2.id2 where m1.id1 > (select abs(avg(id2)) from md_float2);
select if (count(*) = 3, 'ok', 'nok') from md_float1;
select if (count(*) = 9, 'ok', 'nok') from md_float2;


--TEST: right outer join
--TEST: delete and select from the same table, no matched rows
delete m2, m1 from md_float1 m1 right outer join md_float2 m2 on m1.id1=m2.id2 where m1.id1 < (select abs(avg(id2)) from md_float2);
select if (count(*) = 3, 'ok', 'nok') from md_float1;
select if (count(*) = 9, 'ok', 'nok') from md_float2;



drop table md_float1, md_float2, sub_md_float2;







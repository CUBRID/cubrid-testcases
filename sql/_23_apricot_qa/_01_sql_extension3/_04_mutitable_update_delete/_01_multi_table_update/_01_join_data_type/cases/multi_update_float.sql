--TEST: update 2 tables with float type column for join condition, with composed index



create table md_float1(id1 float, col1 timestamp not null default CURRENT_TIMESTAMP);
insert into md_float1 values(11111.11111, '2011-09-01 12:12:12'), (22222.22222, '2011-09-01 12:12:13'), (333333.33333, '2011-09-01 12:12:14'), (44444.44444, '2011-09-01 12:12:15'), (55555.55555, '2011-09-01 12:12:16'), (66666.66666, '2011-09-01 12:12:17');


create table md_float2(col1 varchar(255), id2 float, index i(id2 desc, col1));
insert into md_float2 values('cubrid', 1234.12345), ('abc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_float2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_float1 order by 1;
select * from md_float2 order by 1;


--TEST: error, false join condition, 0 rows updated
update md_float1 m1, md_float2 m2 set m1.col1=CURRENT_TIMESTAMP where m2.id2=m1.col1;


--TEST: without table aliases, 2 rows updated
update md_float1, md_float2 set md_float1.col1=timestamp('2000-10-10 10:10:10'), md_float2.col1='updated1' where md_float1.id1=md_float2.id2 and second(md_float1.col1) < 14;
--TEST: check update result
select if (col1 = '2000-10-10 10:10:10', 'ok', 'nok') from md_float1 where id1=22222.22222;
select if (col1 = 'updated1', 'ok', 'nok') from md_float2 where id2=22222.22222;


--TEST: with table aliases, 2 rows updated
update md_float1 m1, md_float2 m2 set m2.id2=second(m1.col1)+m1.id1, m2.col1=last_day(m1.col1) where m1.id1=m2.id2 and time(m1.col1) <= '12:12:15';
--TEST: check update result
select if (count(*) = 0, 'ok', 'nok') from md_float1 m1, md_float2 m2 where m1.id1=m2.id2 and time(m1.col1) <= '12:12:15';
select if (count(*) = 2, 'ok', 'nok') from md_float2 where col1 in ('10/31/2000', '09/30/2011');


--TEST: inner join, no matched results
update md_float1 as m1 inner join (select id2, substr(col1, 1, 6) from md_float2  where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2 set m1.id1=m2.id2*10000000000000;


--TEST: left outer join, update and select from the same table, 2 rows updated
update md_float2 m2 left outer join md_float1 m1 on m1.id1=m2.id2 set m2.col1=m1.col1 where m1.id1 > (select avg(id2) from md_float2);
--TEST: check the result
select case when count(*)=2 then 'ok' else 'nok' end from md_float2 where length(col1)=22;
--TEST: error, with limit syntax
update md_float2 m2 left outer join md_float1 m1 on m1.id1=m2.id2 set m2.col1='updated2' where m1.id1 > (select avg(id2) from md_float2) limit 1;
--TEST: set with invalid value
update md_float2 m2 left outer join md_float1 m1 on m2.id2=m1.id1 set m1.id1=m2.col1 where m1.id1 > (select avg(id2) from md_float2);
--TEST: check the result
select * from md_float1 order by 1;


--TEST: right outer join
--TEST: update and select from the same table, 2 rows updated.
update md_float1 m1 right outer join md_float2 m2 on m1.id1=m2.id2 set m1.id1=m2.id2/100 where m2.id2 < (select abs(avg(id1)) from md_float1);
--TEST: set value with implicit type conversion
update md_float1 m1 right outer join md_float2 m2 on m1.id1=m2.id2 set m2.col1=m2.col1+'abc' where m2.id2 < (select abs(avg(id1)) from md_float1);
--TEST: check the result
select case when count(*)=11 then 'ok' else 'nok' end from md_float2 where col1 like '%abc';
select * from md_float1 order by 1;



drop table md_float1, md_float2;







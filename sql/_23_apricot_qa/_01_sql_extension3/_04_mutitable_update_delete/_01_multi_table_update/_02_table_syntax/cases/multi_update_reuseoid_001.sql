--update 2 tables with reuse_oid option 



create table md_numeric1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP) reuse_oid;
insert into md_numeric1 values(11111.11111, '2011-09-01 12:12:12'), (22222.22222, '2011-09-01 12:12:13'), (33333.33333, '2011-09-01 12:12:14'), (44444.44444, '2011-09-01 12:12:15'), (55555.55555, '2011-09-01 12:12:16'), (66666.66666, '2011-09-01 12:12:17');


create table md_numeric2(col1 varchar(225), id2 numeric(10, 5), index i(id2 desc, col1)) reuse_oid;
insert into md_numeric2 values('cubrid', 1234.12345), ('abc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_numeric2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_numeric1 order by 1;
select * from md_numeric2 order by 1;


--TEST: error, false join condition, ok in mysql, no rows are updated
update md_numeric1 m1, md_numeric2 m2 set m1.col1=CURRENT_TIMESTAMP where m1.id1=m2.col1;


--TEST: without table aliases, 1 rows updated
update md_numeric1, md_numeric2 set md_numeric1.col1=md_numeric1.col1 + 3 where md_numeric1.id1=md_numeric2.id2 and char_length(md_numeric2.col1) < 5;
--TEST: check update result
select if (md_numeric1.col1 = '2011-09-01 12:12:19', 'ok', 'nok') from md_numeric1, md_numeric2 where md_numeric1.id1=md_numeric2.id2 and char_length(md_numeric2.col1) < 5;


--TEST: with table aliases, 1 row updated
update md_numeric1 m1, md_numeric2 m2 set m2.col1=repeat(m2.col1, 2) where m1.id1=m2.id2 and m1.col1='2011-09-01 12:12:13';
--TEST: check update result
select if (m2.col1 = 'mysqlmysql', 'ok', 'nok') from md_numeric1 m1, md_numeric2 m2 where m1.id1=m2.id2 and m1.col1='2011-09-01 12:12:13';


--TEST: inner join, no matched results, no rows updated
update md_numeric1 as m1 inner join (select id2, substr(col1, 1, 6) from md_numeric2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2 set m1.id1=1.1111111111;


--TEST: success, 4 rows updated
update md_numeric1 m1 left outer join md_numeric2 on m1.id1=md_numeric2.id2 set m1.id1=md_numeric2.id2 + 11111.11111, md_numeric2.id2=m1.id1/2 where m1.col1 < '2011-09-01 12:12:15';
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_numeric1 where id1 is null;
select if (count(*) = 1, 'ok', 'nok') from md_numeric2 where id2=11111.11111;
--TEST: no rows updated
update md_numeric1 m1 left outer join md_numeric2 on m1.id1=md_numeric2.id2 set md_numeric2.col1='updated1', md_numeric2.id2=m1.id1 where m1.id1 = 33333.33333;
select if (count(*) = 12, 'ok', 'nok') from md_numeric2;


--TEST: right outer join
--TEST: update and select from the same table, no rows updated.
update md_numeric1 m1 right outer join md_numeric2 m2 on m1.id1=m2.id2 set m2.col1='updated1' where m1.id1 < (select abs(avg(id2)) from md_numeric2);
--TEST: success
update md_numeric1 m1 right outer join md_numeric2 m2 on m1.id1=m2.id2 set m1.id1=m2.id2+1111.11111, m2.col1='updated1';
select * from md_numeric1 order by 1, 2;
select if (count(*) = 12, 'ok', 'nok') from md_numeric2 where col1='updated1';



drop table md_numeric1, md_numeric2;







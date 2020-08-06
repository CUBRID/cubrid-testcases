--TEST: delete from 2 tables with reuse_oid option

drop table if exists md_ro1;
drop table if exists md_ro2;

create table md_ro1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 varchar primary key) reuse_oid;
insert into md_ro1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table md_ro2(col1 char(10), id2 numeric(10, 5), index i(id2 desc, col1)) reuse_oid;
insert into md_ro2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_ro2 values('cubridcubr', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_ro1 order by 1;
select * from md_ro2 order by 1;


--TEST: error, false join condition
delete m1, m2 from md_ro1 m1, md_ro2 m2 where m1.col2=m2.id2;


--TEST: without table aliases, 1 row deleted in eache table
delete md_ro1, md_ro2 from md_ro1, md_ro2 where md_ro1.col2=md_ro2.col1 and char_length(md_ro1.col1) > 5 and md_ro1.id1=md_ro2.id2;
select * from md_ro1 order by 1;
select * from md_ro2 order by 1;


--TEST: with table aliases, 2 rows deleted
delete m2 from md_ro1 m1, md_ro2 m2 where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
select if (count(*) = 5, 'ok', 'nok') from md_ro1;
select * from md_ro2 order by 1;


--TEST: insert after delete
insert into md_ro1 values(88888.88888, '2011-09-01 12:12:18', 'hellohellohello'), (88888.88888, '2011-09-01 12:12:18', 'aabb');
insert into md_ro2 values('abcabc', 88888.88888);


--TEST: inner join, 4 rows deleted
delete m2 from md_ro2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_ro1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3);
select if (count(*) = 7, 'ok', 'nok') from md_ro1;
select * from md_ro2 order by 1;


--TEST: insert after delete
insert into md_ro2 values('aaabbb', 88888.88888), ('abcd', 88888.88888);


--TEST: success, 5 rows deleted
delete m1, m2 from md_ro1 m1 left outer join md_ro2 m2 on m1.col2=m2.col1 where m1.id1 > (select abs(avg(id2)) from md_ro2);
select * from md_ro1 order by 1;
select if (count(*) = 8, 'ok', 'nok') from md_ro2;


--TEST: insert after delete
insert into md_ro1 values(88888.88888, '2011-09-01 12:12:18', 'hellohello'), (88888.88888, '2011-09-01 12:12:18', 'aaccbb');


--TEST: right outer join
--TEST: delete and select from the same table, no matched rows
delete m1, m2 from md_ro1 m1 right outer join md_ro2 m2 on m1.col2=m2.col1 where m1.id1 < (select abs(avg(id2)) from md_ro2);
--TEST: success, 4 rows deleted
delete m2 from md_ro1 m1 right outer join md_ro2 m2 on m1.col2=m2.col1 where m2.id2 < (select avg(id1) from md_ro1);
select if (count(*) = 4, 'ok', 'nok') from md_ro1;
select if (count(*) = 4, 'ok', 'nok') from md_ro2;



drop table md_ro1, md_ro2;







--TEST: delete from 2 tables with trigger
--TEST: 1 trigger for each table
--TEST: trigger action: insert



create table md_trigg1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 char(50) primary key);
insert into md_trigg1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table md_trigg2(col1 varchar(1024), id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_trigg2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_trigg2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_trigg1 order by 1;
select * from md_trigg2 order by 1;


--TEST: create trigger action tables
create table action1(a int primary key auto_increment, b char(20));
create table action2(a int primary key auto_increment, b char(20));


--TEST: create triggers
create trigger bef_del before delete on md_trigg1
execute insert into action1(b) values('BEFORE DELETE');

create trigger aft_del after delete on md_trigg2
execute insert into action2(b) values('AFTER DELETE');


--TEST: error, false join condition
delete m1, m2 from md_trigg1 m1, md_trigg2 m2 where m1.col2=m2.id2;
--TEST: TEST: no trigger actions
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: without table aliases, 1 row deleted in each table
delete md_trigg1, md_trigg2 from md_trigg1, md_trigg2 where md_trigg1.col2=md_trigg2.col1 and char_length(md_trigg1.col1) > 5 and md_trigg1.id1=md_trigg2.id2;
select * from md_trigg1 order by 1;
select * from md_trigg2 order by 1;
--TEST: TEST: trigger actions
select if (count(*) = 1, 'ok', 'nok') from action1;
select if (count(*) = 1, 'ok', 'nok') from action2;


--TEST: with table aliases, 2 rows deleted
delete m2 from md_trigg1 m1, md_trigg2 m2 where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
select if (count(*) = 5, 'ok', 'nok') from md_trigg1;
select * from md_trigg2 order by 1;
--TEST: TEST: trigger actions
select if (count(*) = 1, 'ok', 'nok') from action1;
select if (count(*) = 3, 'ok', 'nok') from action2;


--TEST: inner join, 3 rows deleted
delete m2 from md_trigg2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_trigg1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3);
select if (count(*) = 5, 'ok', 'nok') from md_trigg1;
select * from md_trigg2 order by 1;
--TEST: TEST: trigger actions
select if (count(*) = 1, 'ok', 'nok') from action1;
select if (count(*) = 6, 'ok', 'nok') from action2;


--TEST: left outer join, delete and select from the same table
delete m1, md_trigg2 from md_trigg1 m1 left outer join md_trigg2 on m1.col2=md_trigg2.col1 where m1.id1 > (select avg(id1) from md_trigg1);
select if (count(*) = 2, 'ok', 'nok') from md_trigg1;
select if (count(*) = 5, 'ok', 'nok') from md_trigg2;
--TEST: TEST: no trigger actions
select if (count(*) = 4, 'ok', 'nok') from action1;
select if (count(*) = 7, 'ok', 'nok') from action2;


--TEST: right outer join
--TEST: delete and select from the same table
delete m1, m2 from md_trigg1 m1 right outer join md_trigg2 m2 on m1.col2=m2.col1 where m1.id1 < (select abs(avg(id2)) from md_trigg2);
select if (count(*) = 2, 'ok', 'nok') from md_trigg1;
select if (count(*) = 5, 'ok', 'nok') from md_trigg2;
--TEST: TEST: no trigger actions
select if (count(*) = 4, 'ok', 'nok') from action1;
select if (count(*) = 7, 'ok', 'nok') from action2;


drop trigger bef_del, aft_del;
drop table md_trigg1, md_trigg2, action1, action2;







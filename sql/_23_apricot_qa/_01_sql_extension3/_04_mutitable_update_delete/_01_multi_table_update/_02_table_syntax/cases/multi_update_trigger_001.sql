--update 2 tables with trigger
--1 trigger for each table
--trigger action: insert



create table md_trigg1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 varchar(990) primary key);
insert into md_trigg1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table md_trigg2(col1 varchar(100), id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_trigg2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_trigg2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_trigg1 order by 1;
select * from md_trigg2 order by 1, 2;


--create trigger action tables
create table action1(a int primary key auto_increment, b char(20));
create table action2(a int primary key auto_increment, b char(20));


--create triggers
create trigger bef_upd before update on md_trigg1
execute insert into action1(b) values('BEFORE UPDATE');

create trigger aft_upd after update on md_trigg2
execute insert into action2(b) values('AFTER UPDATE');


--TEST: error, false join condition
update md_trigg1 m1, md_trigg2 m2 set m1.col2='updated1' where m1.col2=m2.id2;
--TEST: no trigger actions
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: error, without table aliases, set with invalid value
update md_trigg1, md_trigg2 set md_trigg1.id1=floor(md_trigg2.id2)+md_trigg1.id1, md_trigg2.id2=md_trigg2.id2/mod(md_trigg1.id1, 2) where md_trigg1.col2=md_trigg2.col1 and char_length(md_trigg1.col1) > 5 and md_trigg1.id1=md_trigg2.id2;
--TEST: no trigger actions
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: with table aliases, 4 rows updated
update md_trigg1 m1, md_trigg2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1='updated1' where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_trigg1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_trigg2 where col1='updated1';
--TEST: trigger actions
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 2, 'ok', 'nok') from action2;


--TEST: inner join, 3 rows updated
update md_trigg2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_trigg1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=m1.id1;
--TEST: check update result
select if (id2 in (99999.99999, 66666.66666), 'ok', 'nok') from md_trigg2 where left(col1, 3)='abc';
--TEST: trigger actions
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 5, 'ok', 'nok') from action2;


--TEST: [er], left outer join, pk violation error
update md_trigg1 m1 left outer join md_trigg2 on m1.col2=md_trigg2.col1 set m1.col2='updated2', md_trigg2.col1=m1.col2 where m1.id1 > (select avg(id1) from md_trigg1);
--TEST: trigger actions
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 5, 'ok', 'nok') from action2;


--TEST: right outer join
--TEST: success, 7 rows updated
update md_trigg1 m1 right outer join md_trigg2 m2 on m1.col2=m2.col1 set m2.col1='updated3', m2.id2=m1.id1 where m2.id2 < (select avg(id1) from md_trigg1);
--TEST: check update result
select if (count(*) = 6, 'ok', 'nok') from md_trigg2 where col1='updated3';
select if (count(*) = 5, 'ok', 'nok') from md_trigg2 where id2 is null;
--TEST: trigger actions
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 11, 'ok', 'nok') from action2;



drop trigger bef_upd, aft_upd;
drop table md_trigg1, md_trigg2, action1, action2;







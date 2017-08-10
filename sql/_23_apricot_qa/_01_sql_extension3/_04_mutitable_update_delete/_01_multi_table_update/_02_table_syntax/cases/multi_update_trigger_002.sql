--update 2 tables with trigger in autocommit off mode
--1 trigger for each table
--trigger action: insert

autocommit off;


create table md_clob1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 clob);
insert into md_clob1 values(11111.11111, '2011-09-01 12:12:12', char_to_clob('cubrid')), (22222.22222, '2011-09-01 12:12:13', char_to_clob('mysql')), (33333.33333, '2011-09-01 12:12:14', char_to_clob('abc')), (44444.44444, '2011-09-01 12:12:15', char_to_clob('cubridcubrid')), (55555.55555, '2011-09-01 12:12:16', char_to_clob('mysqlmysql')), (66666.66666, '2011-09-01 12:12:17', char_to_clob('abcabc'));


create table md_clob2(col1 clob, id2 numeric(10, 5));
insert into md_clob2 values(char_to_clob('cubrid'), 1234.12345), (char_to_clob('abcabc'), 3456.34555), (char_to_clob('a'), 55555.55555), (char_to_clob('abcabc'), 444.12345), (char_to_clob('aa'), 5555.1234), (char_to_clob('mysql'), 22222.22222);
insert into md_clob2 values(char_to_clob('cubridcubrid'), 666.6666), (char_to_clob('mysqlmysql'), 44444.44444), (char_to_clob('aaaa'), 5656.56565), (char_to_clob('abcabcabc'), 66666.66666), (char_to_clob('hello'), 77.88777), (char_to_clob('hellohello'), 90000.909);


select id1, col1, clob_to_char(col2) from md_clob1 order by 1;
select clob_to_char(col1), id2 from md_clob2 order by 1, 2;


--create trigger action tables
create table action1(a int primary key auto_increment, b char(20));
create table action2(a int primary key auto_increment, b char(20));


--create triggers
create trigger bef_upd before update on md_clob1
execute insert into action1(b) values('BEFORE UPDATE');

create trigger aft_upd after update on md_clob2
execute insert into action2(b) values('AFTER UPDATE');


--TEST: error, false join condition
update md_clob1 m1, md_clob2 m2 set clob_to_char(m1.col2)='updated1' where clob_to_char(m1.col2)=m2.id2;
--TEST: no trigger actions
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;
commit;
--TEST: check data after commit
select if (count(*) = 0, 'ok', 'nok') from md_clob1 where clob_to_char(col2)='updated1';


--TEST: error, without table aliases, set with invalid value
update md_clob1, md_clob2 set md_clob1.id1=floor(md_clob2.id2)+md_clob1.id1, md_clob2.id2=md_clob2.id2/mod(md_clob1.id1, 2) where clob_to_char(md_clob1.col2)=clob_to_char(md_clob2.col1) and clob_length(md_clob1.col1) > 5 and md_clob1.id1=md_clob2.id2;
--TEST: no trigger actions
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: with table aliases, 4 rows updated
update md_clob1 m1, md_clob2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1=char_to_clob('updated1') where clob_to_char(m1.col2)=clob_to_char(m2.col1) and round(m2.id2) in (1234, 5555, 5657, 667);
--TEST: check update result before rollback
select if (count(*) = 2, 'ok', 'nok') from md_clob1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_clob2 where clob_to_char(col1)='updated1';
--TEST: check trigger actions before rollback
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 2, 'ok', 'nok') from action2;
rollback;
--TEST: check update result after rollback
select if (count(*) = 0, 'ok', 'nok') from md_clob2 where clob_to_char(col1)='updated1';
--TEST: check trigger actions after rollback
select if (count(*) = 0, 'ok', 'nok') from action1;
select if (count(*) = 0, 'ok', 'nok') from action2;


--TEST: with table aliases, 4 rows updated
update md_clob1 m1, md_clob2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1=char_to_clob('updated1') where clob_to_char(m1.col2)=clob_to_char(m2.col1) and round(m2.id2) in (1234, 5555, 5657, 667);
commit;
--TEST: check update result after commit
select if (count(*) = 2, 'ok', 'nok') from md_clob1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_clob2 where clob_to_char(col1)='updated1';
--TEST: check trigger actions after commit
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 2, 'ok', 'nok') from action2;


--TEST: inner join, 6 rows updated
update md_clob2 as m2 inner join (select id1, trim(substr(clob_to_char(col2), 1, 6)) as col2 from md_clob1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(clob_to_char(m2.col1), 3) set m2.id2=m1.id1;
commit;
--TEST: check update result
select if (id2 in (66666.66666, 33333.33333), 'ok', 'nok') from md_clob2 where left(clob_to_char(col1), 3)='abc';
--TEST: check trigger actions after commit
select if (count(*) = 2, 'ok', 'nok') from action1;
select if (count(*) = 5, 'ok', 'nok') from action2;


--TEST: 6 rows updated
update md_clob1 m1 left outer join md_clob2 on clob_to_char(md_clob2.col1)=clob_to_char(m1.col2) set m1.col2=char_to_clob('updated2'), md_clob2.col1=char_to_clob('updated2'), m1.id1=md_clob2.id2 where m1.id1 > (select avg(id1) from md_clob1);
commit;
--TEST: check the result
select case when id1 in (33333.33333, 66666.66666, 44444.44444) or id1 is null then 'ok' else 'nok' end from md_clob1 where clob_to_char(col2)='updated2';
select case when count(*)=3 then 'ok' else 'nok' end from md_clob2 where clob_to_char(col1)='updated2';
--TEST: check trigger actions after commit
select if (count(*) = 5, 'ok', 'nok') from action1;
select if (count(*) = 8, 'ok', 'nok') from action2;


--TEST: right outer join
--TEST: success, 7 rows updated
update md_clob1 m1 right outer join md_clob2 m2 on clob_to_char(m1.col2)=clob_to_char(m2.col1) set m2.col1=char_to_clob('updated3'), m2.id2=m1.id1, m1.id1=m2.id2 where m2.id2 < (select avg(id1) from md_clob1);
commit;
--TEST: check update result
select if (count(*) = 6, 'ok', 'nok') from md_clob2 where clob_to_char(col1)='updated3';
select if (count(*) = 5, 'ok', 'nok') from md_clob2 where id2 is null;
--TEST: check trigger actions after commit
select if (count(*) = 6, 'ok', 'nok') from action1;
select if (count(*) = 14, 'ok', 'nok') from action2;


delete m1, m2 from md_clob1 m1, md_clob2 m2;

drop trigger bef_upd, aft_upd;
drop table md_clob1, md_clob2, action1, action2;
autocommit on;







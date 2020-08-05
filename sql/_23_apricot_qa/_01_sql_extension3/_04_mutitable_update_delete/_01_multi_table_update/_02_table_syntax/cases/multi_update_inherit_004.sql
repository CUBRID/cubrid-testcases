--update 1 class and its subclass



--create super class
create table md_bit1(id2 smallint, col1 bigint, col3 char(100));
insert into md_bit1 values(2, 5, 'cubrid'), (4, 10, 'mysql'), (6, 13, 'abc'), (8, 22, 'hello'), (10, 45, 'aaa'), (12, 57, 'mysqlmysql'), (11, 4444, 'oracle'), (232, 787878343, 'mysqlmysql'), (7584, 2304203400, 'sqlite');


--create subclass
create table md_bit2 under md_bit1(col2 bit(64) primary key);
insert into md_bit2 values(2, 5, 'mydql', B'1'), (4, 10, 'abc', B'11'), (6, 13, 'aa', B'1101'), (8, 22, 'cubrid', B'10111'), (10, 45, 'sqlite', B'10001'), (12, 57, 'hello', B'10101');


select * from md_bit1 order by 1;
select * from md_bit2 order by 1;



--TEST: without table aliases, non-equijoin, 2 rows updated
update md_bit1, md_bit2 set md_bit1.col3='updated1', md_bit2.col3='updated1' where md_bit1.id2=md_bit2.col1;
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_bit1 where col3='updated1';
select if (count(*) = 1, 'ok', 'nok') from md_bit2 where col3='updated1';


--TEST: update and select from the same table, no matched rows
update md_bit1, md_bit2 set md_bit2.col1=md_bit1.col1 where md_bit1.col1 > (select min(col2) from md_bit2) and md_bit1.col3='lll';


--TEST: with table aliases, derived table, 3 rows updated
update (select id2, col3 from md_bit1) as m1, md_bit2 m2 set m2.col3=m1.col3 where m1.id2=m2.id2 and bit_count(m2.id2)=2;
--TEST: check update result
select if (m1.col3 = m2.col3, 'ok', 'nok') from (select id2, col3 from md_bit1) as m1, md_bit2 m2 where m1.id2=m2.id2 and bit_count(m2.id2)=2;


--TEST: inner join, no matched results
update md_bit1 as m1 inner join md_bit2 as m2 on m1.col1=m2.id2 set m2.col3='updated1' where m2.col1 > (select 100);


--TEST: left outer join, one table with an alias and the other without
--TEST: update and select from the same table
update all md_bit1 m1 left outer join md_bit2 m2 on m1.col3=m2.col3 set m2.col2=m2.col2, m1.col3='updated2' where m1.id2 < (select count(concat(m1.col1, m2.col1)) from md_bit1 m1 inner join md_bit2 m2 on m1.id2=m2.id2);
--TEST: check the result
select case when count(*)=2 then 'ok' else 'nok' end from md_bit1 where col3='updated2';
select case when count(*)=2 then 'ok' else 'nok' end from md_bit2 where col3='updated2';


--TEST: right outer join
--TEST: success,  rows updated
update md_bit1 m1 right outer join md_bit2 m2 on m1.col3=m2.col3 set m1.col3='updated3', m2.col3='updated3', m2.col1=m1.id2+m2.col1 where m1.id2 > (select count(concat(col3, 'a')) from md_bit2 m2 where id2 < 4);
select case when count(*)=6 then 'ok' else 'nok' end from md_bit1 where col3='updated3';
select case when count(*)=5 then 'ok' else 'nok' end from md_bit2 where col3='updated3';


drop table md_bit1, md_bit2;







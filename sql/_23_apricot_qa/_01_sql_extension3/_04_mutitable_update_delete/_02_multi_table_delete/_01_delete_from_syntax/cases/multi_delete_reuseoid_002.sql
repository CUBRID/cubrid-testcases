--delete from 2 tables, 1 of which is with reuse_oid option



create table md_ro1(id1 smallint primary key, col1 char(20), col2 bit(10));
insert into md_ro1 values(1, 'aaa', B'1010'), (2, 'bbb', B'1101'), (3, 'ccc', B'1011'), (4, 'ddd', B'1110'), (5, 'eee', B'10010'), (6, 'fff', B'10101');
insert into md_ro1 values(7, 'ggg', B'101'), (8, 'hhh', B'110'), (9, 'iii', B'111'), (10, 'jjj', B'10111'), (11, 'kkk', B'11001'), (12, 'lll', B'10001');


create table md_ro2(id2 smallint, col1 bigint, col2 bit(10) primary key) reuse_oid;
insert into md_ro2 values(2, 5, B'1'), (4, 10, B'11'), (6, 13, B'1101'), (8, 22, B'10111'), (10, 45, B'10001'), (12, 57, B'10101');


select * from md_ro1 order by 1;
select * from md_ro2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row deleted
delete md_ro1 from md_ro1, md_ro2 where md_ro1.col2 > (select min(col2) from md_ro2) and md_ro1.col1='lll';
select * from md_ro1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_ro2;


--TEST: delete and select from the same table, no matched rows
delete md_ro1, md_ro2 from md_ro1, md_ro2 where md_ro1.col2 > (select min(col2) from md_ro2) and md_ro1.col1='lll';
select if (count(*) = 11, 'ok', 'nok') from md_ro1;
select if (count(*) = 6, 'ok', 'nok') from md_ro2;


--insert after delete
insert into md_ro1 values(18, 'mmm', B'11111'), (17, 'nnn', B'10101');
insert into md_ro2 values(1, 4, B'1011'), (3, 2, B'11111');



--TEST: with delete from 3 tables with bit(n) type column for join conditiontable aliases, derived table, 2 rows deleted
delete m2 from (select id1, col2 from md_ro1) as m1, md_ro2 m2 where m1.col2=m2.col2 and bit_count(m2.id2)=2;
select if (count(*) = 13, 'ok', 'nok') from md_ro1;
select * from md_ro2 order by 1;


--TEST: inner join, no matched results
delete m1 from md_ro1 as m1 inner join md_ro2 as m2 on m1.col2=m2.col2 where m2.col1 > (select 100);
select if (count(*) = 13, 'ok', 'nok') from md_ro1;
select if (count(*) = 5, 'ok', 'nok') from md_ro2;


--insert after delete
insert into md_ro1 values(16, 'mmm', B'11111'), (15, 'nnn', B'10101'), (14, 'ccc', B'1011');


--TEST: left outer join, one table with an alias and the other without
--TEST: delete and select from the same table
delete m1, md_ro2 from md_ro1 m1 left outer join md_ro2 on m1.col2=md_ro2.col2 where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_ro1 m1 inner join md_ro2 m2 on m1.id1=m2.id2);
select if (count(*) = 12, 'ok', 'nok') from md_ro1;
select if (count(*) = 4, 'ok', 'nok') from md_ro2;


--TEST: right outer join
--TEST: success, 4 rows deleted
delete m1, m2 from md_ro1 m1 right outer join md_ro2 m2 on m1.col2=m2.col2 where m1.id1 > (select count(concat(col1, 'a')) from md_ro2 m2 where id2 < 4);
select if (count(*) = 10, 'ok', 'nok') from md_ro1;
select if (count(*) = 2, 'ok', 'nok') from md_ro2;


drop table md_ro1, md_ro2;







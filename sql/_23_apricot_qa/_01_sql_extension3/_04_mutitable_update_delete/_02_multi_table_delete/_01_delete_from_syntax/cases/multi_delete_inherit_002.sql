--delete from 1 normal table and 1 table with superclass



create table md_varbit1(id1 smallint primary key, col1 char(20), col2 bit varying(10));
insert into md_varbit1 values(1, 'aaa', B'1010'), (2, 'bbb', B'1101'), (3, 'ccc', B'1011'), (4, 'ddd', B'1110'), (5, 'eee', B'10010'), (6, 'fff', B'10101');
insert into md_varbit1 values(7, 'ggg', B'101'), (8, 'hhh', B'110'), (9, 'iii', B'111'), (10, 'jjj', B'10111'), (11, 'kkk', B'11001'), (12, 'lll', B'10001');

--create super class
create table super_md_varbit2(id2 smallint, col1 bigint);
insert into super_md_varbit2 values(1, 8), (10, 99);

--create sub class
create table md_varbit2 under super_md_varbit2(col2 bit varying(10) primary key);
insert into md_varbit2 values(2, 5, B'1'), (4, 10, B'11'), (6, 13, B'1101'), (8, 22, B'10111'), (10, 45, B'10001'), (12, 57, B'10101');


select * from md_varbit1 order by 1;
select * from md_varbit2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row deleted
delete md_varbit1 from md_varbit1, md_varbit2 where md_varbit1.col2 > (select min(col2) from md_varbit2) and md_varbit1.col1='lll';
select * from md_varbit1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_varbit2;


--TEST: delete and select from the same table, no matched rows
delete md_varbit1, md_varbit2 from md_varbit1, md_varbit2 where md_varbit1.col2 > (select min(col2) from md_varbit2) and md_varbit1.col1='lll';
select if (count(*) = 11, 'ok', 'nok') from md_varbit1;
select if (count(*) = 6, 'ok', 'nok') from md_varbit2;


--TEST: with table aliases, derived table, 2 rows deleted
delete m2 from (select id1, col2 from md_varbit1) as m1, md_varbit2 m2 where m1.col2=m2.col2 and bit_count(m2.id2)=2;
select if (count(*) = 11, 'ok', 'nok') from md_varbit1;
select * from md_varbit2 order by 1;


--TEST: inner join, no matched results
delete m1 from md_varbit1 as m1 inner join md_varbit2 as m2 on m1.col2=m2.col2 where m2.col1 > (select 100);
select if (count(*) = 11, 'ok', 'nok') from md_varbit1;
select if (count(*) = 4, 'ok', 'nok') from md_varbit2;


--TEST: left outer join, one table with an alias and the other without
--TEST: delete and select from the same table
delete m1, md_varbit2 from md_varbit1 m1 left outer join md_varbit2 on m1.col2=md_varbit2.col2 where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_varbit1 m1 inner join md_varbit2 m2 on m1.id1=m2.id2);
select if (count(*) = 8, 'ok', 'nok') from md_varbit1;
select if (count(*) = 4, 'ok', 'nok') from md_varbit2;


--TEST: right outer join
--TEST: success, 4 rows deleted
delete m1, m2 from md_varbit1 m1 right outer join md_varbit2 m2 on m1.col2=m2.col2 where m1.id1 > (select count(concat(col1, 'a')) from md_varbit2 m2 where id2 < 4);
select if (count(*) = 6, 'ok', 'nok') from md_varbit1;
select if (count(*) = 2, 'ok', 'nok') from md_varbit2;



drop table md_varbit1, md_varbit2, super_md_varbit2;







--TEST: delete from 2 tables with smallint type column for join condition



create table md_smallint1(id1 smallint primary key, col1 char(20));
insert into md_smallint1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_smallint1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_smallint2(id2 smallint, col1 bigint);
insert into md_smallint2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


select * from md_smallint1 order by 1;
select * from md_smallint2 order by 1;


--TEST: without table aliases, non-equijoin
delete md_smallint1 from md_smallint1, md_smallint2 where md_smallint1.id1 > (select min(col1) from md_smallint2) and md_smallint1.col1='lll';
--TEST: error, delete and select from the same table
delete md_smallint1, md_smallint2 from md_smallint1, md_smallint2 where md_smallint1.id1 > (select min(col1) from md_smallint2) and md_smallint1.col1='lll';
select * from md_smallint1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_smallint2;


--TEST: with table aliases, derived table
delete m2 from (select id1, col1 from md_smallint1) as m1, md_smallint2 m2 where m1.id1=m2.id2 and m1.col1='fff';
select if (count(*) = 11, 'ok', 'nok') from md_smallint1;
select * from md_smallint2 order by 1;


--TEST: inner join, no matched results
delete m1, m2 from md_smallint1 as m1 inner join md_smallint2 as m2 on m1.id1=m2.id2 where m2.col1 > 100;
--TEST: error, duplicated table name
delete m1, m2, m1, m1, m1 from md_smallint1 as m1 inner join md_smallint2 as m2 on m1.id1=m2.id2 where m2.col1 > 100;
select if (count(*) = 11, 'ok', 'nok') from md_smallint1;
select if (count(*) = 5, 'ok', 'nok') from md_smallint2;


--TEST: left outer join, one table with an alias and the other without
delete m1, md_smallint2 from md_smallint1 m1 left outer join md_smallint2 on m1.id1=md_smallint2.id2 where m1.id1 > (select avg(id1) from md_smallint1);
select if (count(*) = 6, 'ok', 'nok') from md_smallint1;
select * from md_smallint2 order by 1;


--TEST: right outer join
delete m1, m2 from md_smallint1 m1 right outer join md_smallint2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_smallint2);
select if (count(*) = 4, 'ok', 'nok') from md_smallint1;
select if (count(*) = 1, 'ok', 'nok') from md_smallint2;



drop table md_smallint1, md_smallint2;







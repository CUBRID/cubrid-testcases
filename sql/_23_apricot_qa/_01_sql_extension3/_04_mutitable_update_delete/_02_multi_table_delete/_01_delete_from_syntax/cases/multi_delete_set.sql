--TEST: delete from 2 tables with set type column for join condition



create table md_set1(col1 set(date, int), col2 char(20));
insert into md_set1 values({date'1999-01-01', 1, 2}, 'aaa'), ({1, date'2000-01-01', 2}, 'bbb'), ({1, 2, date'2001-01-01'}, 'ccc'), ({1, '2002-01-01', 2}, 'ddd'), ({'2003-01-01', 1, 2}, 'eee'), ({1, 2, '2004-01-01'}, 'fff');
insert into md_set1 values({date'2005-12-12', 2, 1}, 'ggg'), ({2, '2006-12-12', 1}, 'hhh'), ({2, 1, '2007-12-12'}, 'iii'), ({1, '2008-12-12', 2}, 'jjj'), ({'2009-12-12', 1, 2}, 'kkk'), ({1, 2, date'2010-12-12'}, 'lll');


create table md_set2(id int primary key, col1 smallint, col2 set(int, date));
insert into md_set2 values(2, 5, {1, 2, date'2000-01-01'}), (4, 10, {2, '2000-01-01', 1}), (6, 13, {2, 1, '2007-12-12'}), (8, 22, {'2012-12-12', 2, 1}), (10, 45, {1, date'2001-01-01', 2}), (12, 57, {2, '2010-12-12', 1}), (14, 88, {'1998-01-01', 2, 1});


select * from md_set1 order by 1, 2;
select * from md_set2 order by 1, 2;


--TEST:  without table aliases, 1 matched row in one table and 2 matched rows in the other, 2 rows deleted 
delete md_set2 from md_set1, md_set2 where md_set1.col1=md_set2.col2 and md_set1.col1={1, date'2000-01-01', 2};
select if (count(*) = 12, 'ok', 'nok') from md_set1;
select * from md_set2 order by 1, 2;


--TEST:  with table aliases, 1 row deleted
delete m1 from md_set1 m1, (select id, col1, col2 from md_set2) m2 where m1.col1=m2.col2 and m2.col1 < 20;
select * from md_set1 order by 1, 2;
select if (count(*) = 5, 'ok', 'nok') from md_set2;


--TEST:  inner join, 2 rows deleted
delete m1, m2 from md_set1 as m1 inner join md_set2 as m2 on m1.col1=m2.col2 where m1.col2='ccc';
select * from md_set1 order by 1, 2;
select * from md_set2 order by 1, 2;


--TEST:  left outer join, one table with an alias and the other without
delete m1, md_set2 from md_set1 m1 left outer join md_set2 on m1.col1=md_set2.col2 where md_set2.id > (select avg(id) from md_set2);
select if (count(*) = 9, 'ok', 'nok') from md_set1;
select if (count(*) = 3, 'ok', 'nok') from md_set2;


--TEST:  right outer join
delete m1, m2 from md_set1 m1 right outer join md_set2 m2 on m1.col1=m2.col2 where m2.col1 < (select avg(id) from md_set2);
select if (count(*) = 9, 'ok', 'nok') from md_set1;
select if (count(*) = 3, 'ok', 'nok') from md_set2;



drop table md_set1, md_set2;







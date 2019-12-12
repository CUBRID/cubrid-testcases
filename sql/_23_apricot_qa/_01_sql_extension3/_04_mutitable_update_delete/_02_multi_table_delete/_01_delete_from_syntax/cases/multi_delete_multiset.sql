--delete from 2 tables with multiset type column for join condition



create table md_multiset1(col1 multiset(date, int), col2 char(20));
insert into md_multiset1 values({1, 2, date'1888-11-11', date'1999-01-01', 1, 2}, 'aaa'), ({1, 2, date'1888-11-11', 1, date'2000-01-01', 2}, 'bbb'), ({1, 2, date'1888-11-11', 1, 2, date'2001-01-01'}, 'ccc'), ({1, 2, date'1888-11-11', 1, '2002-01-01', 2}, 'ddd'), ({1, 2, date'1888-11-11', '2003-01-01', 1, 2}, 'eee'), ({1, 2, date'1888-11-11', 1, 2, '2004-01-01'}, 'fff');
insert into md_multiset1 values({1, 2, date'1888-11-11', date'2005-12-12', 2, 1}, 'ggg'), ({1, 2, date'1888-11-11', 2, '2006-12-12', 1}, 'hhh'), ({1, 2, date'1888-11-11', 2, 1, '2007-12-12'}, 'iii'), ({1, 2, date'1888-11-11', 1, '2008-12-12', 2}, 'jjj'), ({1, 2, date'1888-11-11', '2009-12-12', 1, 2}, 'kkk'), ({1, 2, date'1888-11-11', 1, 2, date'2010-12-12'}, 'lll');


create table md_multiset2(id int primary key, col1 smallint, col2 multiset(int, date));
insert into md_multiset2 values(2, 5, {1, 2, date'1888-11-11', 1, 2, date'2000-01-01'}), (4, 10, {1, 2, date'1888-11-11', 2, '2000-01-01', 1}), (6, 13, {1, 2, date'1888-11-11', 2, 1, '2007-12-12'}), (8, 22, {1, 2, date'1888-11-11', '2012-12-12', 2, 1}), (10, 45, {1, 2, date'1888-11-11', 1, date'2001-01-01', 2}), (12, 57, {1, 2, date'1888-11-11', 2, '2010-12-12', 1}), (14, 88, {1, 2, date'1888-11-11', '1998-01-01', 2, 1});


select * from md_multiset1 order by 1, 2;
select * from md_multiset2 order by 1, 2;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 2 rows deleted 
delete md_multiset2 from md_multiset1, md_multiset2 where md_multiset1.col1=md_multiset2.col2 and md_multiset1.col1={1, 2, date'1888-11-11', 1, date'2000-01-01', 2};
select if (count(*) = 12, 'ok', 'nok') from md_multiset1;
select * from md_multiset2 order by 1, 2;


--TEST: with table aliases, 1 row deleted
delete m1 from md_multiset1 m1, (select id, col1, col2 from md_multiset2) m2 where m1.col1=m2.col2 and m2.col1 < 20;
select * from md_multiset1 order by 1, 2;
select if (count(*) = 5, 'ok', 'nok') from md_multiset2;


--TEST: inner join, 1 row deleted
delete m1, m2 from md_multiset1 as m1 inner join md_multiset2 as m2 on m1.col1=m2.col2 where m1.col2='ccc';
select * from md_multiset1 order by 1, 2;
select * from md_multiset2 order by 1, 2;


--TEST: left outer join, one table with an alias and the other without
delete m1, md_multiset2 from md_multiset1 m1 left outer join md_multiset2 on m1.col1=md_multiset2.col2 where md_multiset2.id > (select avg(id) from md_multiset2);
select if (count(*) = 9, 'ok', 'nok') from md_multiset1;
select if (count(*) = 3, 'ok', 'nok') from md_multiset2;


--TEST: right outer join
--TEST: delete and select from the same table
delete m1, m2 from md_multiset1 m1 right outer join md_multiset2 m2 on m1.col1=m2.col2 where m2.col1 < (select avg(id) from md_multiset2);
select if (count(*) = 9, 'ok', 'nok') from md_multiset1;
select if (count(*) = 3, 'ok', 'nok') from md_multiset2;



drop table md_multiset1, md_multiset2;







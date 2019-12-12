--delete from 2 tables with list type column for join condition



create table md_list1(col1 list(date, int), col2 char(20));
insert into md_list1 values({date'1999-01-01', 1, 2}, 'aaa'), ({date'2000-01-01', 1, 2}, 'bbb'), ({date'2001-01-01', 1, 2}, 'ccc'), ({'2002-01-01', 1, 2}, 'ddd'), ({'2003-01-01', 1, 2}, 'eee'), ({'2004-01-01', 1, 2}, 'fff');
insert into md_list1 values({date'2005-12-12', 1, 2}, 'ggg'), ({'2006-12-12', 1, 2}, 'hhh'), ({'2007-12-12', 1, 2}, 'iii'), ({'2008-12-12', 1, 2}, 'jjj'), ({'2009-12-12', 1, 2}, 'kkk'), ({date'2010-12-12', 1, 2}, 'lll');


create table md_list2(id int primary key, col1 smallint, col2 list(int, date));
insert into md_list2 values(2, 5, {date'2000-01-01', 1, 2}), (4, 10, {'2000-01-01', 1, 2}), (6, 13, {'2007-12-12', 1, 2}), (8, 22, {'2012-12-12', 1, 2}), (10, 45, {date'2001-01-01',1, 2}), (12, 57, {'2010-12-12', 1, 2}), (14, 88, {'1998-01-01', 1, 2});


select * from md_list1 order by 1;
select * from md_list2 order by 1;


--without table aliases, 1 matched row in one table and 2 matched rows in the other, 2 rows deleted 
delete md_list2 from md_list1, md_list2 where md_list1.col1=md_list2.col2 and md_list1.col1={date'2000-01-01', 1, 2};
select if (count(*) = 12, 'ok', 'nok') from md_list1;
select * from md_list2 order by 1;


--with table aliases, 1 row deleted
delete m1 from md_list1 m1, (select id, col1, col2 from md_list2) m2 where m1.col1=m2.col2 and m2.col1 < 20;
select * from md_list1 order by 1;
select if (count(*) = 5, 'ok', 'nok') from md_list2;


--inner join, 1 row deleted
delete m1, m2 from md_list1 as m1 inner join md_list2 as m2 on m1.col1=m2.col2 where m1.col2='ccc';
select * from md_list1 order by 1;
select * from md_list2 order by 1;


--left outer join, one table with an alias and the other without
--delete and select from the same table
delete m1, md_list2 from md_list1 m1 left outer join md_list2 on m1.col1=md_list2.col2 where md_list2.id > (select avg(id) from md_list2);
select if (count(*) = 9, 'ok', 'nok') from md_list1;
select if (count(*) = 3, 'ok', 'nok') from md_list2;


--right outer join
--delete and select from the same table
delete m1, m2 from md_list1 m1 right outer join md_list2 m2 on m1.col1=m2.col2 where m2.col1 < (select avg(id) from md_list2);
select if (count(*) = 9, 'ok', 'nok') from md_list1;
select if (count(*) = 3, 'ok', 'nok') from md_list2;



drop table md_list1, md_list2;







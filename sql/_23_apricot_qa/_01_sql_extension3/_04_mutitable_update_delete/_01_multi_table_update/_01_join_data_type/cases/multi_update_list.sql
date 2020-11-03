--update 2 tables with list type column for join condition



create table md_list1(col1 list(date, int), col2 varchar(20));
insert into md_list1 values({date'1999-01-01', 1, 2}, 'aaa'), ({date'2000-01-01', 1, 2}, 'bbb'), ({date'2001-01-01', 1, 2}, 'ccc'), ({'2002-01-01', 1, 2}, 'ddd'), ({'2003-01-01', 1, 2}, 'eee'), ({'2004-01-01', 1, 2}, 'fff');
insert into md_list1 values({date'2005-12-12', 1, 2}, 'ggg'), ({'2006-12-12', 1, 2}, 'hhh'), ({'2007-12-12', 1, 2}, 'iii'), ({'2008-12-12', 1, 2}, 'jjj'), ({'2009-12-12', 1, 2}, 'kkk'), ({date'2010-12-12', 1, 2}, 'lll');


create table md_list2(id int primary key, col1 smallint, col2 list(int, date), col3 varchar(1024));
insert into md_list2 values(2, 5, {date'2000-01-01', 1, 2}, 'cubrid'), (4, 10, {'2000-01-01', 1, 2}, 'mysql'), (6, 13, {'2007-12-12', 1, 2}, 'abc'), (8, 22, {'2012-12-12', 1, 2}, 'aaa'), (10, 45, {date'2001-01-01',1, 2}, 'hello'), (12, 57, {'2010-12-12', 1, 2}, 'sqlite'), (14, 88, {'1998-01-01', 1, 2}, 'oracle');


select * from md_list1 order by 1;
select * from md_list2 order by 1;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 3 rows matched, 1 row updated 
update md_list1, md_list2 set md_list1.col2=md_list2.col3, md_list2.col1=floor(md_list2.col1) where md_list1.col1=md_list2.col2 and md_list1.col1={date'2000-01-01', 1, 2};
--TEST: check update result
select if (col2 in ('cubrid', 'mysql'), 'ok', 'nok') from md_list1 where md_list1.col1={date'2000-01-01', 1, 2};


--TEST: with table aliases, 2 rows updated
update md_list1 m1, (select id, col1, col2 from md_list2) m2 set m1.col2='updated1', m1.col1=m1.col1+m2.col2 where m1.col1=m2.col2 and m2.col1 < 20;
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_list1 where col2='updated1';


--TEST: inner join, 1 row updated
update md_list1 as m1 inner join md_list2 as m2 on m1.col1=m2.col2 set m2.col3=m1.col2, m1.col1=m2.col2-m1.col1, m2.col2=m1.col1 where m1.col2='ccc';
--TEST: check update result
select if (col1 = {}, 'ok', 'nok') from md_list1 where col2='ccc';
select if (col2 = {date'2001-01-01', 1, 2}, 'ok', 'nok') from md_list2 where col3='ccc';


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 1 row updated
update md_list1 m1 left outer join md_list2 m2 on m1.col1=m2.col2 set m1.col2=concat(trim(m1.col2), m2.col3), m1.col1=m2.col2*m1.col1 where m2.id > (select avg(id) from md_list2);
--TEST: check update result
select if (col2 = 'lllsqlite', 'ok', 'nok') from md_list1 where col1={1, 2, date'2010-12-12'};


--TEST: right outer join
--TEST: success, 7 rows updated
update md_list1 m1 right outer join md_list2 m2 on m1.col1=m2.col2 set m2.col3='updated3', m2.col2=m1.col1+m2.col2 where m2.col1 > (select min(id) from md_list2);
--TEST: check update result
select if (count(*) = 7, 'ok', 'nok') from md_list2 where col3='updated3';
select if (count(*) = 7, 'ok', 'nok') from md_list2 where col2 is null;



drop table md_list1, md_list2;







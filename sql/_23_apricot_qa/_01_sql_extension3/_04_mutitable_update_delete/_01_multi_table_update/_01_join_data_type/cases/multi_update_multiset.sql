--update 2 tables with multiset type column for join condition



create table md_multiset1(col1 multiset(date, int), col2 varchar(20));
insert into md_multiset1 values({1, 2, date'1888-11-11', date'1999-01-01', 1, 2}, 'aaa'), ({1, 2, date'1888-11-11', 1, date'2000-01-01', 2}, 'bbb'), ({1, 2, date'1888-11-11', 1, 2, date'2001-01-01'}, 'ccc'), ({1, 2, date'1888-11-11', 1, '2002-01-01', 2}, 'ddd'), ({1, 2, date'1888-11-11', '2003-01-01', 1, 2}, 'eee'), ({1, 2, date'1888-11-11', 1, 2, '2004-01-01'}, 'fff');
insert into md_multiset1 values({1, 2, date'1888-11-11', date'2005-12-12', 2, 1}, 'ggg'), ({1, 2, date'1888-11-11', 2, '2006-12-12', 1}, 'hhh'), ({1, 2, date'1888-11-11', 2, 1, '2007-12-12'}, 'iii'), ({1, 2, date'1888-11-11', 1, '2008-12-12', 2}, 'jjj'), ({1, 2, date'1888-11-11', '2009-12-12', 1, 2}, 'kkk'), ({1, 2, date'1888-11-11', 1, 2, date'2010-12-12'}, 'lll');

create table md_multiset2(id int primary key, col1 smallint, col2 multiset(int, date), col3 varchar);
insert into md_multiset2 values(2, 5, {1, 2, date'1888-11-11', 1, 2, date'2000-01-01'}, 'cubrid'), (4, 10, {1, 2, date'1888-11-11', 2, '2000-01-01', 1}, 'mysql'), (6, 13, {1, 2, date'1888-11-11', 2, 1, '2007-12-12'}, 'abc'), (8, 22, {1, 2, date'1888-11-11', '2012-12-12', 2, 1}, 'aaa'), (10, 45, {1, 2, date'1888-11-11', 1, date'2001-01-01', 2}, 'hello'), (12, 57, {1, 2, date'1888-11-11', 2, '2010-12-12', 1}, 'sqlite'), (14, 88, {1, 2, date'1888-11-11', '1998-01-01', 2, 1}, 'oracle');


select * from md_multiset1 order by 1, 2;
select * from md_multiset2 order by 1, 2;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 3 rows matched, 1 row updated 
update md_multiset1, md_multiset2 set md_multiset1.col2=md_multiset2.col3, md_multiset2.col1=floor(md_multiset2.col1) where md_multiset1.col1=md_multiset2.col2 and md_multiset1.col1={1, 1, 2, 2, date'11/11/1888', date'01/01/2000'};
--TEST: check update result
select if (col2 in ('cubrid', 'mysql'), 'ok', 'nok') from md_multiset1 where md_multiset1.col1={1, 2, date'1888-11-11', 1, 2, date'2000-01-01'};


--TEST: with table aliases, 2 rows updated
update md_multiset1 m1, (select id, col1, col2 from md_multiset2) m2 set m1.col2='updated1', m1.col1=m1.col1+m2.col2 where m1.col1=m2.col2 and m2.col1 < 20;
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_multiset1 where col2='updated1';


--TEST: inner join, 1 row updated
update md_multiset1 as m1 inner join md_multiset2 as m2 on m1.col1=m2.col2 set m2.col3=m1.col2, m1.col1=m2.col2-m1.col1, m2.col2=m1.col1 where m1.col2='ccc';
--TEST: check update result
select if (col1 = {}, 'ok', 'nok') from md_multiset1 where col2='ccc';
select if (col2 = {1, 2, date'1888-11-11', 1, 2, date'2001-01-01'}, 'ok', 'nok') from md_multiset2 where col3='ccc';


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 2 rows updated
update md_multiset1 m1 left outer join md_multiset2 m2 on m1.col1=m2.col2 set m1.col2=concat(trim(m1.col2), m2.col3), m1.col1=m2.col2*m1.col1, m2.col3='updated2' where m2.id > (select avg(id) from md_multiset2);
--TEST: check update result
select if (col2 = 'lllsqlite', 'ok', 'nok') from md_multiset1 where col1={1, 2, date'1888-11-11', 2, date'2010-12-12', 1};
select if (count(*) = 1, 'ok', 'nok') from md_multiset2 where col3='updated2';


--TEST: right outer join
--TEST: success, 7 rows updated
update md_multiset1 m1 right outer join md_multiset2 m2 on m1.col1=m2.col2 set m2.col3='updated3', m2.col2=m1.col1+m2.col2 where m2.col1 > (select min(id) from md_multiset2);
--TEST: check update result
select if (count(*) = 7, 'ok', 'nok') from md_multiset2 where col3='updated3';
select if (count(*) = 6, 'ok', 'nok') from md_multiset2 where col2 is null;
select * from md_multiset2 order by 1, 2;



drop table md_multiset1, md_multiset2;







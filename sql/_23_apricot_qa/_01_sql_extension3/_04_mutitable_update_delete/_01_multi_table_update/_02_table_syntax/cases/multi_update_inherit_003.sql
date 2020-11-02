--update 2 subclasses


--create super class
create table super_md_set1(col1 set(date, int));
insert into super_md_set1 values({date'1999-01-01', 1, 2}), ({2, '2006-12-12', 1});

--create sub class
create table md_set1 under super_md_set1(col2 varchar(20));
insert into md_set1 values({date'1999-01-01', 1, 2}, 'aaa'), ({1, date'2000-01-01', 2}, 'bbb'), ({1, 2, date'2001-01-01'}, 'ccc'), ({1, '2002-01-01', 2}, 'ddd'), ({'2003-01-01', 1, 2}, 'eee'), ({1, 2, '2004-01-01'}, 'fff');
insert into md_set1 values({date'2005-12-12', 2, 1}, 'ggg'), ({2, '2006-12-12', 1}, 'hhh'), ({2, 1, '2007-12-12'}, 'iii'), ({1, '2008-12-12', 2}, 'jjj'), ({'2009-12-12', 1, 2}, 'kkk'), ({1, 2, date'2010-12-12'}, 'lll');


--create super class
create table super1_md_set2(id int, col1 smallint);
insert into super1_md_set2 values(6, 13), (10, 45);

--create 1-level sub class
create table super2_md_set2 under super1_md_set2(col2 set(int, date));
insert into super2_md_set2 values(12, 57, {2, '2010-12-12', 1}), (4, 10, {2, '2000-01-01', 1});

--create 2-level sub class
create table md_set2 under super2_md_set2(col3 varchar);
insert into md_set2 values(2, 5, {1, 2, date'2000-01-01'}, 'cubrid'), (4, 10, {2, '2000-01-01', 1}, 'mysql'), (6, 13, {2, 1, '2007-12-12'}, 'abc'), (8, 22, {'2012-12-12', 2, 1}, 'aaa'), (10, 45, {1, date'2001-01-01', 2}, 'hello'), (12, 57, {2, '2010-12-12', 1}, 'sqlite'), (14, 88, {'1998-01-01', 2, 1}, 'oracle');


select * from md_set1 order by 1;
select * from md_set2 order by 1;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 3 rows matched, 1 row updated 
update md_set1, md_set2 set md_set1.col2=md_set2.col3, md_set2.col1=floor(md_set2.col1) where md_set1.col1=md_set2.col2 and md_set1.col1={1, date'2000-01-01', 2};
--TEST: check update result
select if (col2 in ('cubrid', 'mysql'), 'ok', 'nok') from md_set1 where md_set1.col1={1, date'2000-01-01', 2};


--TEST: with table aliases, 2 rows updated
update md_set1 m1, (select id, col1, col2 from md_set2) m2 set m1.col2='updated1', m1.col1=m1.col1+m2.col2 where m1.col1=m2.col2 and m2.col1 < 20;
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_set1 where col2='updated1';


--TEST: inner join, 1 row updated
update md_set1 as m1 inner join md_set2 as m2 on m1.col1=m2.col2 set m2.col3=m1.col2, m1.col1=m2.col2-m1.col1, m2.col2=m1.col1 where m1.col2='ccc';
--TEST: check update result
select if (col1 = {}, 'ok', 'nok') from md_set1 where col2='ccc';
select if (col2 = {1, 2, date'2001-01-01'}, 'ok', 'nok') from md_set2 where col3='ccc';


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 2 rows updated
update md_set1 m1 left outer join md_set2 m2 on m1.col1=m2.col2 set m1.col2=concat(trim(m1.col2), m2.col3), m1.col1=m2.col2*m1.col1, m2.col1=100 where m2.id > (select avg(id) from md_set2);
--TEST: check update result
select if (col2 = 'lllsqlite', 'ok', 'nok') from md_set1 where col1={2, 1, date'2010-12-12'};
select if (col1 = 100, 'ok', 'nok') from md_set2 where col3='sqlite';


--TEST: right outer join
--TEST: success, 7 rows updated
update md_set1 m1 right outer join md_set2 m2 on m1.col1=m2.col2 set m2.col3='updated3', m2.col2=m1.col1+m2.col2, m1.col2='updated3' where m2.col1 > (select min(id) from md_set2);
--TEST: check update result
select if (count(*) = 7, 'ok', 'nok') from md_set2 where col3='updated3';
select if (count(*) = 3, 'ok', 'nok') from md_set2 where col2 is null;
select if (count(*) = 3, 'ok', 'nok') from md_set1 where col2='updated3';



drop table md_set1, super_md_set1;
drop table md_set2, super1_md_set2, super2_md_set2;







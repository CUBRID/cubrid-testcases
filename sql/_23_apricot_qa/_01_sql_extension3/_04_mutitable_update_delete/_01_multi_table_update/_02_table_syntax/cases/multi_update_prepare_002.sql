--update 2 tables with prepare statement



create table md_set1(col1 set(date, int), col2 varchar(20));

--insert with prepare statement
prepare stmt from 'insert into md_set1 values(?, ?)'
execute stmt using {date'1999-01-01', 1, 2}, 'aaa'
execute stmt using {1, date'2000-01-01', 2}, 'bbb'
execute stmt using {1, 2, date'2001-01-01'}, 'ccc'
execute stmt using {1, '2002-01-01', 2}, 'ddd'
execute stmt using {'2003-01-01', 1, 2}, 'eee'
execute stmt using {1, 2, '2004-01-01'}, 'fff'
execute stmt using {date'2005-12-12', 2, 1}, 'ggg'
execute stmt using {2, '2006-12-12', 1}, 'hhh'
execute stmt using {2, 1, '2007-12-12'}, 'iii'
execute stmt using {1, '2008-12-12', 2}, 'jjj'
execute stmt using {'2009-12-12', 1, 2}, 'kkk'
execute stmt using {1, 2, date'2010-12-12'}, 'lll'
deallocate prepare stmt;


create table md_set2(id int primary key, col1 smallint, col2 set(int, date), col3 varchar);

--insert with prepare statement
prepare stmt from 'insert into md_set2 values(?, ?, ?, ?)'
execute stmt using 2, 5, {1, 2, date'2000-01-01'}, 'cubrid'
execute stmt using 4, 10, {2, '2000-01-01', 1}, 'mysql'
execute stmt using 6, 13, {2, 1, '2007-12-12'}, 'abc'
execute stmt using 8, 22, {'2012-12-12', 2, 1}, 'aaa'
execute stmt using 10, 45, {1, date'2001-01-01', 2}, 'hello'
execute stmt using 12, 57, {2, '2010-12-12', 1}, 'sqlite'
execute stmt using 14, 88, {'1998-01-01', 2, 1}, 'oracle'
deallocate prepare stmt;


select * from md_set1 order by 1, 2;
select * from md_set2 order by 1, 2;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 3 rows matched, 1 row updated 
prepare stmt from 'update md_set1, md_set2 set md_set1.col2=md_set2.col3, md_set2.col1=floor(md_set2.col1) where md_set1.col1=md_set2.col2 and md_set1.col1=?';
execute stmt using {1, 2, date'2000-01-01'};
deallocate prepare stmt;
--TEST: check update result
select if (col2 in ('cubrid', 'mysql'), 'ok', 'nok') from md_set1 where md_set1.col1={1, date'2000-01-01', 2};


--TEST: with table aliases, 2 rows updated
prepare stmt from 'update md_set1 m1, (select id, col1, col2 from md_set2) m2 set m1.col2=?, m1.col1=m1.col1+m2.col2 where m1.col1=m2.col2 and m2.col1 < ?';
execute stmt using 'updated1', 20;
deallocate prepare stmt;
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_set1 where col2='updated1';


--TEST: inner join, 1 row updated
prepare stmt from 'update md_set1 as m1 inner join md_set2 as m2 on m1.col1=m2.col2 set m2.col3=m1.col2, m1.col1=m2.col2-m1.col1, m2.col2=m1.col1 where m1.col2=?';
execute stmt using 'ccc';
deallocate prepare stmt;
--TEST: check update result
select if (col1 = {}, 'ok', 'nok') from md_set1 where col2='ccc';
select if (col2 = {1, 2, date'2001-01-01'}, 'ok', 'nok') from md_set2 where col3='ccc';


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 1 row updated
prepare stmt from 'update md_set1 m1 left outer join md_set2 m2 on m1.col1=m2.col2 set m1.col2=concat(trim(m1.col2), m2.col3), m1.col1=m2.col2*m1.col1 where m2.id > (select avg(id) from md_set2)';
execute stmt;
deallocate prepare stmt;
--TEST: check update result
select if (col2 = 'lllsqlite', 'ok', 'nok') from md_set1 where col1={2, 1, date'2010-12-12'};


--TEST: right outer join
--TEST: success, 7 rows updated
prepare stmt from 'update md_set1 m1 right outer join md_set2 m2 on m1.col1=m2.col2 set m2.col3=?, m2.col2=m1.col1+m2.col2 where m2.col1 > (select min(id) from md_set2)';
execute stmt using 'updated3';
deallocate prepare stmt;
--TEST: check update result
select if (count(*) = 7, 'ok', 'nok') from md_set2 where col3='updated3';
select if (count(*) = 3, 'ok', 'nok') from md_set2 where col2 is null;



drop table md_set1, md_set2;







--delete from 2 tables with set type column for join condition



create table md_set1(col1 set(date, int), col2 char(20));

--insert with prepare statement
prepare stmt from 'insert into md_set1 values(?, ?)';
execute stmt using {date'1999-01-01', 1, 2}, 'aaa';
execute stmt using {1, date'2000-01-01', 2}, 'bbb';
execute stmt using {1, 2, date'2001-01-01'}, 'ccc';
execute stmt using {1, '2002-01-01', 2}, 'ddd';
execute stmt using {'2003-01-01', 1, 2}, 'eee';
execute stmt using {1, 2, '2004-01-01'}, 'fff';
execute stmt using {date'2005-12-12', 2, 1}, 'ggg';
execute stmt using {2, '2006-12-12', 1}, 'hhh';
execute stmt using {2, 1, '2007-12-12'}, 'iii';
execute stmt using {1, '2008-12-12', 2}, 'jjj';
execute stmt using {'2009-12-12', 1, 2}, 'kkk';
execute stmt using {1, 2, date'2010-12-12'}, 'lll';
deallocate prepare stmt;


create table md_set2(id int primary key, col1 smallint, col2 set(int, date));

--insert with prepare statement
prepare stmt from 'insert into md_set2 values(?, ?, ?)';
execute stmt using 2, 5, {1, 2, date'2000-01-01'};
execute stmt using 4, 10, {2, '2000-01-01', 1};
execute stmt using 6, 13, {2, 1, '2007-12-12'};
execute stmt using 8, 22, {'2012-12-12', 2, 1};
execute stmt using 10, 45, {1, date'2001-01-01', 2};
execute stmt using 12, 57, {2, '2010-12-12', 1};
execute stmt using 14, 88, {'1998-01-01', 2, 1};
deallocate prepare stmt;


select * from md_set1 order by 1, 2;
select * from md_set2 order by 1, 2;


--TEST: multi-table delete with prepare statement, without table aliases, 1 matched row in one table and 2 matched rows in the other, 2 rows deleted 
prepare stmt from 'delete from md_set2 using md_set1, md_set2 where md_set1.col1=md_set2.col2 and md_set1.col1=?';
execute stmt using {1, 2, date'2000-01-01'};
deallocate prepare stmt;
select if (count(*) = 12, 'ok', 'nok') from md_set1 order by 1;
select if (count(*) = 5, 'ok', 'nok') from md_set2 order by 1;


--TEST: multi-table delete with prepare statement, with table aliases, 1 row deleted
prepare stmt from 'delete from m1 using md_set1 m1, (select id, col1, col2 from md_set2) m2 where m1.col1=m2.col2 and m2.col1 < ?';
execute stmt using 20;
deallocate prepare stmt;
select if (count(*) = 11, 'ok', 'nok') from md_set1 order by 1;
select if (count(*) = 5, 'ok', 'nok') from md_set2 order by 1;


--TEST: multi-table delete with prepare statement, inner join, 1 row deleted
prepare stmt from 'delete from m1, m2 using md_set1 as m1 inner join md_set2 as m2 on m1.col1=m2.col2 where m1.col2=?';
execute stmt using 'ccc';
deallocate prepare stmt;
select if (count(*) = 10, 'ok', 'nok') from md_set1 order by 1;
select if (count(*) = 4, 'ok', 'nok') from md_set2 order by 1;


--TEST: multi-table delete with prepare statement, left outer join, one table with an alias and the other without
--TEST: multi-table delete with prepare statement, delete and select from the same table, 2 rows deleted
prepare stmt from 'delete from m1, md_set2 using md_set1 m1 left outer join md_set2 on m1.col1=md_set2.col2 where md_set2.id > (select avg(id) from md_set2)';
execute stmt;
deallocate prepare stmt;
select if (count(*) = 9, 'ok', 'nok') from md_set1 order by 1;
select if (count(*) = 3, 'ok', 'nok') from md_set2 order by 1;


--TEST: multi-table delete with prepare statement, right outer join
--TEST: multi-table delete with prepare statement, success, 3 rows deleted
prepare stmt from 'delete from m1, m2 using md_set1 m1 right outer join md_set2 m2 on m1.col1=m2.col2 where m2.col1 > (select avg(id) from md_set2)';
execute stmt;
deallocate prepare stmt;
select if (count(*) = 9, 'ok', 'nok') from md_set1 order by 1;
select if (count(*) = 0, 'ok', 'nok') from md_set2 order by 1;



drop table md_set1, md_set2;







--delete from 2 tables with date type column for join condition



create table md_date1(col1 date, col2 char(20));
insert into md_date1 values(date'1999-01-01', 'aaa'), (date'2000-01-01', 'bbb'), (date'2001-01-01', 'ccc'), ('2002-01-01', 'ddd'), ('2003-01-01', 'eee'), ('2004-01-01', 'fff');
insert into md_date1 values(date'2005-12-12', 'ggg'), ('2006-12-12', 'hhh'), ('2007-12-12', 'iii'), ('2008-12-12', 'jjj'), ('2009-12-12', 'kkk'), (date'2010-12-12', 'lll');


create table md_date2(id int primary key, col1 smallint, col2 date);
insert into md_date2 values(2, 5, date'2000-01-01'), (4, 10, '2000-01-01'), (6, 13, '2007-12-12'), (8, 22, '2012-12-12'), (10, 45, date'2001-01-01'), (12, 57, '2010-12-12'), (14, 88, '1998-01-01');


select * from md_date1 order by 1;
select * from md_date2 order by 1;


--without table aliases, 1 matched row in one table and 2 matched rows in the other, 2 rows deleted
delete from md_date2 using md_date1, md_date2 where md_date1.col1=md_date2.col2 and md_date1.col1=date'2000-01-01';
select if (count(*) = 12, 'ok', 'nok') from md_date1;
select * from md_date2 order by 1;


--with table aliases, 1 row deleted
delete from m1 using md_date1 m1, (select id, col1, col2 from md_date2) m2 where m1.col1=m2.col2 and m2.col1 < 20;
select * from md_date1 order by 1;
select if (count(*) = 5, 'ok', 'nok') from md_date2;


--inner join
delete from m1, m2 using md_date1 as m1 inner join md_date2 as m2 on m1.col1=m2.col2 where date_add(m1.col1, interval -2 day) < '2001-01-01';
select * from md_date1 order by 1;
select * from md_date2 order by 1;


--left outer join, one table with an alias and the other without
delete from m1, md_date2 using md_date1 m1 left outer join md_date2 on m1.col1=md_date2.col2 where md_date2.id > (select avg(id) from md_date2);
select * from md_date1 order by 1;
select if (count(*) = 3, 'ok', 'nok') from md_date2;


--right outer join
delete from m1, m2 using md_date1 m1 right outer join md_date2 m2 on m1.col1=m2.col2 where m2.col1 < (select avg(id) from md_date2);
select if (count(*) = 9, 'ok', 'nok') from md_date1;
select if (count(*) = 3, 'ok', 'nok') from md_date2;



drop table md_date1, md_date2;







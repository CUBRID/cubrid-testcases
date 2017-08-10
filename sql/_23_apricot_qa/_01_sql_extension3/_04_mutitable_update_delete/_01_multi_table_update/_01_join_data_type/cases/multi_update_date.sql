--update 2 tables with date type column for join condition



create table md_date1(col1 date, col2 char(20));
insert into md_date1 values(date'1999-01-01', 'aaa'), (date'2000-01-01', 'bbb'), (date'2001-01-01', 'ccc'), ('2002-01-01', 'ddd'), ('2003-01-01', 'eee'), ('2004-01-01', 'fff');
insert into md_date1 values(date'2005-12-12', 'ggg'), ('2006-12-12', 'hhh'), ('2007-12-12', 'iii'), ('2008-12-12', 'jjj'), ('2009-12-12', 'kkk'), (date'2010-12-12', 'lll');


create table md_date2(id int primary key, col1 smallint, col2 date);
insert into md_date2 values(2, 5, date'2000-01-01'), (4, 10, '2000-01-01'), (6, 13, '2007-12-12'), (8, 22, '2012-12-12'), (10, 45, date'2001-01-01'), (12, 57, '2010-12-12'), (14, 88, '1998-01-01');


select * from md_date1 order by 1;
select * from md_date2 order by 1;


--TEST: without table aliases, 1 matched row in one table and 2 matched rows in the other, 3 rows updated
update md_date1, md_date2 set md_date1.col2='updated1', md_date2.col1=md_date2.col1+5 where md_date1.col1=md_date2.col2 and md_date1.col1=date'2000-01-01';
--TEST: check update result 
select if (col2 = 'updated1', 'ok', 'nok') from md_date1 where col1='2000-01-01';
select if (col1 in (10, 15), 'ok', 'nok') from md_date2 where col2='2000-01-01';


--TEST: with table aliases, 2 rows updated
update md_date1 m1, (select id, col1, col2 from md_date2) m2 set m1.col2=m2.col1 where m1.col1=m2.col2 and m2.col1 < 20;
--TEST: check update result
select if (col2 in ('10', '15'), 'ok', 'nok') from md_date1 where col1='2000-01-01';
select if (col2 = '13', 'ok', 'nok') from md_date1 where col1='2007-12-12';


--TEST: inner join, 5 rows updated
update md_date1 as m1 inner join md_date2 as m2 on m1.col1=m2.col2 set m1.col2='updated2', m2.col2=date_add(m2.col2, interval 1 year) where date_add(m1.col1, interval -2 day) < '2001-01-01';
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_date1 where col2='updated2';
select if (count(*) = 2, 'ok', 'nok') from md_date2 where col2='2001-01-01';


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 4 rows updated
update md_date1 m1 left outer join md_date2 m2 on year(m1.col1)=year(m2.col2) set m1.col2='updated3', m2.col2=date(m1.col1) where m2.id > (select avg(id) from md_date2);
--TEST: check update result
select if(m1.col2 = 'updated3', 'ok', 'nok') from md_date1 m1 left outer join md_date2 m2 on year(m1.col1)=year(m2.col2) where m2.id > (select avg(id) from md_date2);


--TEST: right outer join
--TEST: error, syntax error
update md_date1 m1 right outer join md_date2 m2 on m1.col1=m2.col2 where m2.col1 < (select avg(id) from md_date2) set m2.id=id*100;
--TEST: success, 11 rows updated
update md_date1 m1 right outer join md_date2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval -2 month), m1.col2='updated4', m2.col1=month(m1.col1)*5 where m2.col1 > (select min(id) from md_date2);
--TEST: check the result
select case when count(*)=4 then 'ok' else 'nok' end from md_date1 where col2='updated4';
select case when count(*)=2 then 'ok' else 'nok' end from md_date2 where col1 is null;


drop table md_date1, md_date2;







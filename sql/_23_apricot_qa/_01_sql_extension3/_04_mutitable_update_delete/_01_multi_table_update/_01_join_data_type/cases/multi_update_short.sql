--update 2 tables with smallint type column for join condition



create table md_smallint1(id1 smallint primary key, col1 char(20));
insert into md_smallint1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_smallint1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_smallint2(id2 smallint, col1 bigint);
insert into md_smallint2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


select * from md_smallint1 order by 1;
select * from md_smallint2 order by 1;


--TEST: without table aliases, non-equijoin, 6 rows updated
update md_smallint1, md_smallint2 set md_smallint2.col1=100 where md_smallint1.id1 > (select min(id2) from md_smallint2) and md_smallint1.col1='lll';
--TEST: check the result
select if (md_smallint2.col1=100, 'ok', 'nok') from md_smallint1, md_smallint2 where md_smallint1.id1 > (select min(id2) from md_smallint2) and md_smallint1.col1='lll';


--TEST: error, with table aliases, update a derived table
update (select id1, col1 from md_smallint1) as m1, md_smallint2 m2 set m1.col1='updated1', m2.col1=1000 where m1.id1=m2.id2 and m1.col1='fff';


--TEST: inner join, no matched results, 0 rows affected
update md_smallint1 as m1 inner join md_smallint2 as m2 on m1.id1=m2.id2 set m1.col1=m2.id2 where m2.col1 > 100;


--TEST: left outer join, one table with an alias and the other without
--TEST: set invalid value, 3 rows updated in mysql
update md_smallint1 m1 left outer join md_smallint2 on m1.id1=md_smallint2.id2 set md_smallint2.col1='abc' where m1.id1 > (select avg(id1) from md_smallint1);
--TEST: success, 3 rows updated
update md_smallint1 m1 left outer join md_smallint2 on m1.id1=md_smallint2.id2 set md_smallint2.col1=m1.id1+1 where m1.id1 > (select avg(id1) from md_smallint1);
--TEST: check the result
select if (md_smallint2.id2 = md_smallint2.col1-1, 'ok', 'nok') from md_smallint1 m1 left outer join md_smallint2 on m1.id1=md_smallint2.id2 where m1.id1 > (select avg(id1) from md_smallint1) and md_smallint2.id2 is not null;


--TEST: right outer join
--TEST: error, update and select from the same table
update md_smallint1 m1 right outer join md_smallint2 m2 on m1.id1=m2.id2 set m2.id2=m1.id1*100 where m1.id1 < (select avg(id2) from md_smallint2);
--TEST: error, update with out-of-range value, duplicate entry error in mysql
update md_smallint1 m1 right outer join md_smallint2 m2 on m1.id1*100=m2.id2 set m1.id1=m2.id2*100000000 where m1.id1 < (select avg(id2) from md_smallint2);
--TEST: success, 2 rows updated
update md_smallint1 m1 right outer join md_smallint2 m2 on m1.id1*100=m2.id2 set m1.id1=m2.id2*10 where m1.id1 < (select avg(id2) from md_smallint2);
--TEST: check the result
select if (count(*) = 3, 'ok', 'nok') from md_smallint1 where id1>100;



drop table md_smallint1, md_smallint2;







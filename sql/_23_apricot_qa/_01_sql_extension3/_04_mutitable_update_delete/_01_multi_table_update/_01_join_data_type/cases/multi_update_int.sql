--TEST: update 2 tables with int type column for join condition



create table md_int1(id1 int primary key, col1 char(20));
insert into md_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_int1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_int2(id2 int, col1 smallint);
insert into md_int2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


select * from md_int1 order by 1;
select * from md_int2 order by 1;


--TEST: without table aliases, update 1 table, 1 row updated
update md_int1, md_int2 set md_int1.col1='updated1' where md_int1.id1=md_int2.id2 and md_int2.col1 < 10;
select if(count(*) = 1, 'ok', 'nok') from md_int1 where col1='updated1';
select if (count(*) = 6, 'ok', 'nok') from md_int2;


--TEST: with table aliases, update with constant values, 2 rows updated
update md_int1 m1, md_int2 m2 set m1.col1='updated2', m2.col1=123 where m1.id1=m2.id2 and m1.col1='fff';
select if (col1 = 'updated2', 'ok', 'nok') from md_int1 where id1=6;
select if (col1 = 123, 'ok', 'nok') from md_int2 where id2=6;


--TEST: inner join, no matched results
update md_int1 as m1 inner join md_int2 as m2 on m1.id1=m2.id2 set m1.id1=m2.col1 where m2.col1 > 200;


--TEST: left outer join, one table with an alias and the other without
--TEST: success, 9 rows updated
update md_int1 m1 left outer join md_int2 on m1.id1=md_int2.id2 set m1.col1='updated3', md_int2.col1=m1.id1 where m1.id1 > (select avg(id1) from md_int1);
select if(count(*) = 6, 'ok', 'nok') from md_int1 where col1='updated3';
select if(count(*) = 3, 'ok', 'nok') from md_int2 where id2=col1;
--TEST: success
update md_int1 m1 left outer join md_int2 on m1.id1=md_int2.id2 set md_int2.col1=m1.id1 where m1.id1 > (select avg(id1) from md_int1);
select if (md_int2.id2 = md_int2.col1, 'ok', 'nok') from md_int1 m1 left outer join md_int2 on m1.id1=md_int2.id2 where m1.id1 > (select avg(id1) from md_int1) and md_int2.id2 is not null;

--TEST: right outer join
--TEST: error, out-of-range values
update md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 set m1.col1='updated3', m2.col1=10000000 where m1.id1 < (select avg(id2) from md_int2);
--TEST: set invalid value
update md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 set m2.col1=m1.col1 where m1.id1 < (select avg(id2) from md_int2);
--TEST: success, 3 rows updated
update md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 set m1.col1='updated4' where m1.id1 < (select avg(id2) from md_int2);
select if (m1.col1 = 'updated4', 'ok', 'nok') from md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_int2);


drop table md_int1, md_int2;







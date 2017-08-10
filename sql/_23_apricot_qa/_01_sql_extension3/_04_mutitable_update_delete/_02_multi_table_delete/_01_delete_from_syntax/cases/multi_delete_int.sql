--TEST: delete from 2 tables with int type column for join condition



create table md_int1(id1 int primary key, col1 char(20));
insert into md_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_int1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_int2(id2 int, col1 short);
insert into md_int2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


select * from md_int1 order by 1;
select * from md_int2 order by 1;


--TEST: without table aliases
delete md_int1 from md_int1, md_int2 where md_int1.id1=md_int2.id2 and md_int2.col1 < 10;
select * from md_int1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_int2;


--TEST: with table aliases
delete m2 from md_int1 m1, md_int2 m2 where m1.id1=m2.id2 and m1.col1='fff';
select if (count(*) = 11, 'ok', 'nok') from md_int1;
select * from md_int2 order by 1;


--TEST: inner join, no matched results
delete m1, m2 from md_int1 as m1 inner join md_int2 as m2 on m1.id1=m2.id2 where m2.col1 > 100;
select if (count(*) = 11, 'ok', 'nok') from md_int1;
select if (count(*) = 5, 'ok', 'nok') from md_int2;


--TEST: left outer join, one table with an alias and the other without
delete m1, md_int2 from md_int1 m1 left outer join md_int2 on m1.id1=md_int2.id2 where m1.id1 > (select avg(id1) from md_int1);
select if (count(*) = 5, 'ok', 'nok') from md_int1;
select * from md_int2 order by 1;


--TEST: right outer join
delete m1, m2 from md_int1 m1 right outer join md_int2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_int2);
select if (count(*) = 5, 'ok', 'nok') from md_int1;
select if (count(*) = 2, 'ok', 'nok') from md_int2;



drop table md_int1, md_int2;







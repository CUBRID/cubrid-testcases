--TEST: delete from 2 views



create table md_int1(id1 int primary key, col1 char(20));
insert into md_int1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_int1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_int2(id2 int, col1 short);
insert into md_int2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


create view md_v1 as select * from md_int1 order by 1 with check option;
create view md_v2 as select * from md_int2 order by 1 with check option;


--TEST: without table aliases
delete md_v1 from md_v1, md_v2 where md_v1.id1=md_v2.id2 and md_v2.col1 < 10;
select * from md_v1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_v2;


--TEST: with table aliases
delete v2 from md_v1 v1, md_v2 v2 where v1.id1=v2.id2 and v1.col1='fff';
select if (count(*) = 11, 'ok', 'nok') from md_v1;
select * from md_v2 order by 1;


--TEST: inner join, no matched results
delete v1, v2 from md_v1 as v1 inner join md_v2 as v2 on v1.id1=v2.id2 where v2.col1 > 100;
select if (count(*) = 11, 'ok', 'nok') from md_v1;
select if (count(*) = 5, 'ok', 'nok') from md_v2;


--TEST: left outer join, one table with an alias and the other without
--TEST: delete and select from the same table
delete v1, md_v2 from md_v1 v1 left outer join md_v2 on v1.id1=md_v2.id2 where v1.id1 > (select avg(id1) from md_v1);
select if (count(*) = 5, 'ok', 'nok') from md_v1;
select if (count(*) = 2, 'ok', 'nok') from md_v2;


--TEST: right outer join
--TEST: delete and select from the same table
delete v1, v2 from md_v1 v1 right outer join md_v2 v2 on v1.id1=v2.id2 where v1.id1 < (select avg(id2) from md_v2);
select if (count(*) = 5, 'ok', 'nok') from md_v1;
select if (count(*) = 2, 'ok', 'nok') from md_v2;


--TEST: data also deleted in tables
select if (count(*) = 5, 'ok', 'nok') from md_int1;
select if (count(*) = 2, 'ok', 'nok') from md_int2;



drop table md_int1, md_int2;
drop view md_v1, md_v2;







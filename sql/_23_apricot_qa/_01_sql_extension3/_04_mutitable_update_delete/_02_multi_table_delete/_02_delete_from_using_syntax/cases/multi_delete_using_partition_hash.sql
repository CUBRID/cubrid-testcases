--TEST: delete from 2 tables with hash partition



create table md_p_hash1(id1 smallint primary key, col1 char(20))
partition by hash(id1) partitions 5;
insert into md_p_hash1 values(1, 'aaa'), (2, 'bbb'), (3, 'ccc'), (4, 'ddd'), (5, 'eee'), (6, 'fff');
insert into md_p_hash1 values(7, 'ggg'), (8, 'hhh'), (9, 'iii'), (10, 'jjj'), (11, 'kkk'), (12, 'lll');


create table md_p_hash2(id2 smallint, col1 bigint)
partition by hash(col1) partitions 3;
insert into md_p_hash2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


select * from md_p_hash1 order by 1;
select * from md_p_hash2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row deleted.
delete from md_p_hash1 using md_p_hash1, md_p_hash2 where md_p_hash1.id1 > (select min(col1) from md_p_hash2) and md_p_hash1.col1='lll';
--TEST: delete and select from the same table, no matched rows
delete from md_p_hash1, md_p_hash2 using md_p_hash1, md_p_hash2 where md_p_hash1.id1 > (select min(col1) from md_p_hash2) and md_p_hash1.col1='lll';
select * from md_p_hash1 order by 1;
select if (count(*) = 6, 'ok', 'nok') from md_p_hash2;


--TEST: with table aliases, derived table, 1 row deleted
delete from m2 using (select id1, col1 from md_p_hash1) as m1, md_p_hash2 m2 where m1.id1=m2.id2 and m1.col1='fff';
select if (count(*) = 11, 'ok', 'nok') from md_p_hash1;
select * from md_p_hash2 order by 1;


--TEST: inner join, no matched results
delete from m1, m2, m1 using md_p_hash1 as m1 inner join md_p_hash2 as m2 on m1.id1=m2.id2 where m2.col1 > 100;
select if (count(*) = 11, 'ok', 'nok') from md_p_hash1;
select if (count(*) = 5, 'ok', 'nok') from md_p_hash2;


--TEST: left outer join, one table with an alias and the other without
--TEST: delete and select from the same table, 7 rows deleted.
delete from m1, md_p_hash2 using md_p_hash1 m1 left outer join md_p_hash2 on m1.id1=md_p_hash2.id2 where m1.id1 > (select avg(id1) from md_p_hash1);
select if (count(*) = 6, 'ok', 'nok') from md_p_hash1;
select if (count(*) = 3, 'ok', 'nok') from md_p_hash2;


--TEST: right outer join
--TEST: delete and select from the same table
delete from m1, m2 using md_p_hash1 m1 right outer join md_p_hash2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_p_hash2);
select if (count(*) = 4, 'ok', 'nok') from md_p_hash1;
select if (count(*) = 1, 'ok', 'nok') from md_p_hash2;



drop table md_p_hash1, md_p_hash2;







--update 2 tables with varbit(n) type column for join condition

drop table if exists md_varbit1;
drop table if exists md_varbit2;

create table md_varbit1(id1 smallint primary key, col1 char(20), col2 bit varying);
insert into md_varbit1 values(1, 'aaa', B'1010'), (2, 'bbb', B'1101'), (3, 'ccc', B'1011'), (4, 'ddd', B'1110'), (5, 'eee', B'10010'), (6, 'fff', B'10101');
insert into md_varbit1 values(7, 'ggg', B'101'), (8, 'hhh', B'110'), (9, 'iii', B'111'), (10, 'jjj', B'10111'), (11, 'kkk', B'11001'), (12, 'lll', B'10001');


create table md_varbit2(id2 smallint, col1 bigint, col2 bit varying primary key);
insert into md_varbit2 values(2, 5, B'1'), (4, 10, B'11'), (6, 13, B'1101'), (8, 22, B'10111'), (10, 45, B'10001'), (12, 57, B'10101');


select * from md_varbit1 order by 1;
select * from md_varbit2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row updated
update md_varbit1, md_varbit2 set md_varbit1.col1='updated1' where md_varbit1.col2 > (select min(col2) from md_varbit2) and md_varbit1.col1='lll';
select if (count(*) = 1, 'ok', 'nok') from md_varbit1 where col1='updated1';



--TEST: with table aliases, derived table, 3 rows updated
update (select id1, col2 from md_varbit1) as m1, md_varbit2 m2 set m2.id2=(m1.id1+m2.col1)/3 where m1.col2=m2.col2 and bit_count(m2.id2)=2;
--TEST: check update result
select * from md_varbit2 order by 1;


--TEST: inner join, no matched results
update md_varbit1 as m1 inner join md_varbit2 as m2 on m1.col2=m2.col2 set m2.col2=m1.col2+1 where m2.col1 > (select 100);


--TEST: left outer join, one table with an alias and the other without
--TEST: error, update and select from the same table
update md_varbit1 m1 left outer join md_varbit2 m2 on m1.col2=m2.col2 set m2.col2=m1.col2+B'101', m1.col1='updated2' where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_varbit1 m1 inner join md_varbit2 m2 on m1.id1=m2.id2);
--TEST: check the result
select * from md_varbit2 order by 1;
select case when count(*)=3 then 'ok' else 'nok' end from md_varbit1 where col1='updated2';


--TEST: right outer join
--TEST: error, update and select from the same table
update md_varbit1 m1 right outer join md_varbit2 m2 on m1.col2=m2.col2 set m2.col1=m1.id1/555 where m1.id1 < (select avg(id2) from md_varbit2);
--TEST: success, 8 rows updated
update md_varbit1 m1 right outer join md_varbit2 m2 on m1.col2=m2.col2 set m1.col1='updated3', m2.col2=m1.col2+B'101' where m1.id1 > (select count(concat(col1, 'a')) from md_varbit2 m2 where id2 < 4);
select case when count(*)=4 then 'ok' else 'nok' end from md_varbit1 where col1='updated3';
select * from md_varbit2 order by 1;



drop table md_varbit1, md_varbit2;







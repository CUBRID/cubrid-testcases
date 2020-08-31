--update from 1 normal table and 1 table with superclass



create table md_bit1(id1 smallint primary key, col1 char(20), col2 bit(24));
insert into md_bit1 values(1, 'aaa', B'1010'), (2, 'bbb', B'1101'), (3, 'ccc', B'1011'), (4, 'ddd', B'1110'), (5, 'eee', B'10010'), (6, 'fff', B'10101');
insert into md_bit1 values(7, 'ggg', B'101'), (8, 'hhh', B'110'), (9, 'iii', B'111'), (10, 'jjj', B'10111'), (11, 'kkk', B'11001'), (12, 'lll', B'10001');


create table md_bit2(id2 smallint, col1 bigint);
insert into md_bit2 values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);


--create subclass
create table sub_md_bit2 under md_bit2(col2 bit(20) primary key);
insert into sub_md_bit2 values(2, 5, B'1'), (4, 10, B'11'), (6, 13, B'1101'), (8, 22, B'10111'), (10, 45, B'10001'), (12, 57, B'10101');


select * from md_bit1 order by 1;
select * from md_bit2 order by 1;
select * from sub_md_bit2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row updated
update md_bit1, sub_md_bit2 set md_bit1.col1='updated1' where md_bit1.col2 > (select min(col2) from sub_md_bit2) and md_bit1.col1='lll';
select if (count(*) = 1, 'ok', 'nok') from md_bit1 where col1='updated1';


--TEST: update and select from the same table, no matched rows
update md_bit1, sub_md_bit2 set sub_md_bit2.col2=md_bit1.col2 where md_bit1.col2 > (select min(col2) from sub_md_bit2) and md_bit1.col1='lll';


--TEST: with table aliases, derived table, 3 rows updated
update (select id1, col2 from md_bit1) as m1, sub_md_bit2 m2 set m2.id2=(m1.id1+m2.col1)/3 where m1.col2=m2.col2 and bit_count(m2.id2)=2;
--TEST: check update result
select case when count(*)=3 then 'ok' else 'nok' end from sub_md_bit2 where id2 in (5, 19, 21);


--TEST: inner join, no matched results
update md_bit1 as m1 inner join sub_md_bit2 as m2 on m1.col2=m2.col2 set m2.col2=m1.col2+1 where m2.col1 > (select 100);


--TEST: left outer join, one table with an alias and the other without
--TEST: error, divide by zero 
update md_bit1 m1 left outer join sub_md_bit2 m2 on m1.col2=m2.col2 set m2.col2=m1.col2+B'101', m1.id1=m2.col1/0 where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_bit1 m1 inner join sub_md_bit2 m2 on m1.id1=m2.id2);
--[er], not null constraint violation 
update md_bit1 m1 left outer join sub_md_bit2 m2 on m1.col2=m2.col2 set m2.col2=m1.col2+B'101', m1.id1=m2.col1/5 where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_bit1 m1 inner join sub_md_bit2 m2 on m1.id1=m2.id2);
--TEST: check the result
select if (count(*) = 0, 'ok', 'nok') from md_bit1 where id1 is null;


--TEST: right outer join
--TEST: success, 4 rows updated
update md_bit1 m1 right outer join sub_md_bit2 m2 on m1.col2=m2.col2 set m1.col1='updated2', m1.col2=m2.col2+B'101' where m1.id1 > (select count(concat(col1, 'a')) from sub_md_bit2 m2 where id2 < 4);
select if(count(*)=5, 'ok', 'nok') from md_bit1 where col1='updated2';



drop table md_bit1, md_bit2, sub_md_bit2;







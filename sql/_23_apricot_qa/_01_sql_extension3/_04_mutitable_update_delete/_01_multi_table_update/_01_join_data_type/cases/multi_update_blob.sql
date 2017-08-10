--update 2 tables with blob type column for join condition
--+holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists md_blob1;
drop table if exists md_blob2;


create table md_blob1(id1 smallint primary key, col1 char(20), col2 blob);
insert into md_blob1 values(1, 'aaa', bit_to_blob(B'1010')), (2, 'bbb', bit_to_blob(B'1101')), (3, 'ccc', bit_to_blob(B'1011')), (4, 'ddd', bit_to_blob(B'1110')), (5, 'eee', bit_to_blob(B'10010')), (6, 'fff', bit_to_blob(B'10101'));
insert into md_blob1 values(7, 'ggg', bit_to_blob(B'101')), (8, 'hhh', bit_to_blob(B'110')), (9, 'iii', bit_to_blob(B'111')), (10, 'jjj', bit_to_blob(B'10111')), (11, 'kkk', bit_to_blob(B'11001')), (12, 'lll', bit_to_blob(B'10001'));


create table md_blob2(id2 smallint, col1 bigint, col2 blob);
insert into md_blob2 values(2, 5, bit_to_blob(B'1')), (4, 10, bit_to_blob(B'11')), (6, 13, bit_to_blob(B'1101')), (8, 22, bit_to_blob(B'10111')), (10, 45, bit_to_blob(B'10001')), (12, 57, bit_to_blob(B'10101'));


select id1, col1, blob_to_bit(col2) from md_blob1 order by 1;
select id2, col1, blob_to_bit(col2) from md_blob2 order by 1;


--TEST: without table aliases, non-equijoin, 1 row updated
update md_blob1, md_blob2 set md_blob1.col1='updated1' where blob_to_bit(md_blob1.col2) > (select min(blob_to_bit(col2)) from md_blob2) and md_blob1.col1='lll';
select if (count(*) = 1, 'ok', 'nok') from md_blob1 where col1='updated1';


--TEST: update and select from the same table, no matched rows.
update md_blob1, md_blob2 set md_blob2.col2=bit_to_blob(blob_to_bit(md_blob1.col2)) where blob_to_bit(md_blob1.col2) > (select min(blob_to_bit(col2)) from md_blob2) and md_blob1.col1='lll';


--!!!!!!!!!!!!!!!!!!!!!!!!!CUBRID BUG: CUBRIDSUS-8863!!!!!!!!!!!!!!!!!!!!!!
--TEST: with table aliases, derived table, 3 rows updated
--update (select id1, blob_to_bit(col2) col2 from md_blob1) as m1, md_blob2 m2 set m2.id2=(m1.id1+m2.col1)/3 where blob_to_bit(m1.col2)=blob_to_bit(m2.col2) and bit_count(m2.id2)=2;
--update (select * from md_blob1) as m1, md_blob2 m2 set m2.id2=(m1.id1+m2.col1)/3 where blob_to_bit(m1.col2)=blob_to_bit(m2.col2) and bit_count(m2.id2)=2;
update md_blob1 as m1, md_blob2 m2 set m2.id2=(m1.id1+m2.col1)/3 where blob_to_bit(m1.col2)=blob_to_bit(m2.col2) and bit_count(m2.id2)=2;
--TEST: check update result
select if(count(*)=3, 'ok', 'nok') from md_blob2 where id2 in (5, 19, 21);


--TEST: inner join, no matched results
update md_blob1 as m1 inner join md_blob2 as m2 on blob_to_bit(m1.col2)=blob_to_bit(m2.col2) set m2.col2=bit_to_blob(blob_to_bit(m1.col2)+1) where m2.col1 > (select 100);


--TEST: left outer join, one table with an alias and the other without
--TEST: update and select from the same table
update md_blob1 m1 left outer join md_blob2 m2 on blob_to_bit(m1.col2)=blob_to_bit(m2.col2) set m2.col2=bit_to_blob(blob_to_bit(m1.col2)+B'101'), m1.col1='updated2' where m1.id1 < (select count(concat(m1.col1, m2.col1)) from md_blob1 m1 inner join md_blob2 m2 on m1.id1=m2.id2);
select if (count(*) = 3, 'ok', 'nok') from md_blob1 where col1='updated2';


--TEST: right outer join
--TEST: success, 4 rows updated
update md_blob1 m1 right outer join md_blob2 m2 on blob_to_bit(m1.col2)=blob_to_bit(m2.col2) set m1.col1='updated3', m1.col2=bit_to_blob(blob_to_bit(m2.col2)+B'101') where m1.id1 > (select count(concat(col1, 'a')) from md_blob2 m2 where id2 < 4);
select if (count(*) = 4, 'ok', 'nok') from md_blob1 where col1='updated3';
select id2, col1, blob_to_bit(col2) from md_blob2 order by 1;


delete m1, m2 from md_blob1 m1, md_blob2 m2;

drop table md_blob1, md_blob2;
set system parameters 'dont_reuse_heap_file=no';
--+holdcas off;






--delete from 2 tables with clob type column for join condition, with composed index



create table md_clob1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 clob);
insert into md_clob1 values(11111.11111, '2011-09-01 12:12:12', char_to_clob('cubrid')), (22222.22222, '2011-09-01 12:12:13', char_to_clob('mysql')), (33333.33333, '2011-09-01 12:12:14', char_to_clob('abc')), (44444.44444, '2011-09-01 12:12:15', char_to_clob('cubridcubrid')), (55555.55555, '2011-09-01 12:12:16', char_to_clob('mysqlmysql')), (66666.66666, '2011-09-01 12:12:17', char_to_clob('abcabc'));


create table md_clob2(col1 clob, id2 numeric(10, 5));
insert into md_clob2 values(char_to_clob('cubrid'), 1234.12345), (char_to_clob('abcabc'), 3456.34555), (char_to_clob('a'), 55555.55555), (char_to_clob('abcabc'), 444.12345), (char_to_clob('aa'), 5555.1234), (char_to_clob('mysql'), 22222.22222);
insert into md_clob2 values(char_to_clob('cubridcubrid'), 666.6666), (char_to_clob('mysqlmysql'), 44444.44444), (char_to_clob('aaaa'), 5656.56565), (char_to_clob('abcabcabc'), 66666.66666), (char_to_clob('hello'), 77.88777), (char_to_clob('hellohello'), 90000.909);



--TEST: error, false join condition
delete from m1, m2 using md_clob1 m1, md_clob2 m2 where m1.col2=m2.id2;


--TEST: without table aliases, 1 row deleted in eache table
--below one included an issue. this issue will not been fixed on apricot. so comment out hear
--delete from md_clob1, md_clob2 using md_clob1, md_clob2 where clob_to_char(md_clob1.col2)=clob_to_char(md_clob2.col1) and char_length(md_clob1.col1) > 5 and md_clob1.id1=md_clob2.id2;
--select if (count(*) = 5, 'ok', 'nok') from md_clob1;
--select if (count(*) = 11, 'ok', 'nok') from md_clob2;


--TEST: with table aliases, 2 rows deleted
delete from m2 using md_clob1 m1, md_clob2 m2 where clob_to_char(m1.col2)=clob_to_char(m2.col1) and round(m2.id2) in (1234, 5555, 5657, 667);
select if (count(*) = 6, 'ok', 'nok') from md_clob1;
select if (count(*) = 10, 'ok', 'nok') from md_clob2;


--TEST: inner join, 3 rows deleted
delete from m2 using md_clob2 as m2 inner join (select id1, trim(substr(clob_to_char(col2), 1, 6)) as col2 from md_clob1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(clob_to_char(m2.col1), 3);
select if (count(*) = 6, 'ok', 'nok') from md_clob1;
select if (count(*) = 7, 'ok', 'nok') from md_clob2;


--TEST: left outer join, delete and select from the same table
delete from m1, md_clob2 using md_clob1 m1 left outer join md_clob2 on clob_to_char(m1.col2)=clob_to_char(md_clob2.col1) where m1.id1 > (select avg(id1) from md_clob1);
select if (count(*) = 3, 'ok', 'nok') from md_clob1;
select if (count(*) = 6, 'ok', 'nok') from md_clob2;


--TEST: right outer join
--TEST: delete and select from the same table
delete from m1, m2 using md_clob1 m1 right outer join md_clob2 m2 on clob_to_char(m1.col2)=clob_to_char(m2.col1) where m1.id1 < (select abs(avg(id2)) from md_clob2);
select if (count(*) = 2, 'ok', 'nok') from md_clob1;
select if (count(*) = 5, 'ok', 'nok') from md_clob2;


--TEST: delete all data
delete from m1, m2 using md_clob1 m1, md_clob2 m2;

select if (count(*) = 0, 'ok', 'nok') from md_clob1;
select if (count(*) = 0, 'ok', 'nok') from md_clob2;


drop table md_clob1, md_clob2;







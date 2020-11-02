--update 2 tables with char(n) type column for join condition, with composed index



create table md_char1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 varchar(50) primary key);
insert into md_char1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table md_char2(col1 varchar(990), id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_char2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_char2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_char1 order by 1, 2;
select * from md_char2 order by 1, 2;


--TEST: error, false join condition
update md_char1 m1, md_char2 m2 set m1.col2='updated1' where m1.col2=m2.id2;


--TEST: error, without table aliases, set with invalid value
update md_char1, md_char2 set md_char1.id1=floor(md_char2.id2)+md_char1.id1, md_char2.id2=md_char2.id2/mod(md_char1.id1, 2) where md_char1.col2=md_char2.col1 and char_length(md_char1.col1) > 5 and md_char1.id1=md_char2.id2;


--TEST: with table aliases, 4 rows updated
update md_char1 m1, md_char2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1='updated1' where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_char1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_char2 where col1='updated1';


--TEST: inner join, 3 rows updated
update md_char2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_char1 where left(col2, 3) = 'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=(select max(id1) from md_char1 where left(m1.col2, 3)=left(m2.col1, 3));
--TEST: check update result
select if (id2 in (99999.99999, 66666.66666), 'ok', 'nok') from md_char2 where left(col1, 3)='abc';


--TEST: success, 3 rows updated
update md_char1 m1 left outer join md_char2 on md_char2.col1=m1.col2 set m1.col1=default, md_char2.col1='updated2', md_char2.id2=m1.id1 where m1.id1 > (select avg(id1) from md_char1);
--TEST: check the result
select if(count(*)=3, 'ok', 'nok') from md_char1 where CURRENT_TIMESTAMP-col1 < 2;
select case when count(*)=3 then 'ok' else 'nok' end from md_char2 where col1='updated2';


--TEST: right outer join
--TEST: success, 7 rows updated
update md_char1 m1 right outer join md_char2 m2 on m1.col2=m2.col1 set m1.col2='updated3', m2.col1='updated3', m2.id2=m1.id1 where m2.id2 < (select avg(id1) from md_char1);
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_char1 where col2='updated3';
select if (count(*) = 6, 'ok', 'nok') from md_char2 where col1='updated3';
select if (count(*) = 5, 'ok', 'nok') from md_char2 where id2 is null;



drop table md_char1, md_char2;







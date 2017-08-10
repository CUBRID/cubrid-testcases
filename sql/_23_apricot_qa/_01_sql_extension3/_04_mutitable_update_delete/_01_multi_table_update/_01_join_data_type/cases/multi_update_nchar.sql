--update 2 tables with nchar(n) type column for join condition, with composed index



create table md_nchar1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 nchar(1024) primary key);
insert into md_nchar1 values(11111.11111, '2011-09-01 12:12:12', n'cubrid'), (22222.22222, '2011-09-01 12:12:13', n'mysql'), (33333.33333, '2011-09-01 12:12:14', n'abc'), (44444.44444, '2011-09-01 12:12:15', n'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', n'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', n'abcabc');


create table md_nchar2(col1 nchar(500), id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_nchar2 values(n'cubrid', 1234.12345), (n'abcabc', 3456.34555), (n'a', 55555.55555), (n'abcabc', 444.12345), (n'aa', 5555.1234), (n'mysql', 22222.22222);
insert into md_nchar2 values(n'cubridcubrid', 666.6666), (n'mysqlmysql', 44444.44444), (n'aaaa', 5656.56565), (n'abcabcabc', 66666.66666), (n'hello', 77.88777), (n'hellohello', 90000.909);


select * from md_nchar1 order by 1, 2;
select * from md_nchar2 order by 1, 2;


--TEST: error, false join condition
update md_nchar1 m1, md_nchar2 m2 set m1.col2='updated1' where m1.col2=m2.id2;


--TEST: error, without table aliases, set with invalid value
update md_nchar1, md_nchar2 set md_nchar1.id1=floor(md_nchar2.id2)+md_nchar1.id1, md_nchar2.id2=md_nchar2.id2/mod(md_nchar1.id1, 2) where md_nchar1.col2=md_nchar2.col1 and char_length(md_nchar1.col1) > 5 and md_nchar1.id1=md_nchar2.id2;


--TEST: with table aliases, 4 rows updated
update md_nchar1 m1, md_nchar2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1=n'updated1' where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_nchar1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_nchar2 where col1=n'updated1';


--TEST: inner join, 3 rows updated
update md_nchar2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_nchar1 where left(col2, 3) = n'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=m1.id1;
--TEST: check update result
select if (id2 in (33333.33333, 66666.66666), 'ok', 'nok') from md_nchar2 where left(col1, 3)=n'abc';


--TEST: error, update and select from the same table
update md_nchar1 m1 left outer join md_nchar2 on m1.col2=md_nchar2.col1 set m1.col2='updated2', md_nchar2.col1=m1.col2 where m1.id1 > (select avg(id1) from md_nchar1);
--TEST: success, no matched rows
update md_nchar1 m1 left outer join md_nchar2 on md_nchar2.col1=m1.col2 set md_nchar2.col1=n'updated2', md_nchar2.id2=m1.id1 where m1.id1 > (select avg(id1) from md_nchar1);
--TEST: check the result
select case when count(*)=3 then 'ok' else 'nok' end from md_nchar2 where col1=n'updated2';


--TEST: right outer join
--TEST: error, update and select from the same table
update md_nchar1 m1 right outer join md_nchar2 m2 on m1.col2=m2.col1 set m2.col2='updated3', m1.id1=m2.id2 where m1.id1 < (select abs(avg(id2)) from md_nchar2);
--TEST: success, 3 rows updated
update md_nchar1 m1 right outer join md_nchar2 m2 on m1.col2=m2.col1 set m1.id1=m2.id2/5, m2.col1=n'updated3', m2.id2=m1.id1 where m2.col1=n'updated2';
--TEST: check update result
select if (count(*) = 3, 'ok', 'nok') from md_nchar2 where col1=n'updated3';
select if (count(*) = 3, 'ok', 'nok') from md_nchar2 where id2 is null;



drop table md_nchar1, md_nchar2;







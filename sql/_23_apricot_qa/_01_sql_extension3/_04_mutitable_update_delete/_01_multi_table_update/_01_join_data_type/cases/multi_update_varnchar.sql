--update 2 tables with varnchar(n) type column for join condition, with composed index

drop table if exists md_varnchar1,md_varnchar2;
create table md_varnchar1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 nchar varying(1024) primary key);
insert into md_varnchar1 values(11111.11111, '2011-09-01 12:12:12', n'cubrid'), (22222.22222, '2011-09-01 12:12:13', n'mysql'), (33333.33333, '2011-09-01 12:12:14', n'abc'), (44444.44444, '2011-09-01 12:12:15', n'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', n'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', n'abcabc');


create table md_varnchar2(col1 nchar varying, id2 numeric(10, 5), index i(id2 desc, col1));
insert into md_varnchar2 values(n'cubrid', 1234.12345), (n'abcabc', 3456.34555), (n'a', 55555.55555), (n'abcabc', 444.12345), (n'aa', 5555.1234), (n'mysql', 22222.22222);
insert into md_varnchar2 values(n'cubridcubrid', 666.6666), (n'mysqlmysql', 44444.44444), (n'aaaa', 5656.56565), (n'abcabcabc', 66666.66666), (n'hello', 77.88777), (n'hellohello', 90000.909);


select * from md_varnchar1 order by 1, 2;
select * from md_varnchar2 order by 1, 2;


--TEST: error, false join condition
update md_varnchar1 m1, md_varnchar2 m2 set m1.col2=n'updated1' where m1.col2=m2.id2;


--TEST: error, without table aliases, set with invalid value
update md_varnchar1, md_varnchar2 set md_varnchar1.id1=floor(md_varnchar2.id2)+md_varnchar1.id1, md_varnchar2.id2=md_varnchar2.id2/mod(md_varnchar1.id1, 2) where md_varnchar1.col2=md_varnchar2.col1 and char_length(md_varnchar1.col1) > 5 and md_varnchar1.id1=md_varnchar2.id2;


--TEST: with table aliases, 4 rows updated
update md_varnchar1 m1, md_varnchar2 m2 set m1.col1=date_add(m1.col1, interval -3 month), m2.col1=n'updated1' where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_varnchar1 where month(col1)=6;
select if (count(*) = 2, 'ok', 'nok') from md_varnchar2 where col1=n'updated1';


--TEST: inner join, 3 rows updated
update md_varnchar2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_varnchar1 where left(col2, 3) = n'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=(select max(m1.id1) from md_varnchar2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_varnchar1 where left(col2, 3) = n'abc') m1 on left(m1.col2, 3)=left(m2.col1, 3));
--TEST: check update result
select if (id2 in (99999.99999, 66666.66666), 'ok', 'nok') from md_varnchar2 where left(col1, 3)=n'abc';


--TEST: success, no matched rows
update md_varnchar1 m1 left outer join md_varnchar2 on md_varnchar2.col1=m1.col2 set md_varnchar2.col1=n'updated2', md_varnchar2.id2=m1.id1 where m1.id1 > (select avg(id1) from md_varnchar1);
--TEST: check the result
select case when count(*)=3 then 'ok' else 'nok' end from md_varnchar2 where col1=n'updated2';


--TEST: right outer join
--TEST: update and select from the same table, 2 rows updated
update md_varnchar1 m1 right outer join md_varnchar2 m2 on m1.col2=m2.col1 set m2.col1=n'updated3', m1.id1=m2.id2+1 where m1.id1 < (select abs(avg(id2)) from md_varnchar2);
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_varnchar2 where col1=n'updated3';
select if (count(*) = 1, 'ok', 'nok') from md_varnchar1 where id1=22223.22222;



drop table md_varnchar1, md_varnchar2;






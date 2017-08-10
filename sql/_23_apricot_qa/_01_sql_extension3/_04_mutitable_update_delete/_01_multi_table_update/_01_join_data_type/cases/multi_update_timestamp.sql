--update from 2 tables with timestamp type column for join condition



create table md_timestamp1(id1 double, col1 timestamp not null default CURRENT_TIMESTAMP unique);
insert into md_timestamp1 values(1111111.11111, '2011-09-01 12:12:12'), (2222222.22222, '2011-09-01 12:12:13'), (33333333.33333, '2011-09-01 12:12:14'), (4444444.44444, '2011-09-01 12:12:15'), (5555555.55555, '2011-09-01 12:12:16'), (6666666.66666, '2011-09-01 12:12:17'), (7777777.77777, '2011-10-10 1:1:1'), (8888888.88888, '2011-10-10 2:2:2'), (9999999.99999, '2011-11-11 11:11:11'), (1010101010.123, '2012-12-12 8:8:8');


create table md_timestamp2(col1 varchar(996), id2 double, col2 timestamp, index i(col1, col2));
insert into md_timestamp2 values('cubrid', 1234.12345, '2011-09-01 12:12:12'), ('abc', 3333333456.34555, '2011-09-01 12:12:12'), ('a', 55555.55555, '2011-09-01 12:12:13'), ('abcabc', 4444444.12345, '2011-09-01 12:12:13'), ('aa', 5555.1234, '2011-09-01 12:12:14'), ('mysql', 2222222.22222, '2011-09-01 12:12:14');
insert into md_timestamp2 values('cubridcubrid', 666.6666, '2020-12-12 1:1:1'), ('mysqlmysql', 44444.44444444, '1988-10-10 2:2:2'), ('aaaa', 5555656.56565, '2011-09-01 12:12:17'), ('abcabcabc', 6666666.66666, '2011-10-10 2:2:2'), ('hello', 777777777.88777, '1988-10-10 3:3:3'), ('hellohello', 90000.909, '2012-12-12 8:8:8');


select * from md_timestamp1 order by 1;
select * from md_timestamp2 order by 1;


--TEST: error, false join condition
update md_timestamp1 m1, md_timestamp2 m2 set m1.id1=floor(m2.id2) where m2.col1=m1.col1;


--TEST: without table aliases, no matched results
update md_timestamp1, md_timestamp2 set md_timestamp1.col1=date_add(md_timestamp2.col2, interval -3 day) where md_timestamp1.col1=md_timestamp2.col2 and truncate(md_timestamp1.id1, 2)=truncate(md_timestamp2.id2, 2);


--TEST: with table aliases, 3 rows updated
update md_timestamp1 m1, md_timestamp2 m2 set m1.id1=truncate(m2.id2, 3), m2.col1='updated1' where m1.col1=m2.col2 and (m2.id2>3333333456 or m2.id2<1235);
--TEST: check update result
select if (id1 in (1234.123, 3333333456.345), 'ok', 'nok') from md_timestamp1 where col1='2011-09-01 12:12:12';
select if (count(*) = 2, 'ok', 'nok') from md_timestamp2 where col1='updated1';


--TEST: inner join, 1 row updated
update md_timestamp1 as m1 inner join (select id2, substr(col1, 1, 6), col2 from md_timestamp2) m2 on m1.col1=m2.col2 set m1.id1=floor(m1.id1) where m2.col2='08:08:08 AM 12/12/2012';
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_timestamp1 where id1=round(id1);


--TEST: success, 4 rows updated
update md_timestamp2 m2 left outer join md_timestamp1 m1 on m1.col1=m2.col2 set m2.col1='updated2' where year(m2.col2)=2011;
--TEST: check update result
select if (count(*) = 8, 'ok', 'nok') from md_timestamp2 where col1='updated2';


--TEST: right outer join
--TEST: success, 11 rows updated
update md_timestamp2 m2 right outer join (select round(id1) as id1, col1 from md_timestamp1 where length(col1) < 100) m1 on time(m1.col1)=time(m2.col2) set m2.col1='updated3';
--TEST: check update result
select if (count(*) = 11, 'ok', 'nok') from md_timestamp2 where col1='updated3';



drop table md_timestamp1, md_timestamp2;







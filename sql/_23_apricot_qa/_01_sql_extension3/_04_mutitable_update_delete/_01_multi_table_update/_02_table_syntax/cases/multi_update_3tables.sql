--update 3 tables with datetime type column for join condition



create table md_datetime1(id1 double, col1 datetime not null default CURRENT_TIMESTAMP unique);
insert into md_datetime1 values(1111111.11111, '2011-09-01 12:12:12.999'), (2222222.22222, '2011-09-01 12:12:13.999'), (33333333.33333, '2011-09-01 12:12:14.999'), (4444444.44444, '2011-09-01 12:12:15.999'), (5555555.55555, '2011-09-01 12:12:16.999'), (6666666.66666, '2011-09-01 12:12:17.999'), (7777777.77777, '2011-10-10 1:1:1.999'), (8888888.88888, '2011-10-10 2:2:2.999'), (9999999.99999, '2011-11-11 11:11:11.999'), (1010101010.123, '2012-12-12 8:8:8.999');


create table md_datetime2(col1 varchar(1024), id2 double, col2 datetime, index i(col1, col2));
insert into md_datetime2 values('cubrid', 1234.12345, '2011-09-01 12:12:12.999'), ('abc', 3333333456.34555, '2011-09-01 12:12:12.999'), ('a', 55555.55555, '2011-09-01 12:12:13.999'), ('abcabc', 4444444.12345, '2011-09-01 12:12:13.999'), ('aa', 5555.1234, '2011-09-01 12:12:14.999'), ('mysql', 2222222.22222, '2011-09-01 12:12:14.999');
insert into md_datetime2 values('cubridcubrid', 666.6666, '2020-12-12 1:1:1.999'), ('mysqlmysql', 44444.44444444, '1988-10-10 2:2:2.999'), ('aaaa', 5555656.56565, '2011-09-01 12:12:17.999'), ('abcabcabc', 6666666.66666, '2011-10-10 2:2:2.999'), ('hello', 777777777.88777, '1988-10-10 3:3:3.999'), ('hellohello', 90000.909, '2012-12-12 8:8:8.999');


create table md_datetime3(id3 int primary key, col1 varchar, col2 datetime);
insert into md_datetime3 values(1, 'cubrid', '2011-09-01 12:12:12.999'), (2, 'mysql', datetime'2011-09-01 12:12:13.999'), (3, 'aaa', '2011-09-01 12:12:14.999'), (4, 'abc', '1988-10-10 3:3:3.999'), (5, 'abcabc', '1998-2-15 13:14:15.999'), (6, 'multi', '2012-12-12 8:8:8.999');

select * from md_datetime1 order by 1;
select * from md_datetime2 order by 1;
select * from md_datetime3 order by 1;


--TEST: error, false join condition
update md_datetime1 m1, md_datetime2 m2, md_datetime3 m3 set m1.id1=floor(m2.id2), m3.col1='updated1' where m2.col1=m1.col1 and m1.col1=m3.col2;
--TEST: TEST: check update result
select if (col1 = 'updated1', 'nok', 'ok') from md_datetime3;


--TEST: without table aliases, no matched results
update md_datetime1, md_datetime2, md_datetime3 set md_datetime1.id1=truncate(md_datetime2.id2, 3), md_datetime2.col1='updated2' where md_datetime1.col1=md_datetime2.col2 and md_datetime1.col1=md_datetime3.col2 and truncate(md_datetime1.id1, 2)=truncate(md_datetime2.id2, 2);
--TEST: TEST: check update result
select if (col1 = 'updated2', 'nok', 'ok') from md_datetime3;


--TEST: with table aliases, 2 rows updated
update (select id1, col1 from (select * from md_datetime1 where month(col1)=9) md1) m1, md_datetime2 m2, md_datetime3 m3 set m2.id2=truncate(m1.id1, 2), m3.col1='updated3' where m1.id1=m2.id2 and m3.col2=m1.col1;
--TEST: check update result
select if (id2 = 2222222.22, 'ok', 'nok') from md_datetime2 where col1='mysql';
select if (count(*) = 1, 'ok', 'nok') from md_datetime3 where col1='updated3';


--TEST: inner join, 1 row updated
update md_datetime1 as m1 inner join (select id2, substr(col1, 1, 6), col2 from md_datetime2) m2 on m1.col1=m2.col2 inner join (select col2 from md_datetime3) m3 on m3.col2=m2.col2 set m1.id1=mod(m2.id2, 5) where m1.id1 > (select sum(id2)/5 from md_datetime2);
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_datetime1 where id1 < 1;


--TEST: error, syntax error
update md_datetime2 m2 left outer join md_datetime1 m1 on m1.col1=m2.col2 where m1.id1 > (select max(id1)/3 from md_datetime1) inner join md_datetime3 m3 on m2.col2=m3.col2 set m2.col1='updated4';
--TEST: success, 8 rows updated
update md_datetime2 m2 left outer join md_datetime1 m1 on m1.col1=m2.col2 inner join md_datetime3 m3 on m3.col2=m1.col1 set m3.col1=m2.col1, m1.id1=truncate(m2.id2, 3) where m3.id3 < (select max(id2)/100 from md_datetime2);
--TEST: check update result
select if (count(*) = 4, 'ok', 'nok') from md_datetime1 where truncate(id1, 3)=id1;
select if (count(*) > 3, 'ok', 'nok') from md_datetime3 where col1 in ('aa', 'abc', 'a', 'ababc', 'mysql', 'hellohello');


--TEST: right outer join
--TEST: success, 7 rows updated
update md_datetime1 m1 right outer join md_datetime2 m2 on m1.col1=m2.col2 right outer join md_datetime3 m3 on m3.col2=m2.col2 set m3.col1='updated5', m2.col1='updated5', m1.id1=round(m2.id2), m2.col2=m1.col1+1 where m3.id3 < (select abs(avg(id2)) from md_datetime2);
--check update result
select if (count(*)= 4, 'ok', 'nok') from md_datetime1 where round(id1)=id1;
select if (count(*) = 8, 'ok', 'nok') from md_datetime2 where col1='updated5';
select if (count(*) = 6, 'ok', 'nok') from md_datetime3 where col1='updated5';



drop table md_datetime1, md_datetime2, md_datetime3;







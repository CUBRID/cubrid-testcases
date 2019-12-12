--update 2 tables with list partition



create table md_char1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 char(50) primary key)
partition by list(col2) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc')
);
insert into md_char1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table md_char2(col1 varchar(1024), id2 numeric(10, 5), index i(id2 desc, col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc', 'abcabcabc'),
partition p3 values in ('a', 'aa', 'aaa', 'aaaa'),
partition p4 values in ('hello', 'hellohello')
);
insert into md_char2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into md_char2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from md_char1 order by 1;
select * from md_char2 order by 1;


--TEST: error, false join condition
update md_char1 m1, md_char2 m2 set m1.id1=m2.id2 where m1.col2=m2.id2;


--TEST: count in p4 before update
select if (count(*) = 2, 'ok', 'nok') from md_char2__p__p4;
--TEST: without table aliases, 1 row updated in each table
update md_char1, md_char2 set md_char1.col1=md_char1.col1+5, md_char2.col1='hello' where md_char1.col2=md_char2.col1 and char_length(md_char1.col1) > 5 and md_char1.id1=md_char2.id2;
--TEST: check update result
select if (col1 = '2011-09-01 12:12:18', 'ok', 'nok') from md_char1 where col2='mysql';
select if (count(*) = 3, 'ok', 'nok') from md_char2__p__p4;


--TEST: error, update with a value not in the partition value list
update md_char1 m1, md_char2 m2 set m1.col2='updated1' where m1.col2=m2.col1 and round(m2.id2) in (1234, 5555, 5657, 667);


--TEST: add a partition
alter table md_char1 reorganize partition p2 into
(partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc'),
partition p3 values in ('updated1', 'updated2', 'updated3', 'updated4'));
--TEST: check alter result
select if (count(*) = 0, 'ok', 'nok') from md_char1__p__p3;


--TEST: inner join, unique violation
update md_char1 as m1 inner join (select id2, trim(substr(col1, 1, 6)) as col1 from md_char2 where left(col1, 3) = 'abc') m2 on left(m1.col2, 3)=left(m2.col1, 3) set m1.col2='updated1';
--TEST: drop primary key
alter table md_char1 drop primary key;
--TEST: update again, success, 2 rows updated
update md_char1 as m1 inner join (select id2, trim(substr(col1, 1, 6)) as col1 from md_char2 where left(col1, 3) = 'abc') m2 on left(m1.col2, 3)=left(m2.col1, 3) set m1.col2='updated1';
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_char1__p__p3;


--TEST: success, 4 rows updated
update md_char1 m1 left outer join md_char2 m2 on m1.col2=m2.col1 set m1.col2='updated2', m1.id1=m2.id2, m2.id2=m1.id1 where m1.id1 > (select abs(avg(id2)) from md_char2);
--TEST: check update result;
select if (count(*) = 2, 'ok', 'nok') from md_char1__p__p1;
select if (count(*) = 0, 'ok', 'nok') from md_char1__p__p2;
select if (count(*) = 4, 'ok', 'nok') from md_char1__p__p3;
select case when count(*)=2 then 'ok' else 'nok' end from md_char1 where id1 is null;

--TEST: right outer join
--TEST: success, 7 rows updated
update md_char1 m1 right outer join md_char2 m2 on m1.col2=m2.col1 set m2.col1='aaa', m2.id2=m1.id1*5, m1.col1=m1.col1+3600, m1.col2='updated4' where m2.id2 < (select avg(id1) from md_char1);
--TEST: check update result;
select if (count(*) = 0, 'ok', 'nok') from md_char2__p__p1;
select if (count(*) = 3, 'ok', 'nok') from md_char2__p__p2;
select if (count(*) = 7, 'ok', 'nok') from md_char2__p__p3;
select if (count(*) = 2, 'ok', 'nok') from md_char2__p__p4;
select if (count(*) = 1, 'ok', 'nok') from md_char1__p__p1;
select if (count(*) = 0, 'ok', 'nok') from md_char1__p__p2;
select if (count(*) = 5, 'ok', 'nok') from md_char1__p__p3;
select case when count(*)=5 then 'ok' else 'nok' end from md_char2 where id2 is null;
select case when hour(col1)=13 then 'ok' else 'nok' end from md_char1 where col2='updated4';



drop table md_char1, md_char2;







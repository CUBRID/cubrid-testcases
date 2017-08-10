--update 2 tables with time type column for join condition, with composed index

drop table if exists md_time1;
drop table if exists md_time2;

create table md_time1(id1 bigint, col1 time not null, primary key(id1, col1 asc));
insert into md_time1 values(1000000, '12:12:12'), (2000000, '12:12:13'), (3000000, '12:12:14'), (4000000, '12:12:15'), (5000000, '12:12:16'), (6000000, '12:12:17'), (7000000, '12:12:15'), (3000000, '12:12:18'), (5000000, '12:12:12');


create table md_time2(col1 varchar(1024), id2 bigint primary key, col2 time);
insert into md_time2 values('cubrid', 1111111, '11:11:11'), ('abc', 2222222, '12:12:12'), ('a', 5000000, '12:12:15'), ('abcabc', 4444444, '10:10:10'), ('aa', 5555555, '12:12:13'), ('mysql', 2000000, '12:12:13');
insert into md_time2 values('cubridcubrid', 6666666, '13:13:13'), ('mysqlmysql', 4000000, '12:12:16'), ('aaaa', 565656565, '12:12:12'), ('abcabcabc', 6000000, '12:12:16'), ('hello', 7788777, '14:14:14'), ('hellohello', 90000909, '12:12:17');


select * from md_time1 order by 1;
select * from md_time2 order by 1;


--TEST: without table aliases, 1 row updated
update md_time1, md_time2 set md_time2.col1='updated1' where md_time1.col1=md_time2.col2 and md_time1.id1=md_time2.id2 and length(trim(md_time2.col1))>2;
--TEST: check test result
select if (count(*) = 1, 'ok', 'nok') from md_time2 where col1='updated1';


--TEST: error, group by clause in update statement
update md_time1 m1, md_time2 m2 set m1.id1=floor(m2.id2), m2.col1='updated2' where m1.col1 = m2.col2 group by m2.col2;


--TEST: error, inner join, 2 rows updated, 2-2 matched, duplicate entry error in mysql
update md_time1 as m1 inner join (select id2, time(col2) as col2 from md_time2 where second(col2)=12) as m2 on m1.col1=m2.col2 set m1.id1=m2.id2;
update md_time1 as m1 inner join md_time2 as m2 on m1.col1=m2.col2 set m2.id2=m1.id1 where second(col2)=12;


--TEST: error, unique key violation
update md_time1 m1 left outer join md_time2 m2 on m1.col1=m2.col2 set m2.col1='updated3', m2.id2=m1.id1 where m1.id1 > (select avg(id1) from md_time1);
--TEST: success, 10 rows updated
update md_time1 m1 left outer join md_time2 m2 on m1.col1=m2.col2 set m1.id1=(select min(id2) from md_time2 where m1.col1=col2), m2.col1='updated4' where m1.id1 > (select avg(id1) from md_time1);
--TEST: check update result
select case when id1 in (2222222, 565656565, 1000000) then 'ok' else 'nok' end from md_time1 where second(col1)=12;
select case when id1 in (4000000, 6000000) then 'ok' else 'nok' end from md_time1 where second(col1)=16;
select if (count(*) = 6, 'ok', 'nok') from md_time2 where col1='updated4';


--TEST: right outer join
--TEST: error, update and select from the same table
update md_time1 m1 right outer join md_time2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval -1 second), m2.col1='updated5' where m1.id1 < (select avg(id2) from md_time2);
--TEST: success
update md_time1 m1 right outer join md_time2 m2 on m1.col1=m2.col2 set m1.col1=m2.col2-1, m2.col1='updated5' where m1.id1 < (select avg(id2) from md_time2);
--TEST: check update result
select * from md_time1 order by id1;
select case when count(*)=7 then 'ok' else 'nok' end from md_time2 where col1='updated5';



drop table md_time1, md_time2;







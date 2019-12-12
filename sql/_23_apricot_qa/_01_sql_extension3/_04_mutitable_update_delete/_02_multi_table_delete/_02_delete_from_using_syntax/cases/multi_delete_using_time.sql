--delete from 2 tables with time type column for join condition, with composed index



create table md_time1(id1 bigint, col1 time not null, primary key(id1, col1 asc));
insert into md_time1 values(1000000, '12:12:12'), (2000000, '12:12:13'), (3000000, '12:12:14'), (4000000, '12:12:15'), (5000000, '12:12:16'), (6000000, '12:12:17'), (7000000, '12:12:15');


create table md_time2(col1 varchar(1024), id2 bigint primary key, col2 time);
insert into md_time2 values('cubrid', 1111111, '11:11:11'), ('abc', 2222222, '12:12:12'), ('a', 5000000, '12:12:15'), ('abcabc', 4444444, '10:10:10'), ('aa', 5555555, '12:12:13'), ('mysql', 2000000, '12:12:13');
insert into md_time2 values('cubridcubrid', 6666666, '13:13:13'), ('mysqlmysql', 4000000, '12:12:16'), ('aaaa', 565656565, '12:12:12'), ('abcabcabc', 6000000, '12:12:16'), ('hello', 7788777, '14:14:14'), ('hellohello', 90000909, '12:12:17');


select * from md_time1 order by 1;
select * from md_time2 order by 1;


--without table aliases, 2 rows deleted
delete from md_time1, md_time2 using md_time1, md_time2 where md_time1.col1=md_time2.col2 and md_time1.id1=md_time2.id2 and length(trim(md_time2.col1))>2;
select * from md_time1 order by 1;
select * from md_time2 order by 1;


--error, group by clause in delete statement
delete from m1, m2 using md_time1 m1, md_time2 m2 where m1.col1 > m2.col2 group by m2.col1;
select if (count(*) = 6, 'ok', 'nok') from md_time1;
select if (count(*) = 11, 'ok', 'nok') from md_time2;


--inner join, 2 rows deleted
delete from m1.* using md_time1 as m1 inner join (select id2, time(col2) as col2 from md_time2 where second(col2)=15) as m2 on m1.col1=m2.col2;
select * from md_time1 order by 1;
select if (count(*) = 11, 'ok', 'nok') from md_time2;

--left outer join, delete and select from the same table
delete from m1, md_time2 using md_time1 m1 left outer join md_time2 on m1.col1=md_time2.col2 where m1.id1 > (select avg(id1) from md_time1);
select if (count(*) = 2, 'ok', 'nok') from md_time1;
select if (count(*) = 8, 'ok', 'nok') from md_time2;


--right outer join
delete from m1, m2 using md_time1 m1 right outer join md_time2 m2 on m1.col1=m2.col2 where m1.id1 < (select avg(id2) from md_time2);
select if (count(*) = 1, 'ok', 'nok') from md_time1;
select if (count(*) = 6, 'ok', 'nok') from md_time2;



drop table md_time1, md_time2;







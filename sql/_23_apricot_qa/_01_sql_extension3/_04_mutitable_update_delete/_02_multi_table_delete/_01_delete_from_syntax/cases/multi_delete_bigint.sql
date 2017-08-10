--TEST: delete from 2 tables with bigint type column for join condition, with composed index

create table md_bigint1(id1 bigint, col1 timestamp not null default CURRENT_TIMESTAMP, index i(id1, col1 asc));
insert into md_bigint1 values(1000000, '2011-09-01 12:12:12'), (2000000, '2011-09-01 12:12:13'), (3000000, '2011-09-01 12:12:14'), (4000000, '2011-09-01 12:12:15'), (5000000, '2011-09-01 12:12:16'), (6000000, '2011-09-01 12:12:17');


create table md_bigint2(col1 varchar(1024), id2 bigint primary key);
insert into md_bigint2 values('cubrid', 1111111), ('abc', 2222222), ('a', 5000000), ('abcabc', 4444444), ('aa', 5555555), ('mysql', 2000000);
insert into md_bigint2 values('cubridcubrid', 6666666), ('mysqlmysql', 4000000), ('aaaa', 565656565), ('abcabcabc', 6000000), ('hello', 7788777), ('hellohello', 90000909);


select * from md_bigint1 order by 1;
select * from md_bigint2 order by 1;


--TEST: without table aliases
delete md_bigint1 from md_bigint1, md_bigint2 where md_bigint1.id1=md_bigint2.id2 and char_length(md_bigint2.col1) < 5;
select * from md_bigint1 order by 1;
select if (count(*) = 12, 'ok', 'nok') from md_bigint2;


--TEST: with table aliases
delete m2 from md_bigint1 m1, md_bigint2 m2 where m1.id1=m2.id2 and m1.col1='2011-09-01 12:12:13';
select if (count(*) = 5, 'ok', 'nok') from md_bigint1;
select * from md_bigint2 order by 1;


--TEST: error, delete from a derived table
delete m1, m2 from md_bigint1 as m1 inner join (select id2 from md_bigint2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
--TEST: inner join, no matched results
delete m1 from md_bigint1 as m1 inner join (select id2 from md_bigint2 where left(col1, 6) = 'cubrid') m2 on m1.id1=m2.id2;
select if (count(*) = 5, 'ok', 'nok') from md_bigint1;
select if (count(*) = 11, 'ok', 'nok') from md_bigint2;


--TEST: left outer join, delete and select from the same table
delete m1, md_bigint2 from md_bigint1 m1 left outer join md_bigint2 on m1.id1=md_bigint2.id2 where m1.id1 > (select avg(id1) from md_bigint1);
select if (count(*) = 3, 'ok', 'nok') from md_bigint1;
select * from md_bigint2 order by 1;


--TEST: right outer join
delete m1, m2 from md_bigint1 m1 right outer join md_bigint2 m2 on m1.id1=m2.id2 where m1.id1 < (select avg(id2) from md_bigint2);
select if (count(*) = 3, 'ok', 'nok') from md_bigint1;
select if (count(*) = 9, 'ok', 'nok') from md_bigint2;



drop table md_bigint1, md_bigint2;







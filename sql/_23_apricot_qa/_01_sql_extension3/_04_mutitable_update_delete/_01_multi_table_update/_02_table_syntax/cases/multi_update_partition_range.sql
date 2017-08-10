--update 2 tables with range partition



create table md_p_range1(id1 bigint, col1 time not null, primary key(id1, col1 asc))
partition by range(col1)
(partition p1 values less than (time'12:12:13'),
partition p2 values less than (time'12:12:15'),
partition p3 values less than (time'12:12:18'));

insert into md_p_range1 values(1000000, '12:12:12'), (2000000, '12:12:13'), (3000000, '12:12:14'), (4000000, '12:12:15'), (5000000, '12:12:16'), (6000000, '12:12:17'), (7000000, '12:12:15');


create table md_p_range2(col1 varchar(1024), id2 bigint, col2 time, primary key(id2,col2))
partition by range(col2)
(partition p1 values less than (time'12:12:12'),
partition p2 values less than (time'12:12:16'),
partition p3 values less than (time'14:14:15'));
insert into md_p_range2 values('cubrid', 1111111, '11:11:11'), ('abc', 2222222, '12:12:12'), ('a', 5000000, '12:12:15'), ('abcabc', 4444444, '10:10:10'), ('aa', 5555555, '12:12:13'), ('mysql', 2000000, '12:12:13');
insert into md_p_range2 values('cubridcubrid', 6666666, '13:13:13'), ('mysqlmysql', 4000000, '12:12:16'), ('aaaa', 565656565, '12:12:12'), ('abcabcabc', 6000000, '12:12:16'), ('hello', 7788777, '14:14:14'), ('hellohello', 90000909, '12:12:17');


select * from md_p_range1 order by 1;
select * from md_p_range2 order by 1;


--TEST: error, update 2 partitions
update md_p_range1__p__p1 m1, md_p_range2__p__p3 m2 set m1.col1=SYSTIMESTAMP where m1.col1=m2.col2 and m1.id1=m2.id2 and length(trim(m.col1))>2;


--TEST: error, group by clause in update statement
update md_p_range1 m1, md_p_range2 m2 set m1.col1=SYSTIMESTAMP where m1.col1 > m2.col2 group by m2.col1;


--TEST: check count in a partition before update
select if (count(*) = 4, 'ok', 'nok') from md_p_range1__p__p3;
select if (count(*) = 1, 'ok', 'nok') from md_p_range1__p__p1;
--TEST: update partition tables. 2 rows updated
update md_p_range1 as m1 inner join (select id2, time(col2) as col2 from md_p_range2 where second(col2)=15) as m2 on m1.col1=m2.col2 set m1.col1='12:12:11';
--TEST: check update result
select if (count(*) = 2, 'ok', 'nok') from md_p_range1__p__p3;
select if (count(*) = 3, 'ok', 'nok') from md_p_range1__p__p1;


--TEST: success, 3 rows updated
update md_p_range1 m1 left outer join md_p_range2 m2 on m1.col1=m2.col2 set m2.id2=m2.id2+3000000, m2.col2=m1.col1-1 where m1.id1 > (select avg(id1) from md_p_range1);
--TEST: check update result
select if (count(*) = 7, 'ok', 'nok') from md_p_range2__p__p2;
select if (count(*) = 3, 'ok', 'nok') from md_p_range2__p__p3;


--TEST: right outer join
--TEST: error, set with value that is out of partition value
update md_p_range1 m1 right outer join md_p_range2 m2 on m1.col1=m2.col2 set m1.col1='12:12:19' where m1.id1 < (select avg(id2) from md_p_range2);
--TEST: success, 3 rows updated
update md_p_range1 m1 right outer join md_p_range2 m2 on m1.col1=m2.col2 set m1.col1=m2.col2-2, m2.col2=m1.col1 where m1.id1 < (select avg(id2) from md_p_range2);
--TEST: check update result
select if (count(*) = 4, 'ok', 'nok') from md_p_range1__p__p1;
select if (count(*) = 2, 'ok', 'nok') from md_p_range1__p__p2;
select if (count(*) = 1, 'ok', 'nok') from md_p_range1__p__p3;


--TEST: inner join, no matched rows
update md_p_range1 m1 inner join  md_p_range2 m2 on m1.col1=m2.col2 set m1.id1=102020202020202, m2.col1='updated44444444444444';



drop table md_p_range1, md_p_range2;







--join updatable and non-updatable VIEWs in the table-specification and attempt to update them



create table md_datetime1(id1 double, col1 datetime default SYS_DATETIME);
insert into md_datetime1 values(1111111.11111, '2011-09-01 12:12:12.123'), (2222222.22222, '2011-09-01 12:12:13.123'), (33333333.33333, '2011-09-01 12:12:14.123'), (4444444.44444, '2011-09-01 12:12:15.123'), (5555555.55555, '2011-09-01 12:12:16.123'), (6666666.66666, '2011-09-01 12:12:17.123'), (7777777.77777, '2011-10-10 1:1:1.123'), (8888888.88888, '2011-10-10 2:2:2.123'), (9999999.99999, '2011-11-11 11:11:11.123'), (1010101010.123, '2012-12-12 8:8:8.123');


create table md_datetime2(col1 varchar(996), id2 double, col2 datetime, index i(col1, col2));
insert into md_datetime2 values('cubrid', 1234.12345, '2011-09-01 12:12:12.123'), ('abc', 3333333456.34555, '2011-09-01 12:12:12.123'), ('a', 55555.55555, '2011-09-01 12:12:13.123'), ('abcabc', 4444444.12345, '2011-09-01 12:12:13.123'), ('aa', 5555.1234, '2011-09-01 12:12:14.123'), ('mysql', 2222222.22222, '2011-09-01 12:12:14.123');
insert into md_datetime2 values('cubridcubrid', 666.6666, '2020-12-12 1:1:1.123'), ('mysqlmysql', 44444.44444444, '1988-10-10 2:2:2.123'), ('aaaa', 5555656.56565, '2011-09-01 12:12:17.123'), ('abcabcabc', 6666666.66666, '2011-10-10 2:2:2.123'), ('hello', 777777777.88777, '1988-10-10 3:3:3.123'), ('hellohello', 90000.909, '2012-12-12 8:8:8.123');


--create an updatable view
create view md_v1 as select * from md_datetime1 order by 1;
--create a non-updatable view
create view md_v2 as select m1.id1, m1.col1, m2.id2, m2.col1 as col2, m2.col2 as col3 from md_datetime1 m1, md_datetime2 m2 where m1.col1=m2.col2;


select * from md_v1 order by 1;
select * from md_v2 order by 1, 2, 3, 4;


--TEST: [er] 1 updatable view + 1 non-updatable view, attempt to update the non-updatable one
update md_v1, md_v2 set md_v1.col1=date_add(md_v2.col2, interval -3 day), md_v2.col2='updated1' where md_v1.col1=md_v2.col2 and truncate(md_v1.id1, 2)=truncate(md_v2.id2, 2);


--TEST: [er] with table aliases, update non-updatable view
update md_v1 m1, md_v2 m2 set m1.id1=truncate(m2.id2, 3), m2.col2='updated1' where m1.col1=m2.col2 and (m2.id2>3333333456 or m2.id2<1235);
--TEST: check update result
select if (count(*) = 0, 'ok', 'nok') from md_v2 where col2='updated1';


--TEST: 1 updatable view + 1 derived table from a non-updatable view), inner join, 1 row updated
update md_v1 as m1 inner join (select id2, substr(col1, 1, 6), col3 from md_v2) m2 on m1.col1=m2.col3 set m1.id1=floor(m1.id1) where m1.id1 > (select sum(id2)/5 from md_v2);
--TEST: check update result
select if (count(*) = 1, 'ok', 'nok') from md_v1 where id1=round(id1);


--TEST: 1 table + 1 non-updatable view, update the table, it should succeed
update md_v2 m2 left outer join md_datetime1 m1 on m1.col1=m2.col3 set m1.id1=truncate(m2.id1, 2) where m1.id1 < (select max(id2)/100 from md_v2);
--TEST: check update result
select if (count(*) = 6, 'ok', 'nok') from md_v1 where truncate(id1, 2)=id1;
--TEST: 1 table + 1 non-updatable view, attempt to update the view, it should fail
update md_v2 m2 left outer join md_datetime1 m1 on m1.col1=m2.col2 set m2.col2='updated2' where m1.id1 < (select max(id2)/100 from md_v2);

create view md_v3 as select * from md_datetime2;
--TEST: 1 table + 1 updatable view, update the both the table and the view
update md_v3 m2 left outer join md_datetime1 m1 on m1.col1=m2.col2 set m2.col1='updated2', m1.id1=m2.id2 where m1.id1 < (select max(id2)/100 from md_v3);
select if (count(*) = 8, 'ok', 'nok') from md_v3 where col1='updated2';


--TEST: right outer join
--TEST: [er] update non-updatable view 
update md_v1 m1 right outer join md_v2 m2 on m1.col1=m2.col2 set m1.col1=date(m2.col2), m2.col2='updated3' where m1.id1 < (select abs(avg(id2)) from md_v2);
--TEST: [er] update a derived table
update md_v2 m2 right outer join (select round(id1) as id1, col1 from md_v1 where length(col1) < 100) m1 on time(m1.col1)=time(m2.col3) set m1.col1=date(m2.col2);
--TEST: [er] update a derived table
update md_v2 m2 right outer join md_v1 m1 on time(m1.col1)=time(m2.col3) set m1.col1=date(m2.col3);
--TEST: check update result
select if (count(*) = 4, 'ok', 'nok') from md_v1 where col1 is null;



drop view md_v1, md_v2, md_v3;
drop table md_datetime1, md_datetime2;






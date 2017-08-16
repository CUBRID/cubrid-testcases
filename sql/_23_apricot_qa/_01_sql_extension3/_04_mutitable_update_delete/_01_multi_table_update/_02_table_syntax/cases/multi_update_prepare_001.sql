--multi-table update with prepare statement



create table md_time1(id1 bigint, col1 time not null, primary key(id1, col1 asc));

prepare stmt from 'insert into md_time1 values(?, ?)'
execute stmt using 1000000, '12:12:12' 
execute stmt using 2000000, '12:12:13'
execute stmt using 3000000, '12:12:14'
execute stmt using 4000000, '12:12:15'
execute stmt using 5000000, '12:12:16'
execute stmt using 6000000, '12:12:17'
execute stmt using 7000000, '12:12:15'
execute stmt using 3000000, '12:12:18'
execute stmt using 5000000, '12:12:12'
deallocate prepare stmt;


create table md_time2(col1 varchar(1024), id2 bigint primary key, col2 time);

prepare stmt from 'insert into md_time2 values(?, ?, ?)'
execute stmt using 'cubrid', 1111111, '11:11:11'
execute stmt using 'abc', 2222222, '12:12:12'
execute stmt using 'a', 5000000, '12:12:15'
execute stmt using 'abcabc', 4444444, '10:10:10'
execute stmt using 'aa', 5555555, '12:12:13'
execute stmt using 'mysql', 2000000, '12:12:13'
execute stmt using 'cubridcubrid', 6666666, '13:13:13'
execute stmt using 'mysqlmysql', 4000000, '12:12:16'
execute stmt using 'aaaa', 565656565, '12:12:12'
execute stmt using 'abcabcabc', 6000000, '12:12:16'
execute stmt using 'hello', 7788777, '14:14:14'
execute stmt using 'hellohello', 90000909, '12:12:17'
deallocate prepare stmt

select * from md_time1 order by 1;
select * from md_time2 order by 1;


--TEST: without table aliases, 1 row updated
prepare stmt from 'update md_time1, md_time2 set md_time2.col1=? where md_time1.col1=md_time2.col2 and md_time1.id1=md_time2.id2 and length(trim(md_time2.col1))>?';
execute stmt using 'updated1', 2;
deallocate prepare stmt;
--TEST: check test result
select if (count(*) = 1, 'ok', 'nok') from md_time2 where col1='updated1';


--TEST: error, group by clause in update statement
prepare stmt from 'update md_time1 m1, md_time2 m2 set m1.id1=floor(m2.id2), m2.col1=? where m1.col1 = m2.col2 group by m2.col2';
execute stmt using 'updated2';
deallocate prepare stmt;


--TEST: [er], inner join, 2 rows updated, 2-2 matched, duplicate entry error in mysql
prepare stmt from 'update md_time1 as m1 inner join (select id2, time(col2) as col2 from md_time2 where second(col2)=?) as m2 on m1.col1=m2.col2 set m1.id1=m2.id2';
execute stmt using 12;
deallocate prepare stmt;


--TEST: error, unique key violation
prepare stmt from 'update md_time1 m1 left outer join md_time2 m2 on m1.col1=m2.col2 set m2.col1=?, m2.id2=m1.id1 where m1.id1 > (select avg(id1) from md_time1)';
execute stmt using 'updated3';
deallocate prepare stmt;
--TEST: success, 6 rows updated
prepare stmt from 'update md_time1 m1 left outer join md_time2 m2 on m1.col1=m2.col2 set m2.col1=?, m1.id1=m2.id2+5 where m1.id1 > (select avg(id1) from md_time1) and m2.id2 <> 565656565';
execute stmt using 'updated4';
deallocate prepare stmt;
--TEST: check update result
select if (count(*) = 5, 'ok', 'nok') from md_time2 where col1='updated4';


--TEST: right outer join
--TEST: [er] date_add function error
prepare stmt from 'update md_time1 m1 right outer join md_time2 m2 on m1.col1=m2.col2 set m1.col1=date_add(m2.col2, interval ? second), m2.col1=? where m1.id1 < (select avg(id2) from md_time2)';
execute stmt using -1, 'updated5';
deallocate prepare stmt;
--TEST: success
prepare stmt from 'update md_time1 m1 right outer join md_time2 m2 on m1.col1=m2.col2 set m1.col1=m2.col2-?, m2.col1=? where m1.id1 < (select avg(id2) from md_time2)';
execute stmt using 1, 'updated5';
deallocate prepare stmt;
--TEST: check update result
select case when count(*)=7 then 'ok' else 'nok' end from md_time2 where col1='updated5';



drop table md_time1, md_time2;







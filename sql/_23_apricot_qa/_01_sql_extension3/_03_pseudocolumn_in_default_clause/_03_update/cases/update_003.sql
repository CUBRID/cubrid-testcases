--update columns with default value of SYSTIMESTAMP



create table u03(id int primary key, col1 timestamp default SYSTIMESTAMP unique, col2 timestamp default SYSTIMESTAMP not null, col3 timestamp default SYSTIMESTAMP, col4 timestamp default SYSTIMESTAMP);

insert into u03 values(1, timestamp'12/12/2000 12:12:12', '12/12/2000 12:12:12', '12/12/2000 12:12:12', '12/12/2000 12:12:12');
insert into u03 values(2, timestamp'11/11/2000 11:11:11', '11/11/2000 11:11:11', '11/11/2000 11:11:11', '11/11/2000 11:11:11');
insert into u03 values(3, timestamp'10/10/2000 10:10:10', '10/10/2000 10:10:10', '10/10/2000 10:10:10', '10/10/2000 10:10:10');
insert into u03 values(4, timestamp'09/09/2000 09:09:09', '09/09/2000 09:09:09', '09/09/2000 09:09:09', '09/09/2000 09:09:09');
insert into u03 values(5, timestamp'08/08/2000 08:08:08', '08/08/2000 08:08:08', '08/08/2000 08:08:08', '08/08/2000 08:08:08');


--TEST: error, unique constraint violance
update u03 set col1=default;

update u03 set col2=default;
select if ((CURRENT_TIMESTAMP - col2) <= 100, 'ok', 'nok') from u03;

--TEST: where clause
update u03 set col1=default where id=1;
select if ((CURRENT_TIMESTAMP - col1) <= 100, 'ok', 'nok') from u03 where id=1;
update u03 set col3=default, col4=default, col2=default where id=1;
select if ((CURRENT_TIMESTAMP - col3) <= 100, 'ok', 'nok') from u03 where id=1;
select if ((CURRENT_TIMESTAMP - col4) <= 100, 'ok', 'nok') from u03 where id=1;
select if (col2 = col3, 'ok', 'nok') from u03 where id=1;


--TEST: order by clause
update u03 set col2=default where id > 1 order by id desc;
select if ((CURRENT_TIMESTAMP - col2) <= 100, 'ok', 'nok') from u03 where id>1;


--TEST: error, order by and limit
update u03 set col3=default + 1, col4=default where id < 4 order by id desc limit 1;
--TEST: order by and limit
update u03 set col3=default, col4=default where id < 4 order by id desc limit 1;
select if ((CURRENT_TIMESTAMP - col3) <= 100, 'ok', 'nok') from u03 where id=3;
select if (col3='11/11/2000 11:11:11', 'ok', 'nok') from u03 where id=2;
update u03 set col3=default order by id desc limit 2;
select if ((CURRENT_TIMESTAMP - col3) <= 100, 'ok', 'nok') from u03 where id>3;

select if (count(*) = 5, 'ok', 'nok') from u03;


drop table u03;





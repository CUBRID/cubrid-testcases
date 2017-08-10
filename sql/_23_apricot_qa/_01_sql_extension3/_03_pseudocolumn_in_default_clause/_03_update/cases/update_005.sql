--update columns with default value of SYSDATETIME



create table u05(id int primary key, col1 datetime default SYSDATETIME unique, col2 datetime default SYSDATETIME not null, col3 datetime default SYSDATETIME, col4 datetime default SYSDATETIME);

insert into u05 values(1, datetime'12/12/2000 12:12:12.123', '12/12/2000 12:12:12.123', '12/12/2000 12:12:12.123', '12/12/2000 12:12:12.123');
insert into u05 values(2, datetime'11/11/2000 11:11:11.123', '11/11/2000 11:11:11.123', '11/11/2000 11:11:11.123', '11/11/2000 11:11:11.123');
insert into u05 values(3, datetime'10/10/2000 10:10:10.123', '10/10/2000 10:10:10.123', '10/10/2000 10:10:10.123', '10/10/2000 10:10:10.123');
insert into u05 values(4, datetime'09/09/2000 09:09:09.123', '09/09/2000 09:09:09.123', '09/09/2000 09:09:09.123', '09/09/2000 09:09:09.123');
insert into u05 values(5, datetime'08/08/2000 08:08:08.123', '08/08/2000 08:08:08.123', '08/08/2000 08:08:08.123', '08/08/2000 08:08:08.123');


--TEST: error, unique constraint violance
update u05 set col1=default;

update u05 set col2=default;
select if ((SYSDATETIME - col2) <= 5000, 'ok', 'nok') from u05;

--TEST: where clause
update u05 set col1=default where id=1;
select if ((SYSDATETIME - col1) <= 5000, 'ok', 'nok') from u05 where id=1;
update u05 set col3=default, col4=default, col2=default where id=1;
select if ((SYSDATETIME - col3) <= 5000, 'ok', 'nok') from u05 where id=1;
select if ((SYSDATETIME - col4) <= 5000, 'ok', 'nok') from u05 where id=1;
select if (col2 = col3, 'ok', 'nok') from u05 where id=1;


--TEST: order by clause
update u05 set col2=default where id > 1 order by id desc;
select if ((SYSDATETIME - col2) <= 5000, 'ok', 'nok') from u05 where id>1;


--TEST: error, order by and limit
update u05 set col3=default + 1, col4=default where id < 4 order by id desc limit 1;
--TEST: order by and limit
update u05 set col3=default, col4=default where id < 4 order by id desc limit 1;
select if ((SYSDATETIME - col3) <= 5000, 'ok', 'nok') from u05 where id=3;
select if (col3='11/11/2000 11:11:11.123', 'ok', 'nok') from u05 where id=2;
update u05 set col3=default order by id desc limit 2;
select if ((SYSDATETIME - col3) <= 5000, 'ok', 'nok') from u05 where id>3;

select if (count(*) = 5, 'ok', 'nok') from u05;


drop table u05;





--update columns with default value of SYSDATE



create table u04(id int primary key, col1 date default SYSDATE unique, col2 date default SYSDATE not null, col3 date default SYSDATE, col4 date default SYSDATE);

insert into u04 values(1, date'12/12/2000', '12/12/2000', '12/12/2000', '12/12/2000');
insert into u04 values(2, date'11/11/2000', '11/11/2000', '11/11/2000', '11/11/2000');
insert into u04 values(3, date'10/10/2000', '10/10/2000', '10/10/2000', '10/10/2000');
insert into u04 values(4, date'09/09/2000', '09/09/2000', '09/09/2000', '09/09/2000');
insert into u04 values(5, date'08/08/2000', '08/08/2000', '08/08/2000', '08/08/2000');


--TEST: error, unique constraint violance
update u04 set col1=default;

update u04 set col2=default;
select if ((SYSDATE - col2) <= 1, 'ok', 'nok') from u04;

--TEST: where clause
update u04 set col1=default where id=1;
select if (SYSDATE = col1, 'ok', 'nok') from u04 where id=1;
update u04 set col3=default, col4=default, col2=default where id=1;
select if (SYSDATE = col3, 'ok', 'nok') from u04 where id=1;
select if (SYSDATE = col4, 'ok', 'nok') from u04 where id=1;
select if (col2 = col3, 'ok', 'nok') from u04 where id=1;


--TEST: order by clause
update u04 set col2=default where id > 1 order by id desc;
select if (SYSDATE = col2, 'ok', 'nok') from u04 where id>1;


--TEST: error, order by and limit
update u04 set col3=default + 1, col4=default where id < 4 order by id desc limit 1;
--TEST: order by and limit
update u04 set col3=default, col4=default where id < 4 order by id desc limit 1;
select if (SYSDATE = col3, 'ok', 'nok') from u04 where id=3;
select if (col3='11/11/2000', 'ok', 'nok') from u04 where id=2;
update u04 set col3=default order by id desc limit 2;
select if (SYSDATE = col3, 'ok', 'nok') from u04 where id>3;

select if (count(*) = 5, 'ok', 'nok') from u04;


drop table u04;





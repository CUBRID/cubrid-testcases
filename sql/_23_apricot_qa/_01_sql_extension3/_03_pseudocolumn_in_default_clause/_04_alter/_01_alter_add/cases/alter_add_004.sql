--add columns with default value of SYSDATE


set system parameters 'add_column_update_hard_default=no';


create table a04(id short primary key auto_increment);
insert into a04 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a04;


alter table a04 add column col1 date default SYSDATE;
show columns in a04;
select if(col1 is not null, 'ok', 'nok') from a04;
insert into a04 values default;
select if ((SYSDATE - col1) =0, 'ok', 'nok') from a04 where id > 3;

alter table a04 add column col2 date default SYSDATE not null;
desc a04;
select if(col2 is not null, 'ok', 'nok') from a04;
insert into a04(col2) values (default);
select if ((SYSDATE - col2) =0, 'ok', 'nok') from a04 where id > 4;

alter table a04 add column col3 date default SYSDATE;
show columns in a04;
select if(col3 is not null, 'ok', 'nok') from a04;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a04(id) values(null);
select if ((SYSDATE - col3) =0, 'ok', 'nok') from a04 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a04 where id > 5;
insert into a04(col3) values(default), (default);

alter table a04 add column col4 date not null;
select if(col4 is null, 'ok', 'nok') from a04;
alter table a04 add column col5 date unique;
select if(col5 is null, 'ok', 'nok') from a04;
insert into a04(col3, col4, col5) values('2012-12-11', '2012-12-11', '2012-12-11');
select if ((SYSDATE - col2) =0 and col1 = col2, 'ok', 'nok') from a04 where id > 6;


drop table a04;






--add columns with default value of UNIX_TIMESTAMP()


set system parameters 'add_column_update_hard_default=no';


create table a02(id short primary key auto_increment);
insert into a02 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a02;


alter table a02 add column col1 timestamp default UNIX_TIMESTAMP();
show columns in a02;
select if(col1 is not null, 'ok', 'nok') from a02;
insert into a02 values default;
select if ((SYSTIMESTAMP - col1) <=1, 'ok', 'nok') from a02 where id > 3;

alter table a02 add column col2 timestamp default UNIX_TIMESTAMP() not null;
desc a02;
select if(col2 is not null, 'ok', 'nok') from a02;
insert into a02(col2) values (default);
select if ((SYSTIMESTAMP - col2) <=1, 'ok', 'nok') from a02 where id > 4;

alter table a02 add column col3 timestamp default UNIX_TIMESTAMP();
show columns in a02;
select if(col3 is not null, 'ok', 'nok') from a02;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a02(id) values(null);
select if ((SYSTIMESTAMP - col3) <=1, 'ok', 'nok') from a02 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a02 where id > 5;
insert into a02(col3) values(default), (default);

alter table a02 add column col4 timestamp not null;
select if(col4 is null, 'ok', 'nok') from a02;
alter table a02 add column col5 timestamp unique;
select if(col5 is null, 'ok', 'nok') from a02;
insert into a02(col3, col4, col5) values('2012-12-12 12:12:12', '2012-12-12 12:12:12', '2012-12-12 12:12:12');
select if ((SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from a02 where id > 6;


drop table a02;






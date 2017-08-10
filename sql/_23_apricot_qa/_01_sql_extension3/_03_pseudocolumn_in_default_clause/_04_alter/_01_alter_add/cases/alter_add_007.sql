--add columns with default value of CURRENT_USER


set system parameters 'add_column_update_hard_default=no';


create table a07(id short primary key auto_increment);
insert into a07 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a07;


alter table a07 add column col1 string default CURRENT_USER;
show columns in a07;
select if(col1 is not null, 'ok', 'nok') from a07;
insert into a07 values default;
select if (USER = col1, 'ok', 'nok') from a07 where id > 3;

alter table a07 add column col2 string default CURRENT_USER not null;
desc a07;
select if(col2 is not null, 'ok', 'nok') from a07;
insert into a07(col2) values (default);
select if (USER = col2, 'ok', 'nok') from a07 where id > 4;

alter table a07 add column col3 string default CURRENT_USER ;
show columns in a07;
select if(col3 is not null, 'ok', 'nok') from a07;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a07(id) values(null);
select if (USER = col3, 'ok', 'nok') from a07 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a07 where id > 5;
insert into a07(col3) values(default), (default);

alter table a07 add column col4 string not null;
select if(col4 is null, 'ok', 'nok') from a07;
alter table a07 add column col5 string unique;
select if(col5 is null, 'ok', 'nok') from a07;
insert into a07(col3, col4, col5) values('STRING', 'STRING', 'STRING');
select if (USER = col2 and col1 = col2 and col3 <> 'STRING', 'ok', 'nok') from a07 where id > 6;


drop table a07;






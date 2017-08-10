--add columns with default value of USER


set system parameters 'add_column_update_hard_default=no';


create table a06(id short primary key auto_increment);
insert into a06 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a06;


alter table a06 add column col1 varchar default USER;
show columns in a06;
select if(col1 is not null, 'ok', 'nok') from a06;
insert into a06 values default;
select if (CURRENT_USER = col1, 'ok', 'nok') from a06 where id > 3;

alter table a06 add column col2 varchar default USER not null;
desc a06;
select if(col2 is not null, 'ok', 'nok') from a06;
insert into a06(col2) values (default);
select if (CURRENT_USER = col2, 'ok', 'nok') from a06 where id > 4;

alter table a06 add column col3 varchar default USER;
show columns in a06;
select if(col3 is not null, 'ok', 'nok') from a06;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a06(id) values(null);
select if (CURRENT_USER = col3, 'ok', 'nok') from a06 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a06 where id > 5;
insert into a06(col3) values(default), (default);

alter table a06 add column col4 varchar not null;
select if(col4 is null, 'ok', 'nok') from a06;
alter table a06 add column col5 varchar unique;
select if(col5 is null, 'ok', 'nok') from a06;
insert into a06(col3, col4, col5) values('STRING', 'STRING', 'STRING');
select if (CURRENT_USER = col2 and col1 = col2 and col3 <> 'STRING', 'ok', 'nok') from a06 where id > 6;

drop table a06;






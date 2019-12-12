--add columns with default value of SYSTIMESTAMP


set system parameters 'add_column_update_hard_default=no';


create table a03(id short primary key auto_increment);
insert into a03 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a03;


alter table a03 add column col1 timestamp default SYSTIMESTAMP;
show columns in a03;
select if(col1 is not null, 'ok', 'nok') from a03;
insert into a03 values default;
select if ((CURRENT_TIMESTAMP - col1) <=1, 'ok', 'nok') from a03 where id > 3;

alter table a03 add column col2 timestamp default SYSTIMESTAMP not null;
desc a03;
select if(col2 is not null, 'ok', 'nok') from a03;
insert into a03(col2) values (default);
select if ((CURRENT_TIMESTAMP - col2) <=1, 'ok', 'nok') from a03 where id > 4;

alter table a03 add column col3 timestamp default SYSTIMESTAMP;
show columns in a03;
select if(col3 is not null, 'ok', 'nok') from a03;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a03(id) values(null);
select if ((CURRENT_TIMESTAMP - col3) <=1, 'ok', 'nok') from a03 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a03 where id > 5;
insert into a03(col3) values(default), (default);

alter table a03 add column col4 timestamp not null;
select if(col4 is null, 'ok', 'nok') from a03;
alter table a03 add column col5 timestamp unique;
select if(col5 is null, 'ok', 'nok') from a03;
insert into a03(col3, col4, col5) values('2012-12-12 12:12:12', '2012-12-12 12:12:12', '2012-12-12 12:12:12');
select if ((CURRENT_TIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from a03 where id > 6;


drop table a03;






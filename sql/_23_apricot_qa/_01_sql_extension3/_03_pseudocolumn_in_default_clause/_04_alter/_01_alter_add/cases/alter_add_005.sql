--add columns with default value of SYSDATETIME


set system parameters 'add_column_update_hard_default=no';


create table a05(id short primary key auto_increment);
insert into a05 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a05;


alter table a05 add column col1 datetime default SYSDATETIME;
show columns in a05;
select if(col1 is not null, 'ok', 'nok') from a05;
insert into a05 values default;
select if ((SYSDATETIME - col1) <=1000, 'ok', 'nok') from a05 where id > 3;

alter table a05 add column col2 datetime default SYSDATETIME not null;
desc a05;
select if(col2 is not null, 'ok', 'nok') from a05;
insert into a05(col2) values (default);
select if ((SYSDATETIME - col2) <=1000, 'ok', 'nok') from a05 where id > 4;

alter table a05 add column col3 datetime default SYSDATETIME;
show columns in a05;
select if(col3 is not null, 'ok', 'nok') from a05;
--!!!!!!CUBRID BUG!!!!!!!!!
insert into a05(id) values(null);
select if ((SYSDATETIME - col3) <=1000, 'ok', 'nok') from a05 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a05 where id > 5;
insert into a05(col3) values(default), (default);

alter table a05 add column col4 datetime not null;
select if(col4 is null, 'ok', 'nok') from a05;
alter table a05 add column col5 datetime unique;
select if(col5 is null, 'ok', 'nok') from a05;
insert into a05(col3, col4, col5) values('2012-12-12 12:12:12.999', '2012-12-12 12:12:12.999', '2012-12-12 12:12:12.999');
select if ((SYSDATETIME - col2) <=1000 and col1 = col2, 'ok', 'nok') from a05 where id > 6;


drop table a05;






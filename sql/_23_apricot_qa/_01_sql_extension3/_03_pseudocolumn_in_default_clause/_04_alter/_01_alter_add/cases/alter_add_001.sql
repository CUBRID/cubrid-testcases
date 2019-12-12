--add columns with default value of CURRENT_TIMESTAMP


set system parameters 'add_column_update_hard_default=no';


create table a01(id short primary key auto_increment);
insert into a01 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a01;


--TEST: add column with default value
alter table a01 add column col1 timestamp default CURRENT_TIMESTAMP;
show columns in a01;
select if(col1 is not null, 'ok', 'nok') from a01;
insert into a01 values default;
select if ((SYSTIMESTAMP - col1) <=1, 'ok', 'nok') from a01 where id > 3;

--TEST: add column with default value
alter table a01 add column col2 timestamp default CURRENT_TIMESTAMP not null;
desc a01;
select if(col2 is not null, 'ok', 'nok') from a01;
insert into a01(col2) values (default);
select if ((SYSTIMESTAMP - col2) <=1, 'ok', 'nok') from a01 where id > 4;

--TEST: add column with default value
alter table a01 add column col3 timestamp default CURRENT_TIMESTAMP;
show columns in a01;
select if(col3 is not null, 'ok', 'nok') from a01;

insert into a01(id) values(null);
select if ((SYSTIMESTAMP - col3) <=1, 'ok', 'nok') from a01 where id = 6;
select if (col2 = col3, 'ok', 'nok') from a01 where id > 5;
--TEST: error, unique constraint violation
insert into a01(col3) values(default), (default);

--TEST: add column with default value
alter table a01 add column col4 timestamp not null;
select if(col4 is null, 'ok', 'nok') from a01;
--TEST: add column with default value
alter table a01 add column col5 timestamp unique;
select if(col5 is null, 'ok', 'nok') from a01;
insert into a01(col3, col4, col5) values('2012-12-12 12:12:12', '2012-12-12 12:12:12', '2012-12-12 12:12:12');
select if ((SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from a01 where id > 6;


drop table a01;






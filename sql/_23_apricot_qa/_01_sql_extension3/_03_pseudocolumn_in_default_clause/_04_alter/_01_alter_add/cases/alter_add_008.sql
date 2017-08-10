--add columns with default value of CURRENT_TIMESTAMP


set system parameters 'add_column_update_hard_default=yes';


create table a08(id short primary key auto_increment);
insert into a08 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a08;


--add column with default value
alter table a08 add column col1 timestamp default CURRENT_TIMESTAMP;
show columns in a08;
select if(col1 is not null, 'ok', 'nok') from a08;
insert into a08(id) values (null);
select if ((SYSTIMESTAMP - col1) <=1, 'ok', 'nok') from a08 where id > 3;

--add column with default value and not null constraint
alter table a08 add column col2 timestamp default CURRENT_TIMESTAMP not null;
desc a08;
insert into a08(col2) values (default);
select if ((SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from a08 where id > 4;

--default + unique constraint
alter table a08 add column col3 timestamp default CURRENT_TIMESTAMP;
show columns in a08;


alter table a08 add column col4 timestamp not null;
select if(col4 = timestamp'09:00:01 AM 01/01/1970', 'ok', 'nok') from a08;
--TEST:
alter table a08 add column col5 timestamp unique;
insert into a08(col4) values('2012-12-12 12:12:12');
select if ((SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from a08 where id > 5;

alter table a08 add column col6 timestamp default '2000-12-12 12:12:12' not null;
select if(col6 = timestamp'2000-12-12 12:12:12', 'ok', 'nok') from a08;
insert into a08 values(null, default, default, null, default(col6), null, default);
select if ((SYSTIMESTAMP - col2) <=1 and col1 = col2 and col6 = timestamp'2000-12-12 12:12:12', 'ok', 'nok') from a08 where id > 6;



drop table a08;


set system parameters 'add_column_update_hard_default=no';




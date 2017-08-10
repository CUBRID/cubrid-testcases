--add columns with default value of USER


set system parameters 'add_column_update_hard_default=yes';


create table a13(id short primary key auto_increment);
insert into a13 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a13;


--add column with default value
alter table a13 add column col1 string default USER;
show columns in a13;
select if(col1 is not null, 'ok', 'nok') from a13;
insert into a13(id) values (null);
select if (CURRENT_USER = col1, 'ok', 'nok') from a13 where id > 3;

--add column with default value and not null constraint
alter table a13 add column col2 string default USER not null;
desc a13;
insert into a13(col2) values (default);
select if (CURRENT_USER = col2 and col1 = col2, 'ok', 'nok') from a13 where id > 4;

--unique constraint + default
alter table a13 add column col3 string default USER ;
show columns in a13;


alter table a13 add column col4 string not null;
select if(col4 = '', 'ok', 'nok') from a13;
insert into a13(col4) values('STRING');
select if (CURRENT_USER = col2 and col1 = col2, 'ok', 'nok') from a13 where id > 5;

alter table a13 add column col5 string default 'DEFAULT VALUE' not null;
select if(col5 = 'DEFAULT VALUE', 'ok', 'nok') from a13;
insert into a13(id, col3, col4) values(null, null, default(col2));
select if (CURRENT_USER = col2 and col1 = col2 and col5 = 'DEFAULT VALUE', 'ok', 'nok') from a13 where id > 6;



drop table a13;


set system parameters 'add_column_update_hard_default=no';




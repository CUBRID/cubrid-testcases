--add columns with default value of CURRENT_USER


set system parameters 'add_column_update_hard_default=yes';


create table a14(id short primary key auto_increment);
insert into a14 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a14;


--add column with default value
alter table a14 add column col1 varchar default CURRENT_USER;
show columns in a14;
select if(col1 is not null, 'ok', 'nok') from a14;
insert into a14(id) values (null);
select if (USER = col1, 'ok', 'nok') from a14 where id > 3;

--add column with default value and not null constraint
alter table a14 add column col2 varchar default CURRENT_USER not null;
desc a14;
insert into a14(col2) values (default);
select if (USER = col2 and col1 = col2, 'ok', 'nok') from a14 where id > 4;

--default + unique constraint
alter table a14 add column col3 varchar default CURRENT_USER ;
show columns in a14;


alter table a14 add column col4 varchar not null;
select if(col4 = '', 'ok', 'nok') from a14;
insert into a14(col4) values('STRING');
select if (USER = col2 and col1 = col2, 'ok', 'nok') from a14 where id > 5;

alter table a14 add column col5 varchar default 'DEFAULT VALUE' not null;
select if(col5 = 'DEFAULT VALUE', 'ok', 'nok') from a14;
insert into a14(col3, col4) values(null, default(col2));
select if (USER = col2 and col1 = col2 and col5 = 'DEFAULT VALUE', 'ok', 'nok') from a14 where id > 6;



drop table a14;


set system parameters 'add_column_update_hard_default=no';




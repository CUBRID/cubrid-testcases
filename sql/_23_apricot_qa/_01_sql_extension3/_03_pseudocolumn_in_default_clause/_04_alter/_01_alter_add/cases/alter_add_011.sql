--add columns with default value of SYSDATE


set system parameters 'add_column_update_hard_default=yes';


create table a11(id short primary key auto_increment);
insert into a11 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a11;


--add column with default value
alter table a11 add column col1 date default SYSDATE;
show columns in a11;
select if(col1 is not null, 'ok', 'nok') from a11;
insert into a11(id) values (null);
select if (SYSDATE = col1, 'ok', 'nok') from a11 where id > 3;

--add column with default value and not null constraint
alter table a11 add column col2 date default SYSDATE not null;
desc a11;
select if(col2 is not null, 'ok', 'nok') from a11;
insert into a11(col2) values (default);
select if (SYSDATE = col2 and col1 = col2, 'ok', 'nok') from a11 where id > 4;

--default + unique
alter table a11 add column col3 date default SYSDATE ;
show columns in a11;


alter table a11 add column col4 date not null;
select if(col4 = date'01/01/0001', 'ok', 'nok') from a11;
insert into a11(col4) values('2012-12-12');
select if (SYSDATE = col2 and col1 = col2, 'ok', 'nok') from a11 where id > 5;

alter table a11 add column col5 date default '2000-12-12' not null;
select if(col5 = date'2000-12-12', 'ok', 'nok') from a11;
insert into a11(id, col3, col4) values(null, null, default(col2));
select if (SYSDATE = col2 and col1 = col2 and col5 = date'2000-12-12', 'ok', 'nok') from a11 where id > 6;



drop table a11;


set system parameters 'add_column_update_hard_default=no';




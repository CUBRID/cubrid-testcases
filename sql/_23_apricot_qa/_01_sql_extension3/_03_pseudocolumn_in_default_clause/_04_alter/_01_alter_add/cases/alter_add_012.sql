--add columns with default value of SYSDATETIME


set system parameters 'add_column_update_hard_default=yes';


create table a12(id short primary key auto_increment);
insert into a12 values(null), (null), (null);
select if (count(*) = 3, 'ok', 'nok') from a12;


--add column with default value
alter table a12 add column col1 datetime default SYSDATETIME;
show columns in a12;
select if(col1 is not null, 'ok', 'nok') from a12;
insert into a12(id) values (null);
select if ((SYSDATETIME - col1) <=1000, 'ok', 'nok') from a12 where id > 3;

--add column with default value and not null constraint
alter table a12 add column col2 datetime default SYSDATETIME not null;
desc a12;
insert into a12(col2) values (default);
select if ((SYSDATETIME - col2) <=1000 and col1 = col2, 'ok', 'nok') from a12 where id > 4;

--unique constraint + default
alter table a12 add column col3 datetime default SYSDATETIME ;
show columns in a12;


alter table a12 add column col4 datetime not null;
select if(col4 = datetime'01/01/0001 00:00', 'ok', 'nok') from a12;
insert into a12(col4) values('2012-12-12 12:12:12.456');
select if ((SYSDATETIME - col2) <=1000 and col1 = col2, 'ok', 'nok') from a12 where id > 5;

alter table a12 add column col5 datetime default '2000-12-12 12:12:12.456' not null;
select if(col5 = datetime'2000-12-12 12:12:12.456', 'ok', 'nok') from a12;
insert into a12(id, col3, col4) values(null, null, default(col2));
select if ((SYSDATETIME - col2) <=1000 and col1 = col2 and col5 = datetime'2000-12-12 12:12:12.456', 'ok', 'nok') from a12 where id > 6;



drop table a12;


set system parameters 'add_column_update_hard_default=no';




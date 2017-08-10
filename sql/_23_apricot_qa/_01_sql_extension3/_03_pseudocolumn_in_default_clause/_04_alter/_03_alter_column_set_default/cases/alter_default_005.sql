--set or reset default value of a column to SYSDATETIME


create table d01(id bigint primary key auto_increment, col1 datetime, col2 datetime not null, col3 datetime unique, col4 datetime default '2012-12-12 12:12:12.123');
insert into d01(col2) values('2011-11-11 11:11:11.888 PM');
select if (col1 is null and col3 is null and col4 = datetime'2012-12-12 12:12:12.123', 'ok', 'nok') from d01;


--add default value
alter table d01 alter column col1 set default SYSDATETIME;
alter table d01 alter column col1 set default 'SYSDATETIME';
show columns in d01;
insert into d01(col2, col3) values('2011-11-11 11:11:11.777 PM', '1976-01-01 01:30:23.456');
select if ((SYSDATETIME - col1) <=1000, 'ok', 'nok') from d01 where id = 2;


--add default value
alter table d01 alter column col2 set default SYSDATETIME;
alter table d01 alter column col2 set default 'SYSDATETIME';
desc d01;
insert into d01(col2, col3) values (default, '1999-09-09');
select if ((SYSDATETIME - col2) <=1000, 'ok', 'nok') from d01 where id = 3;


--add default value
alter table d01 alter column col3 set default SYSDATETIME;
alter table d01 alter column col3 set default 'SYSDATETIME';
show columns in d01;
insert into d01(id) values(default);
select if ((SYSDATETIME - col3) <=1000 and col1 = col2 and col2 = col3, 'ok', 'nok') from d01 where id = 4;


--reset default value
alter table d01 alter column col4 set default SYSDATETIME;
alter table d01 alter column col4 set default 'SYSDATETIME';
describe d01;
insert into d01(col3, col4) values('1945-10-01 12:12:12.12', default);
select if ((SYSDATETIME - col4) <=1000 and col1 = col2 and col2 = col4 and col3 = '1945-10-01 12:12:12.12', 'ok', 'nok') from d01 where id = 5;
--set again
alter table d01 alter column col4 set default '1999-09-09 9:9:9.999';
show columns in d01;
insert into d01(col3) values('2010-10-10 10:10:10.678');
select if (col4 = '1999-09-09 9:9:9.999' and (SYSDATETIME - col2) <=1000 and col1 = col2, 'ok', 'nok') from d01 where id = 6;
--set again
alter table d01 alter column col4 set default SYSDATETIME;
alter table d01 alter column col4 set default 'SYSDATETIME';
describe d01;
insert into d01(id, col3, col4) values(default, '1888-08-08 12:12:12.234', default);
select if ((SYSDATETIME - col4) <=1000 and col1 = col2 and col2 = col4 and col3 = '1888-08-08 12:12:12.234', 'ok', 'nok') from d01 where id = 7;


drop table d01;






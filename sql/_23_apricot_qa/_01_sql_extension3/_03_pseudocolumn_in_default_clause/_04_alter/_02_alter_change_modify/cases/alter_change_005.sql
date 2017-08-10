--change default value of a column to SYSDATETIME


create table c05(id bigint primary key auto_increment, col1 datetime, col2 datetime not null, col3 datetime, col4 datetime default '2012-12-12 12:12:12.123');
insert into c05(col2) values('2011-11-11 11:11:11.111 PM');
select if (col1 is null and col3 is null and col4 = datetime'2012-12-12 12:12:12.123', 'ok', 'nok') from c05;


--add default value
alter table c05 change col1 col1 datetime default SYSDATETIME;
alter table c05 change col1 col1 datetime default 'SYSDATETIME';
show columns in c05;
insert into c05(col2, col3) values('2011-11-11 11:11:11.111 PM', '1976-01-01 01:30:23.456');
select if ((SYSDATETIME - col1) <=10000, 'ok', 'nok') from c05 where id = 2;


--add default value
alter table c05 change col2 col2 datetime default SYSDATETIME not null;
alter table c05 change col2 col2 datetime default 'SYSDATETIME' not null;
desc c05;
insert into c05(col2, col3) values (default, '1999-09-09');
select if ((SYSDATETIME - col2) <=10000, 'ok', 'nok') from c05 where id = 3;


--add default value
alter table c05 change col3 col3 datetime default SYSDATETIME;
alter table c05 change col3 col3 datetime default 'SYSDATETIME';
show columns in c05;
insert into c05(id) values(default);
select if ((SYSDATETIME - col3) <=10000 and col1 = col2 and col2 = col3, 'ok', 'nok') from c05 where id = 4;


--reset default value
alter table c05 change col4 col4 datetime default SYSDATETIME;
alter table c05 change col4 col4 datetime default 'SYSDATETIME';
describe c05;
insert into c05(col3, col4) values('1945-10-01 12:12:12.999', default);
select if ((SYSDATETIME - col4) <=10000 and col1 = col2 and col2 = col4 and col3 = '1945-10-01 12:12:12.999', 'ok', 'nok') from c05 where id = 5;
--set again
alter table c05 change col4 col4 datetime default '1999-09-09 9:9:9.888';
show columns in c05;
insert into c05(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9.888' and (SYSDATETIME - col2) <=10000 and col1 = col2, 'ok', 'nok') from c05 where id = 6;
--set again
alter table c05 change col4 col4 datetime default SYSDATETIME;
alter table c05 change col4 col4 datetime default 'SYSDATETIME';
describe c05;
insert into c05(id, col3, col4) values(default, '1888-08-08 12:12:12.222', default);
select if ((SYSDATETIME - col4) <=10000 and col1 = col2 and col2 = col4 and col3 = '1888-08-08 12:12:12.222', 'ok', 'nok') from c05 where id = 7;


--set default values of multiple columns
alter table c05 change col1 col1 datetime, change col2 col2 datetime default '2011-11-11 11:11:11.111 PM', change col3 col3 datetime default SYSDATETIME;
desc c05;
insert into c05 values default;
select if (col1 is null and col2 = '2011-11-11 11:11:11.111 PM' and (SYSDATETIME - col3) <= 10000 and col3 = col4, 'ok', 'nok') from c05 where id = 8;
alter table c05 change col1 col1 datetime default SYSDATETIME, change col2 col2 datetime default SYSDATETIME not null, change col3 col3 datetime default SYSDATETIME;
show columns in c05;
insert into c05(id) values(null);
select if ((SYSDATETIME - col1) <=10000 and col1 = col2 and col2 = col3 and col3 = col4, 'ok', 'nok') from c05 where id = 9;



drop table c05;






--change default value of a column to SYSDATE


create table m04(id bigint primary key auto_increment, col1 date, col2 date not null, col3 date, col4 date default '2012-12-12');
insert into m04(col2) values('2011-11-11 PM');
select if (col1 is null and col3 is null and col4 = date'2012-12-12', 'ok', 'nok') from m04;


--add default value
alter table m04 modify col1 date default SYSDATE;
alter table m04 modify col1 date default 'SYSDATE';
show columns in m04;
insert into m04(col2, col3) values('2011-11-11 PM', '1976-01-01');
select if ((SYSDATE - col1) =0, 'ok', 'nok') from m04 where id = 2;


--add default value
alter table m04 modify col2 date default SYSDATE not null;
alter table m04 modify col2 date default 'SYSDATE' not null;
desc m04;
insert into m04(col2, col3) values (default, '1999-09-09');
select if ((SYSDATE - col2) =0, 'ok', 'nok') from m04 where id = 3;


--add default value
alter table m04 modify col3 date default SYSDATE;
alter table m04 modify col3 date default 'SYSDATE';
show columns in m04;
insert into m04(id) values(default);
select if ((SYSDATE - col3) =0 and col1 = col2 and col2 = col3, 'ok', 'nok') from m04 where id = 4;


--reset default value
alter table m04 modify col4 date default SYSDATE;
alter table m04 modify col4 date default 'SYSDATE';
describe m04;
insert into m04(col3, col4) values('1945-10-01', default);
select if ((SYSDATE - col4) =0 and col1 = col2 and col2 = col4 and col3 = '1945-10-01', 'ok', 'nok') from m04 where id = 5;
--set again
alter table m04 modify col4 date default '1999-09-09';
show columns in m04;
insert into m04(col3) values('2010-10-10');
select if (col4 = '1999-09-09' and (SYSDATE - col2) =0 and col1 = col2, 'ok', 'nok') from m04 where id = 6;
--set again
alter table m04 modify col4 date default SYSDATE;
alter table m04 modify col4 date default 'SYSDATE';
describe m04;
insert into m04(id, col3, col4) values(default, '1888-08-08', default);
select if ((SYSDATE - col4) =0 and col1 = col2 and col2 = col4 and col3 = '1888-08-08', 'ok', 'nok') from m04 where id = 7;


--set default values of multiple columns
alter table m04 modify col1 date, modify col2 date default '2011-11-11 PM', modify col3 date default SYSTIMESTAMP;
desc m04;
insert into m04 values default;
select if (col1 is null and col2 = '2011-11-11 PM' and SYSDATE = col3 and col3 = col4, 'ok', 'nok') from m04 where id = 8;
alter table m04 modify col1 date default SYSDATE, modify col2 date default SYSDATE not null, modify col3 date default SYSDATE;
show columns in m04;
insert into m04(id) values(null);
select if ((SYSDATE - col1) =0 and col1 = col2 and col2 = col3 and col3 = col4, 'ok', 'nok') from m04 where id = 9;



drop table m04;






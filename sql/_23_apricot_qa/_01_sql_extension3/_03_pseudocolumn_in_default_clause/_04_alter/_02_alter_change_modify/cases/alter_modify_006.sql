--change default value of a column to USER


create table m06(id bigint primary key auto_increment, col1 varchar, col2 varchar not null, col3 varchar, col4 varchar default '2012-12-12 12:12:12');
insert into m06(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = '2012-12-12 12:12:12', 'ok', 'nok') from m06;


--add default value
alter table m06 modify col1 varchar default USER;
show columns in m06;
insert into m06(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if (CURRENT_USER = col1, 'ok', 'nok') from m06 where id = 2;


--add default value
alter table m06 modify col2 varchar default USER not null;
desc m06;
insert into m06(col2, col3) values (default, '1999-09-09');
select if (CURRENT_USER = col2, 'ok', 'nok') from m06 where id = 3;


--add default value
alter table m06 modify col3 varchar default USER;
show columns in m06;
insert into m06(id) values(default);
select if (CURRENT_USER = col3 and col1 = col2 and col2 = col3, 'ok', 'nok') from m06 where id = 4;


--reset default value
alter table m06 modify col4 varchar default USER;
describe m06;
insert into m06(col3, col4) values('1945-10-01 12:12:12', default);
select if (CURRENT_USER = col4 and col1 = col2 and col2 = col4 and col3 = '1945-10-01 12:12:12', 'ok', 'nok') from m06 where id = 5;
--set again
alter table m06 modify col4 varchar default '1999-09-09 9:9:9';
show columns in m06;
insert into m06(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9' and CURRENT_USER = col2 and col1 = col2, 'ok', 'nok') from m06 where id = 6;
--set again
alter table m06 modify col4 varchar default USER;
describe m06;
insert into m06(id, col3, col4) values(default, '1888-08-08 12:12:12', default);
select if (CURRENT_USER = col4 and col1 = col2 and col2 = col4 and col3 = '1888-08-08 12:12:12', 'ok', 'nok') from m06 where id = 7;


--set default values of multiple columns
alter table m06 modify col1 varchar, modify col2 varchar default '2011-11-11 11:11:11 PM', modify col3 varchar default CURRENT_USER;
desc m06;
insert into m06 values default;
select if (col1 is null and col2 = '2011-11-11 11:11:11 PM' and USER = col3 and col3 = col4, 'ok', 'nok') from m06 where id = 8;
alter table m06 modify col1 varchar default USER, modify col2 varchar default USER not null, modify col3 varchar default USER;
show columns in m06;
insert into m06(id) values(null);
select if (CURRENT_USER = col1 and col1 = col2 and col2 = col3 and col3 = col4, 'ok', 'nok') from m06 where id = 9;



drop table m06;






--change default value of a column to UNIX_TIMESTAMP()


create table m02(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp, col4 timestamp default '2012-12-12 12:12:12');
insert into m02(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from m02;


--add default value
alter table m02 modify col1 timestamp default UNIX_TIMESTAMP();
alter table m02 modify col1 timestamp default 'UNIX_TIMESTAMP()';
show columns in m02;
insert into m02(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((SYSTIMESTAMP - col1) <=100, 'ok', 'nok') from m02 where id = 2;


--add default value
alter table m02 modify col2 timestamp default UNIX_TIMESTAMP() not null;
alter table m02 modify col2 timestamp default 'UNIX_TIMESTAMP()' not null;
desc m02;
insert into m02(col2, col3) values (default, '1999-09-09');
select if ((SYSTIMESTAMP - col2) <=100, 'ok', 'nok') from m02 where id = 3;


--add default value
alter table m02 modify col3 timestamp default UNIX_TIMESTAMP();
alter table m02 modify col3 timestamp default 'UNIX_TIMESTAMP()';
show columns in m02;
insert into m02(id) values(default);
select if ((SYSTIMESTAMP - col3) <=100 and abs(col1-col2)<=1 and abs(col2-col3)<=1, 'ok', 'nok') from m02 where id = 4;


--reset default value
alter table m02 modify col4 timestamp default UNIX_TIMESTAMP();
alter table m02 modify col4 timestamp default 'UNIX_TIMESTAMP()';
describe m02;
insert into m02(col3, col4) values('1975-10-01 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=100 and abs(col1-col2)<=1 and abs(col2-col4)<=1 and col3 = '1975-10-01 12:12:12', 'ok', 'nok') from m02 where id = 5;
--set again
alter table m02 modify col4 timestamp default '1999-09-09 9:9:9';
show columns in m02;
insert into m02(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9' and (SYSTIMESTAMP - col2) <=1 and abs(col1-col2)<=1, 'ok', 'nok') from m02 where id = 6;
--set again
alter table m02 modify col4 timestamp default UNIX_TIMESTAMP();
alter table m02 modify col4 timestamp default 'UNIX_TIMESTAMP()';
describe m02;
insert into m02(id, col3, col4) values(default, '1988-08-08 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=100 and abs(col1-col2)<=1 and abs(col2-col4)<=1 and col3 = '1988-08-08 12:12:12', 'ok', 'nok') from m02 where id = 7;


--set default values of multiple columns
alter table m02 modify col1 timestamp, modify col2 timestamp default '2011-11-11 11:11:11 PM', modify col3 timestamp default SYSTIMESTAMP;
desc m02;
insert into m02 values default;
select if (col1 is null and col2 = '2011-11-11 11:11:11 PM' and (SYSTIMESTAMP - col3) <= 1 and abs(col3-col4)<=1, 'ok', 'nok') from m02 where id = 8;
alter table m02 modify col1 timestamp default UNIX_TIMESTAMP(), modify col2 timestamp default UNIX_TIMESTAMP() not null, modify col3 timestamp default UNIX_TIMESTAMP();
show columns in m02;
insert into m02(id) values(null);
select if ((SYSTIMESTAMP - col1) <=100 and abs(col1-col2)<=1 and abs(col2-col3)<=1 and abs(col3-col4)<=1, 'ok', 'nok') from m02 where id = 9;



drop table m02;






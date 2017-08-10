--TEST: change default value of a column to UNIX_TIMESTAMP()


create table c02(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp, col4 timestamp default '2012-12-12 12:12:12');
insert into c02(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from c02;


--TEST: add default value
alter table c02 change col1 col1 timestamp default UNIX_TIMESTAMP();
alter table c02 change col1 col1 timestamp default 'UNIX_TIMESTAMP()';
show columns in c02;
insert into c02(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((SYSTIMESTAMP - col1) <=10, 'ok', 'nok') from c02 where id = 2;


--TEST: add default value
alter table c02 change col2 col2 timestamp default UNIX_TIMESTAMP() not null;
alter table c02 change col2 col2 timestamp default 'UNIX_TIMESTAMP()' not null;
desc c02;
insert into c02(col2, col3) values (default, '1999-09-09');
select if ((SYSTIMESTAMP - col2) <=10, 'ok', 'nok') from c02 where id = 3;


--TEST: add default value
alter table c02 change col3 col3 timestamp default UNIX_TIMESTAMP();
alter table c02 change col3 col3 timestamp default 'UNIX_TIMESTAMP()' unique;
show columns in c02;
insert into c02(id) values(default);
select if ((SYSTIMESTAMP - col3) <=10, 'ok', 'nok') from c02 where id = 4;
select if ((col1 - col2) <=10, 'ok', 'nok') from c02 where id = 4;
select if ((col2 - col3) <=10, 'ok', 'nok') from c02 where id = 4;


--TEST: reset default value
alter table c02 change col4 col4 timestamp default UNIX_TIMESTAMP();
alter table c02 change col4 col4 timestamp default 'UNIX_TIMESTAMP()';
describe c02;
insert into c02(col3, col4) values('1975-10-01 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=10, 'ok', 'nok') from c02 where id = 5;
select if ((col1 - col2) <=10, 'ok', 'nok') from c02 where id = 5;
select if ((col2 - col4) <=10, 'ok', 'nok') from c02 where id = 5;
select if (col3 = '1975-10-01 12:12:12', 'ok', 'nok') from c02 where id = 5;


--TEST: set again
alter table c02 change col4 col4 timestamp default '1999-09-09 9:9:9';
show columns in c02;
insert into c02(col3) values('2010-10-10 10:10:10');
select if ((SYSTIMESTAMP - col2) <=10, 'ok', 'nok') from c02 where id = 6;
select if (col4 = '1999-09-09 9:9:9', 'ok', 'nok') from c02 where id = 6;
select if ((col1 - col2) <=10, 'ok', 'nok') from c02 where id = 6;


--TEST: set again
alter table c02 change col4 col4 timestamp default UNIX_TIMESTAMP();
alter table c02 change col4 col4 timestamp default 'UNIX_TIMESTAMP()';
describe c02;
insert into c02(id, col3, col4) values(default, '1988-08-08 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=10, 'ok', 'nok') from c02 where id = 7;
select if ((col1 - col2) <=10, 'ok', 'nok') from c02 where id = 7;
select if ((col2 - col4) <=10, 'ok', 'nok') from c02 where id = 7;
select if (col3 = '1988-08-08 12:12:12', 'ok', 'nok') from c02 where id = 7;

--TEST: set default values of multiple columns
alter table c02 change col1 col1 timestamp, change col2 col2 timestamp default '2011-11-11 11:11:11 PM', change col3 col3 timestamp default SYSTIMESTAMP;
desc c02;
insert into c02 values default;
select if ((SYSTIMESTAMP - col3) <= 10, 'ok', 'nok') from c02 where id = 8;
select if (col1 is null , 'ok', 'nok') from c02 where id = 8;
select if (col2 = '2011-11-11 11:11:11 PM' , 'ok', 'nok') from c02 where id = 8;
select if ((col3 - col4) <=10, 'ok', 'nok') from c02 where id = 8;

alter table c02 change col1 col1 timestamp default UNIX_TIMESTAMP(), change col2 col2 timestamp default UNIX_TIMESTAMP() not null, change col3 col3 timestamp default UNIX_TIMESTAMP();
show columns in c02;
insert into c02(id) values(null);
select if ((SYSTIMESTAMP - col1) <=10, 'ok', 'nok') from c02 where id = 9;
select if ((col1 - col2) <=10, 'ok', 'nok') from c02 where id = 9;
select if ((col2 - col3) <=10, 'ok', 'nok') from c02 where id = 9;
select if ((col3 - col4) <=10, 'ok', 'nok') from c02 where id = 9;


drop table c02;


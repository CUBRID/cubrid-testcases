--TEST: change default value of a column to CURRENT_TIMESTAMP


create table c01(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp, col4 timestamp default '2012-12-12 12:12:12');
insert into c01(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from c01;


--TEST: add default value
alter table c01 change col1 col1 timestamp default CURRENT_TIMESTAMP;
alter table c01 change col1 col1 timestamp default 'CURRENT_TIMESTAMP';
show columns in c01;
insert into c01(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((SYSTIMESTAMP - col1) <=1, 'ok', 'nok') from c01 where id = 2;


--TEST: add default value
alter table c01 change col2 col2 timestamp default CURRENT_TIMESTAMP not null;
alter table c01 change col2 col2 timestamp default 'CURRENT_TIMESTAMP' not null;
desc c01;
insert into c01(col2, col3) values (default, '1999-09-09');
select if ((SYSTIMESTAMP - col2) <=1, 'ok', 'nok') from c01 where id = 3;


--TEST: add default value
alter table c01 change col3 col3 timestamp default CURRENT_TIMESTAMP;
alter table c01 change col3 col3 timestamp default 'CURRENT_TIMESTAMP' unique;
show columns in c01;
insert into c01(id) values(default);
select if ((SYSTIMESTAMP - col3) <=1 and col1 = col2 and col2 = col3, 'ok', 'nok') from c01 where id = 4;


--TEST: reset default value
alter table c01 change col4 col4 timestamp default CURRENT_TIMESTAMP;
alter table c01 change col4 col4 timestamp default 'CURRENT_TIMESTAMP';
describe c01;
insert into c01(col3, col4) values('1980-10-01 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=1 and col1 = col2 and col2 = col4 and col3 = '1980-10-01 12:12:12', 'ok', 'nok') from c01 where id = 5;
--TEST: set again
alter table c01 change col4 col4 timestamp default '1999-09-09 9:9:9';
show columns in c01;
insert into c01(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9' and (SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from c01 where id = 6;
--TEST: set again
alter table c01 change col4 col4 timestamp default CURRENT_TIMESTAMP;
alter table c01 change col4 col4 timestamp default 'CURRENT_TIMESTAMP';
describe c01;
insert into c01(id, col3, col4) values(default, '1988-08-08 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=1 and col1 = col2 and col2 = col4 and col3 = '1988-08-08 12:12:12', 'ok', 'nok') from c01 where id = 7;


--TEST: set default values of multiple columns
alter table c01 change col1 col1 timestamp, change col2 col2 timestamp default '2011-11-11 11:11:11 PM', change col3 col3 timestamp default SYSTIMESTAMP;
desc c01;
insert into c01 values default;
select if (col1 is null and col2 = '2011-11-11 11:11:11 PM' and (CURRENT_TIMESTAMP - col3) <= 1 and col3 = col4, 'ok', 'nok') from c01 where id = 8;
alter table c01 change col1 col1 timestamp default CURRENT_TIMESTAMP, change col2 col2 timestamp default CURRENT_TIMESTAMP not null, change col3 col3 timestamp default CURRENT_TIMESTAMP;
show columns in c01;
insert into c01(id) values(null);
select if ((SYSTIMESTAMP - col1) <=1 and col1 = col2 and col2 = col3 and col3 = col4, 'ok', 'nok') from c01 where id = 9;



drop table c01;






--change default value of a column to SYSTIMESTAMP


create table c03(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp, col4 timestamp default '2012-12-12 12:12:12');
insert into c03(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from c03;


--add default value
alter table c03 change col1 col1 timestamp default SYSTIMESTAMP;
alter table c03 change col1 col1 timestamp default 'SYSTIMESTAMP';
show columns in c03;
insert into c03(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((CURRENT_TIMESTAMP - col1) <=100, 'ok', 'nok') from c03 where id = 2;


--add default value
alter table c03 change col2 col2 timestamp default SYSTIMESTAMP not null;
alter table c03 change col2 col2 timestamp default 'SYSTIMESTAMP' not null;
desc c03;
insert into c03(col2, col3) values (default, '1999-09-09');
select if ((CURRENT_TIMESTAMP - col2) <=100, 'ok', 'nok') from c03 where id = 3;


--add default value
alter table c03 change col3 col3 timestamp default SYSTIMESTAMP;
alter table c03 change col3 col3 timestamp default 'SYSTIMESTAMP';
show columns in c03;
insert into c03(id) values(default);
select if ((CURRENT_TIMESTAMP - col3) <=100 and col1 = col2 and col2 = col3, 'ok', 'nok') from c03 where id = 4;


--reset default value
alter table c03 change col4 col4 timestamp default SYSTIMESTAMP;
alter table c03 change col4 col4 timestamp default 'SYSTIMESTAMP';
describe c03;
insert into c03(col3, col4) values('1975-10-01 12:12:12', default);
select if ((CURRENT_TIMESTAMP - col4) <=100 and col1 = col2 and col2 = col4 and col3 = '1975-10-01 12:12:12', 'ok', 'nok') from c03 where id = 5;
--set again
alter table c03 change col4 col4 timestamp default '1999-09-09 9:9:9';
show columns in c03;
insert into c03(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9' and (CURRENT_TIMESTAMP - col2) <=100 and col1 = col2, 'ok', 'nok') from c03 where id = 6;
--set again
alter table c03 change col4 col4 timestamp default SYSTIMESTAMP;
alter table c03 change col4 col4 timestamp default 'SYSTIMESTAMP';
describe c03;
insert into c03(id, col3, col4) values(default, '1988-08-08 12:12:12', default);
select if ((CURRENT_TIMESTAMP - col4) <=100 and col1 = col2 and col2 = col4 and col3 = '1988-08-08 12:12:12', 'ok', 'nok') from c03 where id = 7;


--set default values of multiple columns
alter table c03 change col1 col1 timestamp, change col2 col2 timestamp default '2011-11-11 11:11:11 PM', change col3 col3 timestamp default SYSTIMESTAMP;
desc c03;
insert into c03 values default;
select if (col1 is null and col2 = '2011-11-11 11:11:11 PM' and (CURRENT_TIMESTAMP - col3) <= 1 and col3 = col4, 'ok', 'nok') from c03 where id = 8;
alter table c03 change col1 col1 timestamp default SYSTIMESTAMP, change col2 col2 timestamp default SYSTIMESTAMP not null, change col3 col3 timestamp default SYSTIMESTAMP;
show columns in c03;
insert into c03(id) values(null);
select if ((CURRENT_TIMESTAMP - col1) <=100 and col1 = col2 and col2 = col3 and col3 = col4, 'ok', 'nok') from c03 where id = 9;



drop table c03;






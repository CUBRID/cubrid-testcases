--TEST: set or reset default value of a column to CURRENT_TIMESTAMP


create table d01(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp unique, col4 timestamp default '2012-12-12 12:12:12');
insert into d01(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from d01;


--TEST: add default value
alter table d01 alter column col1 set default CURRENT_TIMESTAMP;
alter table d01 alter column col1 set default 'CURRENT_TIMESTAMP';
show columns in d01;
insert into d01(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((SYSTIMESTAMP - col1) <=1, 'ok', 'nok') from d01 where id = 2;


--TEST: add default value
alter table d01 alter column col2 set default CURRENT_TIMESTAMP;
alter table d01 alter column col2 set default 'CURRENT_TIMESTAMP';
desc d01;
insert into d01(col2, col3) values (default, '1999-09-09');
select if ((SYSTIMESTAMP - col2) <=1, 'ok', 'nok') from d01 where id = 3;


--TEST: add default value
alter table d01 alter column col3 set default CURRENT_TIMESTAMP;
alter table d01 alter column col3 set default 'CURRENT_TIMESTAMP';
show columns in d01;
insert into d01(id) values(default);
select if ((SYSTIMESTAMP - col3) <=1 and col1 = col2 and col2 = col3, 'ok', 'nok') from d01 where id = 4;


--TEST: reset default value
alter table d01 alter column col4 set default CURRENT_TIMESTAMP;
alter table d01 alter column col4 set default 'CURRENT_TIMESTAMP';
describe d01;
insert into d01(col3, col4) values('1977-10-01 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=1 and col1 = col2 and col2 = col4 and col3 = '1977-10-01 12:12:12', 'ok', 'nok') from d01 where id = 5;
--TEST: set again
alter table d01 alter column col4 set default '1999-09-09 9:9:9';
show columns in d01;
insert into d01(col3) values('2010-10-10 10:10:10');
select if (col4 = '1999-09-09 9:9:9' and (SYSTIMESTAMP - col2) <=1 and col1 = col2, 'ok', 'nok') from d01 where id = 6;
--TEST: set again
alter table d01 alter column col4 set default CURRENT_TIMESTAMP;
alter table d01 alter column col4 set default 'CURRENT_TIMESTAMP';
describe d01;
insert into d01(id, col3, col4) values(default, '2011-08-08 12:12:12', default);
select if ((SYSTIMESTAMP - col4) <=1 and col1 = col2 and col2 = col4 and col3 = '2011-08-08 12:12:12', 'ok', 'nok') from d01 where id = 7;


drop table d01;






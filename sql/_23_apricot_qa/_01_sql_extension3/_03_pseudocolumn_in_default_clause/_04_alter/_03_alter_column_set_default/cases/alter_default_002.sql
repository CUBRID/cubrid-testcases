--set or reset default value of a column to UNIX_TIMESTAMP()


create table d01(id bigint primary key auto_increment, col1 timestamp, col2 timestamp not null, col3 timestamp unique, col4 timestamp default '2012-12-12 12:12:12');
insert into d01(col2) values('2011-11-11 11:11:11 PM');
select if (col1 is null and col3 is null and col4 = timestamp'2012-12-12 12:12:12', 'ok', 'nok') from d01;


--add default value
alter table d01 alter column col1 set default UNIX_TIMESTAMP();
alter table d01 alter column col1 set default 'UNIX_TIMESTAMP()';
show columns in d01;
insert into d01(col2, col3) values('2011-11-11 11:11:11 PM', '1976-01-01 01:30:23');
select if ((CURRENT_TIMESTAMP - col1) <=100, 'ok', 'nok') from d01 where id = 2;


--add default value
alter table d01 alter column col2 set default UNIX_TIMESTAMP();
alter table d01 alter column col2 set default 'UNIX_TIMESTAMP()';
desc d01;
insert into d01(col2, col3) values (default, '1999-09-09');
select if ((CURRENT_TIMESTAMP - col2) <=100, 'ok', 'nok') from d01 where id = 3;


--add default value
alter table d01 alter column col3 set default UNIX_TIMESTAMP();
alter table d01 alter column col3 set default 'UNIX_TIMESTAMP()';
show columns in d01;
insert into d01(id) values(default);
select if ((CURRENT_TIMESTAMP - col3) <=100, 'ok', 'nok') from d01 where id = 4;
select if ( (col1 - col2) <= 100, 'ok', 'nok') from d01 where id = 4;
select if ( (col2 - col3) <= 100, 'ok', 'nok') from d01 where id = 4;


--reset default value
alter table d01 alter column col4 set default UNIX_TIMESTAMP();
alter table d01 alter column col4 set default 'UNIX_TIMESTAMP()';
describe d01;
insert into d01(col3, col4) values('1975-10-01 12:12:12', default);
select if ((CURRENT_TIMESTAMP - col4) <=100, 'ok', 'nok') from d01 where id = 5;
select if ((col1 - col2) <= 100 , 'ok', 'nok') from d01 where id = 5;
select if ((col2 - col4) <= 100 , 'ok', 'nok') from d01 where id = 5;
select if (col3 = '1975-10-01 12:12:12', 'ok', 'nok') from d01 where id = 5;
--set again
alter table d01 alter column col4 set default '1999-09-09 9:9:9';
show columns in d01;
insert into d01(col3) values('2010-10-10 10:10:10');
select if ((CURRENT_TIMESTAMP - col2) <=100, 'ok', 'nok') from d01 where id = 6;
select if (col4 = '1999-09-09 9:9:9', 'ok', 'nok') from d01 where id = 6;
select if ((col1 - col2) <= 100 , 'ok', 'nok') from d01 where id = 6;

--set again
alter table d01 alter column col4 set default UNIX_TIMESTAMP();
alter table d01 alter column col4 set default 'UNIX_TIMESTAMP()';
describe d01;
insert into d01(id, col3, col4) values(default, '1988-08-08 12:12:12', default);
select if ((CURRENT_TIMESTAMP - col4) <=100 , 'ok', 'nok') from d01 where id = 7;
select if ((col1 - col2) <= 100 , 'ok', 'nok') from d01 where id = 7;
select if ((col2 - col4) <= 100 , 'ok', 'nok') from d01 where id = 7;
select if (col3 = '1988-08-08 12:12:12', 'ok', 'nok') from d01 where id = 7;

drop table d01;






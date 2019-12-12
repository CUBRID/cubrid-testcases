--set or reset default value of a column to SYSDATE


create table d01(id bigint primary key auto_increment, col1 date, col2 date not null, col3 date unique, col4 date default '2012-12-12');
insert into d01(col2) values('2011-11-11 PM');
select if (col1 is null and col3 is null and col4 = date'2012-12-12', 'ok', 'nok') from d01;


--add default value
alter table d01 alter column col1 set default SYSDATE;
alter table d01 alter column col1 set default 'SYSDATE';
show columns in d01;
insert into d01(col2, col3) values('2011-11-11 PM', '1976-01-01');
select if ((SYSDATE - col1) =0, 'ok', 'nok') from d01 where id = 2;


--add default value
alter table d01 alter column col2 set default SYSDATE;
alter table d01 alter column col2 set default 'SYSDATE';
desc d01;
insert into d01(col2, col3) values (default, '1999-09-09');
select if ((SYSDATE - col2) =0, 'ok', 'nok') from d01 where id = 3;


--add default value
alter table d01 alter column col3 set default SYSDATE;
alter table d01 alter column col3 set default 'SYSDATE';
show columns in d01;
insert into d01(id) values(default);
select if ((SYSDATE - col3) =0 and col1 = col2 and col2 = col3, 'ok', 'nok') from d01 where id = 4;


--reset default value
alter table d01 alter column col4 set default SYSDATE;
alter table d01 alter column col4 set default 'SYSDATE';
describe d01;
insert into d01(col3, col4) values('1945-10-01', default);
select if ((SYSDATE - col4) =0 and col1 = col2 and col2 = col4 and col3 = '1945-10-01', 'ok', 'nok') from d01 where id = 5;
--set again
alter table d01 alter column col4 set default '1999-09-09';
show columns in d01;
insert into d01(col3) values('2010-10-10');
select if (col4 = '1999-09-09' and (SYSDATE - col2) =0 and col1 = col2, 'ok', 'nok') from d01 where id = 6;
--set again
alter table d01 alter column col4 set default SYSDATE;
alter table d01 alter column col4 set default 'SYSDATE';
describe d01;
insert into d01(id, col3, col4) values(default, '1888-08-08', default);
select if ((SYSDATE - col4) =0 and col1 = col2 and col2 = col4 and col3 = '1888-08-08', 'ok', 'nok') from d01 where id = 7;


drop table d01;






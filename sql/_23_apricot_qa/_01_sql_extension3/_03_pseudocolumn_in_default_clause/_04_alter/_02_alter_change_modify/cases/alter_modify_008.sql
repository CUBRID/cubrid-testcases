--set different types of default values in one table



create table m08(id int primary key auto_increment, col1 timestamp, col2 date, col3 datetime, col4 string);

insert into m08(col1, col2, col3, col4) values('2000-10-10 10:10:10', '2000-10-10', '2000-10-10 10:10:10.100', 'aaa');


alter table m08 modify col1 timestamp default CURRENT_TIMESTAMP, modify col2 date default SYSDATE;
desc m08;
alter table m08 modify col1 timestamp default SYSTIMESTAMP, modify col3 datetime default SYSDATETIME, modify col4 varchar default USER;
show columns in m08;

insert into m08(id) values(default);
select if ((CURRENT_TIMESTAMP - col1) <= 1, 'ok', 'nok') from m08 where id = 2;
select if (SYSDATE = col2, 'ok', 'nok') from m08 where id = 2;
select if ((SYSDATETIME - col3) <= 1000, 'ok', 'nok') from m08 where id = 2;
select if (CURRENT_USER = col4, 'ok', 'nok') from m08 where id = 2;



alter table m08 modify col1 timestamp default '2000-10-10 10:10:10' not null, modify col2 date default '2000-10-10', modify col3 datetime default '2000-10-10 10:10:10.100', modify col4 string default 'aaa';
desc m08;
replace into m08(col2, col4) values(default, default);
select if (count(*) = 3, 'ok', 'nok') from m08;
select if (col1 = '2000-10-10 10:10:10' and col2 = '2000-10-10' and col3 = '2000-10-10 10:10:10.100' and col4 = 'aaa', 'ok', 'nok') from m08 where id = 1;



alter table m08 modify col1 timestamp default UNIX_TIMESTAMP(), modify col2 date default SYSDATE, modify col3 datetime default SYSDATETIME, modify col4 varchar default CURRENT_USER;
show columns in m08;
insert into m08(col4) values(default);
select if ((CURRENT_TIMESTAMP - col1) <= 1, 'ok', 'nok') from m08 order by id desc limit 1;
select if (SYSDATE = col2, 'ok', 'nok') from m08 order by id desc limit 1;
select if ((SYSDATETIME - col3) <= 1000, 'ok', 'nok') from m08 order by id desc limit 1;
select if (CURRENT_USER = col4, 'ok', 'nok') from m08 order by id desc limit 1;



drop table m08;
 

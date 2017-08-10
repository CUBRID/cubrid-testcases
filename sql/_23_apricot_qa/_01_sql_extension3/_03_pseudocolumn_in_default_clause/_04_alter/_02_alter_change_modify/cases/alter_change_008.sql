--set different types of default values in one table



create table c08(id int primary key auto_increment, col1 timestamp, col2 date, col3 datetime, col4 string);

insert into c08(col1, col2, col3, col4) values('2000-10-10 10:10:10', '2000-10-10', '2000-10-10 10:10:10.100', 'aaa');


alter table c08 change col1 col1 timestamp default CURRENT_TIMESTAMP, change col2 col2 date default SYSDATE;
desc c08;
alter table c08 change col1 col1 timestamp default SYSTIMESTAMP, change col3 col3 datetime default SYSDATETIME, change col4 col4 varchar default USER;
show columns in c08;

insert into c08(id) values(default);
select if ((CURRENT_TIMESTAMP - col1) <= 10, 'ok', 'nok') from c08 where id = 2;
select if (SYSDATE = col2, 'ok', 'nok') from c08 where id = 2;
select if ((SYSDATETIME - col3) <= 10000 , 'ok', 'nok') from c08 where id = 2;
select if (CURRENT_USER = col4, 'ok', 'nok') from c08 where id = 2;



alter table c08 change col1 col1 timestamp default '2000-10-10 10:10:10' not null, change col2 col2 date default '2000-10-10', change col3 col3 datetime default '2000-10-10 10:10:10.100', change col4 col4 varchar default 'aaa';
desc c08;
replace into c08(col2, col4) values(default, default);
select if (count(*) = 3, 'ok', 'nok') from c08;
select if (col1 = '2000-10-10 10:10:10' and col2 = '2000-10-10' and col3 = '2000-10-10 10:10:10.100' and col4 = 'aaa', 'ok', 'nok') from c08 where id = 1;



alter table c08 change col1 col1 timestamp default UNIX_TIMESTAMP(), change col2 col2 date default SYSDATE, change col3 col3 datetime default SYSDATETIME, change col4 col4 varchar default CURRENT_USER;
show columns in c08;
insert into c08(col4) values(default);
select if ((CURRENT_TIMESTAMP - col1) <= 10, 'ok', 'nok') from c08 order by id desc limit 1;
select if (SYSDATE = col2, 'ok', 'nok') from c08 order by id desc limit 1;
select if ((SYSDATETIME - col3) <= 10000, 'ok', 'nok') from c08 order by id desc limit 1;
select if (CURRENT_USER = col4, 'ok', 'nok') from c08 order by id desc limit 1;



drop table c08;
 

--set or reset default value of a column to USER


create table d01(id bigint primary key auto_increment, col1 string, col2 string not null, col3 string unique, col4 string default 'AAAAA');
insert into d01(col2) values('BBBBB');
select if (col1 is null and col3 is null and col4 = 'AAAAA', 'ok', 'nok') from d01;


--add default value
alter table d01 alter column col1 set default USER;
show columns in d01;
insert into d01(col2, col3) values('BBBBB', 'CCCCC');
select if (CURRENT_USER = col1, 'ok', 'nok') from d01 where id = 2;


--add default value
alter table d01 alter column col2 set default USER;
desc d01;
insert into d01(col2, col3) values (default, 'DDDDD');
select if (CURRENT_USER = col2, 'ok', 'nok') from d01 where id = 3;


--add default value
alter table d01 alter column col3 set default USER;
show columns in d01;
insert into d01(id) values(default);
select if (CURRENT_USER = col3 and col1 = col2 and col2 = col3, 'ok', 'nok') from d01 where id = 4;


--reset default value
alter table d01 alter column col4 set default USER;
describe d01;
insert into d01(col3, col4) values('EEEEE', default);
select if (CURRENT_USER = col4 and col1 = col2 and col2 = col4 and col3 = 'EEEEE', 'ok', 'nok') from d01 where id = 5;
--set again
alter table d01 alter column col4 set default 'FFFFF';
show columns in d01;
insert into d01(col3) values('GGGGG');
select if (col4 = 'FFFFF' and CURRENT_USER = col2 and col1 = col2, 'ok', 'nok') from d01 where id = 6;
--set again
alter table d01 alter column col4 set default USER;
describe d01;
insert into d01(id, col3, col4) values(default, 'HHHHH', default);
select if (CURRENT_USER = col4 and col1 = col2 and col2 = col4 and col3 = 'HHHHH', 'ok', 'nok') from d01 where id = 7;


drop table d01;






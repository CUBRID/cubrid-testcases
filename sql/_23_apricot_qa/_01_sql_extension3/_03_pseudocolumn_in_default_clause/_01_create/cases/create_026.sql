--create table of one column with default value of USER and CURRENT_USER using 'create table as select' syntax


--TEST: string
create table c26(col string default USER);
insert into c26 values default;
insert into c26 values default;
insert into c26 values default;
create table a24 as select * from c26;
desc a24;
select if(col = CURRENT_USER, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if(col = CURRENT_USER, 'ok', 'nok') from a24 order by 1;
drop table if exists c26;
drop table if exists a24;


--TEST: varchar
create table c26(col char varying default USER);
insert into c26 values default;
insert into c26 values default;
insert into c26 values default;
create table a24 as select * from c26;
desc a24;
select if(col = CURRENT_USER, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if(col = CURRENT_USER, 'ok', 'nok') from a24 order by 1;
drop table if exists c26;
drop table if exists a24;


--TEST: char(n)
create table c26(col char(3) default CURRENT_USER);
insert into c26 values default;	
insert into c26 values default;
insert into c26 values default;
create table a24 as select * from c26;
desc a24;
select if(col = USER, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if(col = USER, 'ok', 'nok') from a24 order by 1;
drop table if exists c26;
drop table if exists a24;



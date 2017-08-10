--create table of one column with default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP and SYSTIMESTAMP using 'create table as select' syntax


--TEST: current_timestamp
create table c24(col timestamp default CURRENT_TIMESTAMP);
insert into c24 values default;
insert into c24 values default;
insert into c24 values default;
create table a24 as select * from c24;
desc a24;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1 desc limit 1;
drop table if exists c24;
drop table if exists a24;


--TEST: unix_timestamp()
create table c24(col timestamp default UNIX_TIMESTAMP());
insert into c24 values default;
insert into c24 values default;
insert into c24 values default;
create table a24 as select * from c24;
desc a24;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1 desc limit 1;
drop table if exists c24;
drop table if exists a24;


--TEST: systimestamp
create table c24(col timestamp default SYSTIMESTAMP);
insert into c24 values default;
insert into c24 values default;
insert into c24 values default;
create table a24 as select * from c24;
desc a24;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1;
insert into a24 values default;
select if((SYSTIMESTAMP - col) < 2, 'ok', 'nok') from a24 order by 1 desc limit 1;
drop table if exists c24;
drop table if exists a24;

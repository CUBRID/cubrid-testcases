--create hash partition table partitioned by column with default value of SYSDATE and SYSDATETIME



--TEST: date + SYSDATE
create table c32(col1 date default SYSDATE, col2 int)
partition by hash(col1) partitions 4;

desc c32;
insert into c32 values default;

select if(col1 = SYSDATE, 'ok', 'nok') from c32;
show tables like 'c32%';

drop table if exists c32;


--TEST: timestamp + SYSDATE
create table c32(col1 timestamp default SYSDATE, col2 int)
partition by hash(col1) partitions 4;

desc c32;
insert into c32 values default;

select if(date(col1) = SYSDATE, 'ok', 'nok') from c32;
show tables like 'c32%';

drop table if exists c32;


--TEST: datetime + SYSDATETIME
create table c32(col1 datetime default SYSDATETIME, col2 int)
partition by hash(col1) partitions 4;

desc c32;
insert into c32 values default;

select if(date(col1) = SYSDATE, 'ok', 'nok') from c32;
show tables like 'c32%';

drop table if exists c32;

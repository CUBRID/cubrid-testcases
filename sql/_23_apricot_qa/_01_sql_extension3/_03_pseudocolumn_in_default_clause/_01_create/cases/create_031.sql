--create hash partition table partitioned by column with default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP() and SYSTIMESTAMP



--TEST: CURRENT_TIMESTAMP
create table c31(col1 timestamp default CURRENT_TIMESTAMP, col2 int)
partition by hash(col1) partitions 4;

desc c31;
insert into c31 values default;

select if(count(*) = 1, 'ok', 'nok') from c31;
show tables like 'c31%';

drop table if exists c31;


--TEST: UNIX_TIMESTAMP()
create table c31(col1 timestamp default UNIX_TIMESTAMP(), col2 int)
partition by hash(col1) partitions 4;

desc c31;
insert into c31 values default;

select if(count(*) = 1, 'ok', 'nok') from c31;
show tables like 'c31%';

drop table if exists c31;


--TEST: SYSTIMESTAMP
create table c31(col1 timestamp default SYSTIMESTAMP, col2 int)
partition by hash(col1) partitions 4;

desc c31;
insert into c31 values default;

select if(count(*) = 1, 'ok', 'nok') from c31;
show tables like 'c31%';

drop table if exists c31;

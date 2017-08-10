--create range partition table partitioned by column with default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP() and SYSTIMESTAMP



--TEST: CURRENT_TIMESTAMP
create table c28(col1 timestamp default CURRENT_TIMESTAMP, col2 int)
partition by range(col1)
(partition p1 values less than (timestamp'2000-12-12 12:12:12'),
partition p2 values less than (timestamp'2037-12-12 12:12:12'));

desc c28;
insert into c28 values default;

select if(count(*) = 1, 'ok', 'nok') from c28__p__p2;

drop table if exists c28;


--TEST: UNIX_TIMESTAMP()
create table c28(col1 timestamp default UNIX_TIMESTAMP(), col2 int)
partition by range(col1)
(partition p1 values less than (timestamp'2000-12-12 12:12:12'),
partition p2 values less than (timestamp'2037-12-12 12:12:12'));

desc c28;
insert into c28 values default;

select if(count(*) = 1, 'ok', 'nok') from c28__p__p2;

drop table if exists c28;


--TEST: SYSTIMESTAMP
create table c28(col1 timestamp default SYSTIMESTAMP, col2 int)
partition by range(col1)
(partition p1 values less than (timestamp'2000-12-12 12:12:12'),
partition p2 values less than (timestamp'2037-12-12 12:12:12'));

desc c28;
insert into c28 values default;

select if(count(*) = 1, 'ok', 'nok') from c28__p__p2;

drop table if exists c28;

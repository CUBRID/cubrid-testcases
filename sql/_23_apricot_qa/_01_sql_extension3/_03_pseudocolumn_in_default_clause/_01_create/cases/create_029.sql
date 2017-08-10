--create range partition table partitioned by column with default value of SYSDATE and SYSDATETIME



--TEST: date + SYSDATE
create table c29(col1 date default SYSDATE, col2 int)
partition by range(col1)
(partition p1 values less than (date'2000-12-12'),
partition p2 values less than (date'12/12/2037'));

desc c29;
insert into c29 values default;

select if(count(*) = 1, 'ok', 'nok') from c29__p__p2;

drop table if exists c29;


--TEST: timestamp + SYSDATE
create table c29(col1 timestamp default SYSDATE, col2 int)
partition by range(col1)
(partition p1 values less than (timestamp'2000-12-12 12:12:12'),
partition p2 values less than (timestamp'2030-12-12 12:12:12'));

desc c29;
insert into c29 values default;

select if(count(*) = 1, 'ok', 'nok') from c29__p__p2;

drop table if exists c29;


--TEST: datetime + SYSDATETIME
create table c29(col1 datetime default SYSDATETIME, col2 int)
partition by range(col1)
(partition p1 values less than (datetime'2000-12-12 12:12:12.999'),
partition p2 values less than (datetime'2030-12-12 12:12:12.999'));

desc c29;
insert into c29 values default;

select if(count(*) = 1, 'ok', 'nok') from c29__p__p2;

drop table if exists c29;

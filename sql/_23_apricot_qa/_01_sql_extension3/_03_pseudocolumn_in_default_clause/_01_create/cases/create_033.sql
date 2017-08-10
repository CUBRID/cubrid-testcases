--create hash partition table partitioned by column with default value of USER and CURRENT_USER



--TEST: char(n) + USER
create table c33(col1 char(20) default USER, col2 int)
partition by hash(col1) partitions 4;

desc c33;
insert into c33 values default;

select if(count(*) = 1, 'ok', 'nok') from c33;
show tables like 'c33%';

drop table if exists c33;


--TEST: varchar + USER
create table c33(col1 char(20) default USER, col2 int)
partition by hash(col1) partitions 4;

desc c33;
insert into c33 values default;

select if(count(*) = 1, 'ok', 'nok') from c33;
show tables like 'c33%';

drop table if exists c33;


--TEST: string + CURRENT_USER
create table c33(col1 string default CURRENT_USER, col2 int)
partition by hash(col1) partitions 4;

desc c33;
insert into c33 values default;

select if(count(*) = 1, 'ok', 'nok') from c33;
show tables like 'c33%';

drop table if exists c33;

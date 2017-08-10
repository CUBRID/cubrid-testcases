--create range partition table partitioned by column with default value of USER and CURRENT_USER



--TEST: char(n) + USER
create table c30(col1 char(20) default USER, col2 int)
partition by range(col1)
(partition p1 values less than ('A'),
partition p2 values less than ('zzz'));

desc c30;
insert into c30 values default;

select if(count(*) = 1, 'ok', 'nok') from c30__p__p2;

drop table if exists c30;


--TEST: string + USER
create table c30(col1 string default USER, col2 int)
partition by range(col1)
(partition p1 values less than ('A'),
partition p2 values less than ('zzz'));

desc c30;
insert into c30 values default;

select if(count(*) = 1, 'ok', 'nok') from c30__p__p2;

drop table if exists c30;


--TEST: varchar + CURRENT_USER
create table c30(col1 char varying default CURRENT_USER, col2 int)
partition by range(col1)
(partition p1 values less than ('A'),
partition p2 values less than ('zzz'));

desc c30;
insert into c30 values default;

select if(count(*) = 1, 'ok', 'nok') from c30__p__p2;

drop table if exists c30;

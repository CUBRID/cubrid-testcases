--create list partition table partitioned by column with default value of USER and CURRENT_USER



--TEST: char(n) + USER
create table c36(col1 string default USER, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c36;
insert into c36(col2) values (3), (2);

select if(count(*) = 1, 'ok', 'nok') from c36__p__p1 where col1=CURRENT_USER;

drop table if exists c36;


--TEST: string  + USER
create table c36(col1 string default USER, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c36;
insert into c36(col2) values (3), (2);

select if(count(*) = 1, 'ok', 'nok') from c36__p__p1 where col1=CURRENT_USER;

drop table if exists c36;


--TEST: varchar + CURRENT_USER
create table c36(col1 char varying default CURRENT_USER, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c36;
insert into c36(col2) values (3), (2);

select if(count(*) = 1, 'ok', 'nok') from c36__p__p1 where col1=CURRENT_USER;

drop table if exists c36;

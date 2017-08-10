--create list partition table partitioned by column with default value of CURRENT_TIMESTAMP, UNIX_TIMESTAMP() and SYSTIMESTAMP



--TEST: CURRENT_TIMESTAMP
create table c34(col1 timestamp default CURRENT_TIMESTAMP, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c34;
insert into c34(col2) values(2), (6);
show tables like 'c34%';

select if(count(*)=2, 'ok', 'nok') from c34__p__p2 where (SYSTIMESTAMP-col1) < 600;

drop table if exists c34;


--TEST: UNIX_TIMESTAMP()
create table c34(col1 timestamp default UNIX_TIMESTAMP(), col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c34;
insert into c34(col2) values(2), (6);
show tables like 'c34%';

select if(count(*)=2, 'ok', 'nok') from c34__p__p2 where (SYSTIMESTAMP-col1) < 600;

drop table if exists c34;


--TEST: SYSTIMESTAMP
create table c34(col1 timestamp default SYSTIMESTAMP, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c34;
insert into c34(col2) values(2), (6);
show tables like 'c34%';

select if(count(*)=2, 'ok', 'nok') from c34__p__p2 where (SYSTIMESTAMP-col1) < 600;

drop table if exists c34;

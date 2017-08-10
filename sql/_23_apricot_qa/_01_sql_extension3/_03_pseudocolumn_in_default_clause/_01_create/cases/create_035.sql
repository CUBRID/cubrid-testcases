--create list partition table partitioned by column with default value of SYSDATE and SYSDATETIME



--TEST: date + SYSDATE
create table c35(col1 date default SYSDATE, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c35;
--TEST: insert default values
insert into c35(col2) values(1), (6);
select if(count(*)=1, 'ok', 'nok') from c35__p__p1 where col1=SYSDATE;

drop table if exists c35;


--TEST: timestamp + SYSDATE
create table c35(col1 timestamp default SYSDATE, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c35;
--TEST: insert default values
insert into c35(col2) values(1), (6);
select if(count(*)=1, 'ok', 'nok') from c35__p__p1 where col1=SYSDATE;

drop table if exists c35;


--TEST: datetime + SYSDATETIME
create table c35(col1 datetime default SYSDATETIME, col2 int)
partition by list(col2)
(partition p1 values in (1, 3, 5),
partition p2 values in (2, 4, 6));

desc c35;
--TEST: insert default values
insert into c35(col2) values(1), (6);
select if(count(*)=1, 'ok', 'nok') from c35__p__p1 where date(col1)=SYSDATE;

--TEST: [er] invalid value
insert into c35(col1) values(default);

drop table if exists c35;

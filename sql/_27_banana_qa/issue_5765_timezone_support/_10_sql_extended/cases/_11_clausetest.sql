set timezone 'Asia/Seoul';
--preparation
drop table if exists tztest;
create table tztest (id int, c_varchar varchar(2000),c_float float,
    c_tsltz1 timestampltz, c_dtltz1 datetimeltz,
    primary key (id,c_tsltz1));

create unique index idx_tsltz on tztest(c_dtltz1);

insert into tztest values(1,'abcd',100,timestampltz'1990-1-1 12:00:00 PM +9:00',datetimeltz'2000-10-1 12:00:00 AM +9:00'
     );
insert into tztest values(2,'abcd',33,timestampltz'1990-1-3 12:00:00 AM +9:00',datetimeltz'2000-10-2 12:00:00 AM +9:00'
    );
insert into tztest values(2,'abcd',55,timestampltz'1993-1-2 12:00:00 AM +9:00',datetimeltz'2000-10-3 12:00:00 AM +9:00'
     );
insert into tztest values(4,'abcd',99,timestampltz'1993-1-4 12:00:00 AM +9:00',datetimeltz'2000-10-4 12:00:00 AM +9:00'
     );
insert into tztest values(2,'abcd',99,timestampltz'1990-1-4 12:00:00 AM +9:00',datetimeltz'2001-10-4 12:00:00 AM +9:00'
     );
insert into tztest values(6,'abcd',99,timestampltz'1992-1-4 12:00:00 AM +9:00',datetimeltz'2002-10-4 12:00:00 AM +9:00'
     );

--+++++++++++++++++Test case - timestampltz++++++++++++++++
select year(c_tsltz1),count(*) from tztest where c_tsltz1 > timestampltz'1990-1-1 12:00:00 AM +9:00' group by year(c_tsltz1) order by c_tsltz1;
update tztest set c_varchar='updated' where exists (select * from tztest as B where tztest.id = B.id and tztest.c_tsltz1 = adddate(B.c_tsltz1, interval 1 DAY) );
select * from tztest where c_varchar='updated';
select A.id, A.c_tsltz1, max(A.c_float) from tztest as A, tztest as B where A.c_tsltz1 <= B.c_tsltz1 and A.id=B.id group by A.id having count( * ) <=3; 

--+++++++++++++++++Test case - datetimeltz+++++++++++++++++
select c_dtltz1,count(*) from tztest where c_dtltz1 > datetimeltz'1990-1-1 12:00:00 AM +9:00' group by year(c_dtltz1) order by c_dtltz1;
update tztest set c_varchar='updated1' where exists (select * from tztest as B where tztest.id = B.id and tztest.c_dtltz1 = adddate(B.c_dtltz1,interval 1 DAY) );
select A.id, A.c_dtltz1, max(A.c_float) from tztest as A, tztest as B where A.c_dtltz1 <= B.c_dtltz1 and A.id=B.id group by A.id having count( * ) <=3;

drop table tztest;
--Test case timestampltz
drop table if exists t1;
CREATE TABLE t1
(task_id CHAR(10) NOT NULL PRIMARY KEY,start_date timestampltz NOT NULL,end_date timestampltz NOT NULL);
INSERT INTO t1 VALUES (1, '1997-01-01', '1997-01-03'),(2, '1997-01-02', '1997-01-04'),
(3, '1997-01-04', '1997-01-05'),(4, '1997-01-06', '1997-01-09'),
(5, '1997-01-09', '1997-01-09'),(6, '1997-01-09', '1997-01-09'),
(7, '1997-01-12', '1997-01-15'),(8, '1997-01-13', '1997-01-14'),
(9, '1997-01-14', '1997-01-14'),(10, '1997-01-17', '1997-01-17');

SELECT T1.start_date, MAX(T2.end_date)
FROM t1 AS T1, t1 AS T2 WHERE T1.start_date < T2.end_date
AND NOT EXISTS
(SELECT * FROM t1 AS T3, t1 AS T4
WHERE T3.end_date < T4.start_date
AND T3.start_date >= T1.start_date
AND T3.end_date <= T2.end_date
AND T4.start_date >= T1.start_date
AND T4.end_date <= T2.end_date
AND NOT EXISTS
(SELECT * FROM t1 AS T5 WHERE T5.start_date BETWEEN T3.start_date AND T3.end_date
AND T5.end_date BETWEEN T4.start_date AND T4.end_date))
GROUP BY T1.start_date
HAVING t1.start_date = MIN(t2.start_date);

drop table t1;
-- Test case - datetimeltz
drop table if exists t1;
CREATE TABLE t1
(task_id CHAR(10) NOT NULL PRIMARY KEY,start_date datetimeltz NOT NULL,end_date datetimeltz NOT NULL);
INSERT INTO t1
VALUES (1, '1997-01-01', '1997-01-03'),(2, '1997-01-02', '1997-01-04'),
(3, '1997-01-04', '1997-01-05'),(4, '1997-01-06', '1997-01-09'),
(5, '1997-01-09', '1997-01-09'),(6, '1997-01-09', '1997-01-09'),
(7, '1997-01-12', '1997-01-15'),(8, '1997-01-13', '1997-01-14'),
(9, '1997-01-14', '1997-01-14'),(10, '1997-01-17', '1997-01-17');

SELECT T1.start_date, MAX(T2.end_date)
FROM t1 AS T1, t1 AS T2
WHERE T1.start_date < T2.end_date
AND NOT EXISTS
(SELECT * FROM t1 AS T3, t1 AS T4 WHERE T3.end_date < T4.start_date
AND T3.start_date >= T1.start_date
AND T3.end_date <= T2.end_date
AND T4.start_date >= T1.start_date
AND T4.end_date <= T2.end_date
AND NOT EXISTS
(SELECT * FROM t1 AS T5  WHERE T5.start_date BETWEEN T3.start_date AND T3.end_date
AND T5.end_date BETWEEN T4.start_date AND T4.end_date))
GROUP BY T1.start_date
HAVING t1.start_date = MIN(t2.start_date);

drop table t1;

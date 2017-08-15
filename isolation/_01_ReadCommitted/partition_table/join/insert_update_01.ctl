/*
Test Case: update & insert
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 select, C2 update, the affected rows are overlapped
C1 insert, C2 select
C1 commit, C2 commit
Metrics: data size = small, join query = left join, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will not be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 3
C1: select - insert;  
C2: update - select;  
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP TABLE IF EXISTS t3;
C1: CREATE TABLE t1(id int primary key, valueid INT, col varchar(10)) partition by hash (id) partitions 2;
C1: CREATE TABLE t2(id int primary key, col varchar(10)) partition by list (id) (partition p0 values in (1,3,5,7), partition p1 values in (2,4,6,8));
C1: CREATE TABLE t3(valueid int primary key, str varchar(10)) partition by range(valueid)(partition p1 values less than (10),partition p2 values less than (10000));
C1: INSERT INTO t1 VALUES(1,100,'abc'),(2,0,'def'),(3,0,null),(8,0,''),(4,5,'jkl'),(5,101,'mno'),(6,1000,'pqr'),(7,90,'');
C1: INSERT INTO t2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: INSERT INTO t3 VALUES(0,'aaa'),(1,'bbb'),(5,'ccc'),(1000,'ddd');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 a RIGHT JOIN t2 b ON a.id = b.id WHERE b.id >1 and b.id <7 order by 1,2;
MC: wait until C1 ready;
C2: update (t1 left join t2 on t1.id = t2.id) left join t3 on t1.valueid = t3.valueid set t1.col=t1.col+' a', t3.valueid=t1.valueid where t1.id=2 and t1.valueid=0 and t1.col is not null;
MC: wait until C2 ready;
C1: insert into t3(valueid, str) SELECT a.id+9, a.col+'xx' FROM t1 a RIGHT JOIN t2 b ON a.id = b.id WHERE b.id >1 and b.id <7;
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: SELECT * FROM t3 order by 1,2;
C2: COMMIT;
C2: SELECT * FROM t3 order by 1,2;
MC: wait until C2 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: SELECT * FROM t3 order by 1,2;
C1: COMMIT;
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

C1: quit;
C2: quit;


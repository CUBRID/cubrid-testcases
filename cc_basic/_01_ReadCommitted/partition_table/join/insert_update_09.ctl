/*
Test Case: update & insert
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 select, C2 update, C2 delete the affected rows are overlapped
C1 insert, C2 delete
C1 commit, C2 commit
Metrics: data size = small, join query = left join, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will not be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 3
C1: select - insert - delete;  
C2: update - select - delete;  
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP TABLE IF EXISTS t3;
C1: CREATE TABLE t1(id int primary key, numid INT, col varchar(10)) partition by hash (id) partitions 2;
C1: CREATE TABLE t2(id int primary key, col varchar(10)) partition by list (id) (partition p0 values in (1,3,5,7), partition p1 values in (2,4,6,8));
C1: CREATE TABLE t3(valueid int, str varchar(10), foreign key(valueid) references t1(id));
C1: INSERT INTO t1 VALUES(1,100,'abc'),(2,0,'def'),(3,0,null),(8,0,''),(4,5,'jkl'),(5,101,'mno'),(6,1000,'pqr'),(7,90,'');
C1: INSERT INTO t2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: INSERT INTO t3 VALUES(1,'bbb'),(5,'ccc'),(7,'ddd');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 a LEFT JOIN t2 b ON a.id = b.id WHERE b.id >1 and b.id <7 order by 1,2;
MC: wait until C1 ready;
C2: update (t1 left join t2 on t1.id = t2.id) RIGHT join t3 on t1.numid = t3.valueid set t1.col=t1.col+' a', t3.valueid=t1.numid where t1.id=2 and t1.numid=0 and t1.col is not null;
MC: wait until C2 ready;
C1: insert into t3(valueid, str) SELECT a.id, a.col+'xx' FROM t1 a LEFT JOIN t2 b ON a.id = b.id WHERE b.id >1 and b.id <7;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: DELETE a,b FROM t1 a LEFT JOIN t2 b ON a.id = b.id WHERE a.id > 7;
C2: SELECT * FROM t3 order by 1,2;
MC: wait until C2 ready;
C1: DELETE a,b FROM t1 a LEFT JOIN t2 b ON a.id = b.id WHERE a.id < 5;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
C3: insert into t3(valueid, str) SELECT a.id, a.col+'xx' FROM t1 a LEFT JOIN t2 b ON a.id = b.id WHERE b.id >1 and b.id <7;
MC: wait until C3 blocked;
C1: COMMIT;
MC: wait until C3 ready;
C3: DELETE FROM t3 WHERE valueid > 5;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
C2: SELECT * FROM t3 order by 1,2;
MC: wait until C2 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: SELECT * FROM t3 order by 1,2;
C1: COMMIT;
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: SELECT * FROM t3 order by 1,2;
MC: wait until C2 ready;
C3: SELECT * FROM t1 order by 1,2;
C3: SELECT * FROM t3 order by 1,2;
C3: COMMIT;
MC: wait until C3 ready;

C1: quit;
C2: quit;


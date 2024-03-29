/*
Test Case: ALTER view
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 ALTER, C2 ALTER, C3 ALTER
C1 commit, C2 commit, C3 commit
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 3
C1: ALTER - update - select;  
C2: ALTER - select;  
C3: ALTER - select;
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
C1: DROP VIEW IF EXISTS t1_view;
C1: CREATE TABLE t1(id int primary key, phone varchar(10)) DONT_REUSE_OID partition by hash (id) partitions 2;
C1: INSERT INTO t1 VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);
C1: CREATE TABLE t2(id int primary key, address varchar(10)) DONT_REUSE_OID partition by range (id) (partition p0 values less than (3), partition p1 values less than (100));
C1: INSERT INTO t2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: CREATE VIEW t1_view AS SELECT t1.id, t1.phone, t2.address FROM t1, t2 WHERE phone IS NOT NULL and t1.id=t2.id;
C1: commit;

C1: ALTER VIEW t1_view ADD QUERY SELECT t1.id, t1.phone, t2.address FROM t1, t2 WHERE t1.id IN (4,5,7);
MC: wait until C1 ready;
C2: ALTER VIEW t1_view AS SELECT * FROM t1 WHERE phone IS NOT NULL;
MC: wait until C2 blocked;
C3: ALTER VIEW t1_view ADD QUERY SELECT t1.id, t1.phone FROM t1, t2 WHERE phone IS NULL and t1.id=t2.id;
MC: wait until C3 blocked;
C1: SELECT * FROM t1_view order by 1,2,3;
C1: COMMIT;
MC: wait until C2 ready;
C2: update t1_view set id=7 where id=1;
C2: SELECT * FROM t1_view order by 1,2;
C2: COMMIT;
MC: wait until C3 ready;
C3: SELECT * FROM t1_view order by 1,2;
C3: COMMIT;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

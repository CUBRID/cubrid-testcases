/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update, C2 delete, the affected rows are totally overlapped(without where clause)

NUM_CLIENTS = 2
C1: UPDATE t SET col = 'abcd';
C2: DELETE FROM t; -- expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc'),(20,'def'),(3,'ghi'),(40,'jkl');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t SET col = 'abcd';
MC: wait until C1 ready;
C2: DELETE FROM t;
MC: wait until C2 blocked;
/* expect no rows */
C1: SELECT * FROM t order by 1,2;
C1: commit;
MC: wait until C2 ready;
/* expect no rows */
C2: SELECT * FROM t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

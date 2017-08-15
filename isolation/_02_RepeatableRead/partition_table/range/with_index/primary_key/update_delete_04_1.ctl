/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update, C2 delete, the affected rows are totally overlapped(without where clause)
primary key and partition id is not on the same column

NUM_CLIENTS = 2
C1: UPDATE t SET col = 'abcd';
C2: DELETE FROM t; -- expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int,col varchar(10), primary key(id)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc');
C1: INSERT INTO t VALUES(20,'def');
C1: INSERT INTO t VALUES(3,'ghi');
C1: INSERT INTO t VALUES(40,'jkl');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1,2;
MC: wait until C2 ready;
C1: UPDATE t SET id=id+10;
MC: wait until C1 ready;
C2: DELETE FROM t;
MC: wait until C2 blocked;

/* expect (11,'abc'),(30,'def'),(13,'ghi'),(50,'jkl') */
C1: SELECT * FROM t order by 1,2;
MC: wait until C1 ready;
C1: commit;
MC: wait until C2 ready;
/* expect (1,'abc'),(20,'def'),(3,'ghi'),(40,'jkl') */
C2: SELECT * FROM t order by 1,2;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

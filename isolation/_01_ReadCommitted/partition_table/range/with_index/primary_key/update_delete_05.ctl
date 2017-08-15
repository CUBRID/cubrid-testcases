/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update p1, C2 delete p2

NUM_CLIENTS = 2
C1: UPDATE t SET col = 'abcd' where id<10;
C2: DELETE FROM t where id>10; -- expected ready
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int primary key, col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc'),(20,'def'),(3,'ghi'),(40,'jkl');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t SET col = concat(col,'abcd') where id<10;
MC: wait until C1 ready;
C2: DELETE FROM t where id>10;
MC: wait until C2 ready;
/* expect (1,'abcabcd'),(20,'def'),(3,'ghiabcd'),(40,'jkl') */
C1: SELECT * FROM t order by 1,2;
MC: wait until C1 ready;
/* expect (1,'abc'),(3,'ghi') */
C2: SELECT * FROM t order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

/* expect (1,'abcabcd'),(3,'ghiabcd') */
C2: SELECT * FROM t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

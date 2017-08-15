/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) 

Test Point:
C1 update, C2 delete, C3 delete, the affected rows are overlapped

NUM_CLIENTS = 3
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'a');
C1: INSERT INTO t VALUES(20,'b');
C1: INSERT INTO t VALUES(3,'c');
C1: INSERT INTO t VALUES(40,'d');
C1: INSERT INTO t VALUES(50,'a');
C1: INSERT INTO t VALUES(6,'b');
C1: INSERT INTO t VALUES(7,'c');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t SET col = 'abcd' WHERE id = 1 or id = 20 or id = 3;
MC: wait until C1 ready;
C2: DELETE FROM t WHERE col='a';
MC: wait until C2 blocked;
MC: sleep 1;
C3: delete from t where id<10;
MC: wait until C3 blocked;
/* expect (1,'abcd'),(20,'abcd'),(3,'abcd'),(40,'d'),(50,'a'),(6,'b'),(7,'c') */
C1: SELECT * FROM t order by 1,2;
C1: commit;
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;

/* expect (20,'abcd')(40,'d') */
C2: SELECT * FROM t order by 1,2;
C2: commit;

C1: quit;
C2: quit;
C3: quit;

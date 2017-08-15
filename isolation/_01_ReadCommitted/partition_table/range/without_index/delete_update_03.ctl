/*
Test Case: delete & update
Priority: 1
Reference case:
Author: Rong Xu

Test Plan:
Test UPDATE/DELETE locks (X_LOCK on instance)

Test Point:
C1 delete many rows
  C2 update which includes C1 deleted row
  C2 commit
C1 commit

NUM_CLIENTS = 2
C1: DELETE FROM t WHERE id<20 and sleep(1)=0;
MC: sleep 1;
C2: UPDATE t SET id=30 where id=13;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc'),(12,'abc'),(13,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t WHERE id<20;
MC: sleep 1;
C2: UPDATE t SET id=30 where id=13;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: commit;

/* expected no value */
C2: SELECT * FROM t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

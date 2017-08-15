/*
Test Case: update & delete
Priority: 
Reference case: 
Author: Rong Xu

Test Point:
one user update value from one partition to another, then update back, 
another user delete it 

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: commit;
MC: wait until C1 ready;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: INSERT INTO t VALUES(1,'abc');
C1: INSERT INTO t VALUES(10,'abc');
C1: INSERT INTO t VALUES(40,'ghi');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t SET id = id+10 WHERE id<10;
MC: wait until C1 ready;
C2: DELETE FROM t WHERE id >10;
/* expect (1,'abc'),(10,'abc') */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

/* expect serializable failed */
C1: UPDATE t SET id = id-10 WHERE id>10;
/* expect update 1 row */
C1: UPDATE t SET id = id-10 WHERE id=11;
MC: wait until C1 ready;

/* expect:(1,'abc'),(10,'abc'),(40,'ghi') */
C1: SELECT * FROM t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: (1,'abc'),(10,'abc') */
C2: SELECT * FROM t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

/*
Test Case: insert & delete
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes
-    Delete: X_LOCK acquired on current instance
there is index on t1(id,col), delete and insert value has overlap on id

NUM_CLIENTS = 3
C2: insert into t1 values(5,'123'); -- expected ok, not to be deleted
C1: DELETE FROM t1 WHERE id = 5; -- expected no block
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: create index idx on t1(id,col);
C1: INSERT INTO t1 VALUES(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'ghi');insert into t1 values(5,'jkl');insert into t1 values(5,'mno');insert into t1 values(5,'jjj');insert into t1 values(7,'stu');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
/* expected insert 1 row */
C1: insert into t1 values(5,'123');
MC: wait until C1 ready;

/* expect delete 3 rows */
C2: DELETE FROM t1 WHERE id = 5;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect 8 rows selected */
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

/* expect 4 rows selected */
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

/* expect (1,abc)(2,def)(3,ghi)(5,123)(7,stu) */
C3: select * from t1 order by 1,2;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

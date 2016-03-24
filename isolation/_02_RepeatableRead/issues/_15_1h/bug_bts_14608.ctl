/*
Issue Case: CUBRIDSUS-14608
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Ray

Test Plan: 
Test the error message is different or not if the query against unique key constrain

Test Scenario:
C1 delete C2 update
C1 commit, C2 commit

Test Point:
1) C2 need to be blocked for C1 (locking)
2) C2 should generate a pk violation error rather than serializable conflict
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case 1 */
C1: delete from t1 where id = 1;
MC: wait until C1 ready;
/* expect: C2 need to wait for C1 */
C2: update t1 set id = 1 where id = 2 or id = 3;
MC: wait until C2 blocked;
C1: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C1: commit;
/* expect: ERROR RETURNED: Operation would have caused one or more unique constraint violations */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C2: commit;

C1: quit;
C2: quit;

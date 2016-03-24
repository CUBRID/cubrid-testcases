/*
Issue Case: CUBRIDSUS-14300 
Priority: 1
Reference case:
Isolation Read Committed
Author: Ray

Test Plan: 
Test the scenario that the select transaction should not blocked if a concurrent transaction using DML with ROWNUM function,
but the DML transaction should be blocked if it takes a sequential scan and requires X-lock on the overlapped tuple that is locked by another transaction 

Test Scenario:
C1 delete with ROWNUM, C2 select, the affected rows are not overlapped (based on where clause)
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2(select) doesn't need to wait for C1 (locking)
2) C1 could see the C1 changes (read committed)
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, title VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');
MC: wait until C1 ready;
C1: INSERT INTO t1 VALUES(2,'def');
MC: wait until C1 ready;
C1: INSERT INTO t1 VALUES(3,'ghi');
MC: wait until C1 ready;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ROWNUM = 1 ;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE ROWNUM = 2;
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: rollback;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C2: rollback;

C1: DELETE FROM t1 WHERE ROWNUM > 5;
MC: wait until C1 ready;
C2: SELECT * FROM t1 WHERE id = 1;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: rollback;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C2: rollback;

C1: quit;
C2: quit;
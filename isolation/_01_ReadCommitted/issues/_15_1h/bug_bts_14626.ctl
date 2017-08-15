/*
Issue Case: CUBRIDSUS-14626
Priority: 1
Reference case:
Isolation Repeatable Read
Author: Ray

Test Plan: 
Test the scenario that the data shouldn't disappeared when transaction execute with incr/decr

Test Scenario:
C1 select incr/decr, C2 select
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 shouldn't needs to be blocked wait for C1 (locking)
2) C2 could see the C1 changes since incr/decr is irrelevant with transaction
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: CREATE TABLE t(id INT, count_no INT);
C1: INSERT INTO t VALUES(1,100),(2,200);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT id, DECR(count_no) FROM t WHERE id = 2;
MC: wait until C1 ready;
C2: SELECT * FROM t ORDER BY 1,2; 
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C2: commit;

C1: SELECT id, INCR(count_no) FROM t WHERE id = 2;
MC: wait until C1 ready;
C2: SELECT * FROM t ORDER BY 1,2; 
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C2: commit;


C1: quit;
C2: quit;
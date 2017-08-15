/*
Issue Case: CUBRIDSUS-14863
Priority: 1
Reference case:
Isolation Levels: Read Committed 
Author: Ray

Test Plan: 
Test the scenario to check if there is a re-evaluation/visibility problem when transactions operate SELECT...FOR UPDATE

Test Scenario:
C1 select for update, C2 select for update
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 needs to be blocked wait for C1 (locking)
2) C2 could see the C1 changes since read committed
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* test point 1: alter&select */
/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: CREATE TABLE t (id INT, col varchar(20));
C1: INSERT INTO t VALUES (1, 'Hello');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t WHERE id = 1 FOR UPDATE;
MC: wait until C1 ready;
C2: SELECT * FROM t WHERE id = 1 FOR UPDATE;
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: UPDATE t SET col = 'Hello1';
C1: commit;
MC: wait until C2 ready;
C2: select * from t order by id; 
MC: wait until C2 ready;
C2: commit;

C1: UPDATE t SET col = 'Hello2';
MC: wait until C1 ready;
C2: SELECT * FROM t;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C2: SELECT * FROM t;
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;
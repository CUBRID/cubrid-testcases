/*
Test Case: Alter view
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 alter, C2 select, C2 select the affected rows are overlapped
C1 commit, C2 commit
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 2
C1: alter - select;  
C2: select;  
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: CREATE TABLE t1(id INT primary key, phone VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);
C1: CREATE VIEW t1_view AS SELECT * FROM t1 WHERE phone IS NOT NULL WITH CHECK OPTION;
C1: commit;

C1: ALTER VIEW t1_view ADD QUERY SELECT * FROM t1 WHERE id IN (1,2);
MC: wait until C1 ready;
C2: SELECT * FROM t1_view order by 1,2;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C2 ready;
C2: SELECT * FROM t1_view order by 1,2;
C2: COMMIT;
MC: wait until C2 ready;

C1: quit;
C2: quit;


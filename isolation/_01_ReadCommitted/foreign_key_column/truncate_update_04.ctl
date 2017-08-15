/*
Test Case: truncate & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/foreign_key_column/truncate_update_01.ctl
Author: Lily

Test Point:
B reference A, truncate B, update A, A is blocked.

NUM_CLIENTS = 2
C1: truncate table reference table; 
C2: update referenced table;
C1: rollback;
C2: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT PRIMARY KEY,col VARCHAR(10));
C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON UPDATE SET NULL);
C1: INSERT INTO t_primary VALUES(1,'a'),(2,'b');
C1: INSERT INTO t_foreign VALUES(1,'do'),(2,'test'),(1,'make'),(2,'spell');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: TRUNCATE TABLE t_foreign;
MC: wait until C1 ready;
C2: UPDATE t_primary SET id=10 WHERE id=2;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM t_primary ORDER BY 1,2;
C1: SELECT * FROM t_foreign ORDER BY 1,2;
C1: commit;

C2: quit;
C1: quit;


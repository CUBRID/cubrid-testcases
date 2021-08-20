/*
Test Case: truncate & delete
Priority: 1
Reference case:
Author: Lily

Test Point:
B reference A, truncate A, delete B, B is blocked.

NUM_CLIENTS = 2
C1: truncate table referenced table; 
C2: delete from reference table;
C1: commit;
C2: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT PRIMARY KEY,col VARCHAR(10));
C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE);
C1: INSERT INTO t_primary VALUES(1,'a'),(2,'b');
C1: INSERT INTO t_foreign VALUES(1,'do'),(2,'test'),(1,'make'),(2,'spell');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE t_primary CASCADE;
MC: wait until C1 ready;
C2: DELETE FROM t_foreign WHERE id=2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM t_primary ORDER BY id,col;
C2: SELECT * FROM t_foreign ORDER BY id,col;
C2: commit;
C2: SELECT * FROM t_primary ORDER BY id,col;
C2: SELECT * FROM t_foreign ORDER BY id,col;
C2: commit;

C2: quit;
C1: quit;


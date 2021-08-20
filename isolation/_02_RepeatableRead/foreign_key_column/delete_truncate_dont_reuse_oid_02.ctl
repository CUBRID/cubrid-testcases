/*
Test Case: truncate & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/foreign_key_column/delete_truncate_01.ctl
Author: Lily

Test Point:
B reference A, delete A,truncate B, B is blocked.

NUM_CLIENTS = 2
C1: delete from referenced table;
C2: truncate table reference table; 
C1: rollback;
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
C1: CREATE TABLE t_primary(id INT PRIMARY KEY,col VARCHAR(10)) DONT_REUSE_OID;
C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE) DONT_REUSE_OID;
C1: CREATE TABLE obj_ref(obj1 t_primary, obj2 t_foreign);
C1: INSERT INTO t_primary VALUES(1,'a'),(2,'b');
C1: INSERT INTO t_foreign VALUES(1,'do'),(2,'test'),(1,'make'),(2,'spell');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t_primary WHERE id=1;
MC: wait until C1 ready;
C2: TRUNCATE TABLE t_foreign;
MC: wait until C2 blocked;
C1: SELECT * FROM t_primary ORDER BY id,col;
C1: SELECT * FROM t_foreign ORDER BY id,col;
C1: rollback;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM t_primary ORDER BY id,col;
C1: SELECT * FROM t_foreign ORDER BY id,col;
C1: INSERT INTO t_foreign VALUES(1,'do'),(2,'test'),(1,'make'),(2,'spell');
C1: commit;

C1: DELETE FROM t_foreign WHERE id=1;
MC: wait until C1 ready;
C2: TRUNCATE TABLE t_primary CASCADE;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C1: SELECT * FROM t_primary ORDER BY id,col;
MC: wait until C1 blocked;
C2: SELECT * FROM t_primary ORDER BY id,col;
C2: commit;
MC: wait until C1 ready;
C2: SELECT * FROM t_primary ORDER BY id,col;
C2: SELECT * FROM t_foreign ORDER BY id,col;
C2: commit;
C1: SELECT * FROM t_primary ORDER BY id,col;
C1: SELECT * FROM t_foreign ORDER BY id,col;
C1: commit;
C2: quit;
C1: quit;


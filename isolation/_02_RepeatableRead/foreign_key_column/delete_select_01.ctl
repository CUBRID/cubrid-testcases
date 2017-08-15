/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
B reference A, when there is overlap, test the behavior
there is rollback

NUM_CLIENTS = 2
C1: delete from referenced table; 
C2: select from reference table;
C1: rollback;
C2: commit;

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT PRIMARY KEY,col VARCHAR(10));
C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE);
C1: INSERT INTO t_primary VALUES(1,'a');
C1: INSERT INTO t_foreign VALUES(1,'test');
C1: commit work;

/* test case */
C1: INSERT INTO t_primary VALUES(2,'b');
C1: DELETE FROM t_primary WHERE id=1;
MC: wait until C1 ready;
C2: INSERT INTO t_primary VALUES(3,'c');
C2: SELECT * FROM t_foreign WHERE id=1;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: commit;

C2: SELECT * FROM t_primary ORDER BY id;
C2: SELECT * FROM t_foreign ORDER BY id;
C2: commit;

C2: quit;
C1: quit;


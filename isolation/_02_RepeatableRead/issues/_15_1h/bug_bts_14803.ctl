/*
Issue Case: CUBRIDSUS-14803
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Lily

Issue title:
[MVCC][Repeatable read]The behavior is different between CUBRID and ORACLE if run ddl.

Test Point:
1) Result of test case 1 should be same as test case 2
2) Both cases return NULL in Oracle.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;

/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: CREATE TABLE t(id INT,col VARCHAR(10));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case 1 */
C1: ALTER TABLE t ADD COLUMN age INT;
C1: INSERT INTO t(id,col) VALUES(1,'make'),(2,'spell');
MC: wait until C1 ready;
C2: DELETE FROM t WHERE id=2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM t order by 1;
C2: commit;
MC: wait until C2 ready;

/* test case 2 */
C1: drop table t;	 
C1: CREATE TABLE t(id INT,col VARCHAR(10));	 
C1: INSERT INTO t(id,col) VALUES(1,'make'),(2,'spell');
MC: wait until C1 ready;
C2: DELETE FROM t WHERE id=2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM t order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

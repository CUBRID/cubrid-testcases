/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
B reference A, select A and select B.

NUM_CLIENTS = 2
C1: select table reference table; 
C2: select table referenced table;
C1: commit;
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
C1: INSERT INTO t_primary VALUES(1,'a'),(2,'b');
C1: INSERT INTO t_foreign VALUES(1,'do'),(2,'test'),(1,'make'),(2,'spell');
C1: commit work;

/* test case */
C1: select * from t_foreign order by id,2;
MC: wait until C1 ready;

C2: select * from t_primary order by id,2;
MC: wait until C2 ready;

C1: select * from t_primary order by id,2;
MC: wait until C1 ready;

C2: select * from t_foreign order by id,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

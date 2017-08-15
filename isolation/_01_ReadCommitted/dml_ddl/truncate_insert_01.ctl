/*
Test Case: truncate table & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
-    Truncate table: SCH_M_LOCK on a table.
-    Insert: X_LOCK on first key OID for unique indexes.
C1 truncate table, C2 insert a row, then C2 is blocked.
when C1 committed, C2 succeeded insert.

NUM_CLIENTS = 2
C1: TRUNCATE TABLE tb1;
C2: INSERT INTO tb1 VALUES(2,'abcdef');

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(2,'abcdef');
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: commit work;
/* expected (2,'abcdef') */
C2: SELECT * FROM tb1 order by 1,2;
C2: commit work;

C2: quit;
C1: quit;

/*
Test Case: rename table & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
-    Rename table: SCH_M_LOCK on the table object  (???)
-    Insert: X_LOCK on first key OID for unique indexes. 
C1 rename table, C2 insert a row, then C2 is blocked.
when C1 committed, C2 failed insert. 

NUM_CLIENTS = 2
C1: RENAME TABLE tb1;
C2: INSERT INTO tb1 VALUES(2,'abcdef');

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: commit work;

/* test case */
C1: RENAME TABLE tb1 AS tb2;
MC: wait until C1 ready;
C2: INSERT INTO tb2 VALUES(2,'abcdef');
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: commit work;
C2: SELECT * FROM tb2 ORDER BY id;
C2: commit work;

C2: quit;
C1: quit;

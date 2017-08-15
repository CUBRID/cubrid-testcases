/*
Test Case: rename table & select
Priority: 1
Reference case:
Author: Lily

Test Point:
-    rename table: SCH_M_LOCK on the table object. (?????)
-    select: no row locks acquired but IS_LOCK for table.
C1 drop table, C2 select rows, then C2 is blocked.
when C1 committed, C2 succeeded select. 

NUM_CLIENTS = 2
C1: DROP TABLE tb1;
C2: SELECT * FROM tb1 order by 1,2;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT AUTO_INCREMENT PRIMARY KEY,col VARCHAR(10),grade INT);
C1: INSERT INTO tb1 VALUES(NULL,'abc', 15);
C1: INSERT INTO tb1 VALUES(NULL,'def', 34);
C1: commit work;

/* test case */
C1: RENAME TABLE tb1 AS tb2;
MC: wait until C1 ready;
C2: SELECT * FROM tb2 order by 1,2;
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: SELECT * FROM tb2 ORDER BY id;
C2: commit work;

C2: quit;
C1: quit;

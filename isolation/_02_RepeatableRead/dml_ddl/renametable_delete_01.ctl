/*
Test Case: rename table & delete
Priority: 1
Reference case:
Author: Lily

Test Point:
-    Rename table: SCH_M_LOCK on the table object  (????)
-    Delete: X_LOCK acquired on current instance. 
C1 rename table, C2 delete rows, then C2 is blocked.
when C1 committed, C2 succeeded delete. 

NUM_CLIENTS = 2
C1: RENAME TABLE tb1 AS tb2; 
C2: DELETE FROM tb1 WHERE id > 1;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: commit work;

/* test case */
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: RENAME TABLE tb1 AS tb2;
MC: wait until C1 ready;
C2: DELETE FROM tb2 WHERE id > 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: select * from tb2 order by id;
C2: commit work;
MC: wait until C2 ready;
C1: select * from tb2 order by id;
MC: wait until C1 ready;
C2: select * from tb2 order by id;
C2: commit work;

C2: quit;
C1: quit;

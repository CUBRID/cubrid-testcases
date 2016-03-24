/*
Test Case: rename table & update
Priority: 1
Reference case:
Author: Lily

Test Point:
-    rename table: SCH_M_LOCK on the table object.  (???)
-    Update: X_LOCK acquired on current instance. 
C1 alter table, C2 update rows, then C2 is blocked.
when C1 committed, C2 succeeded update. 

NUM_CLIENTS = 2
C1: RENAME TABLE tb1 AS tb2; 
C2: UPDATE tb1 SET grade=grade+10 WHERE grade < 20;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT AUTO_INCREMENT PRIMARY KEY,col VARCHAR(10),grade INT);
C1: INSERT INTO tb1 VALUES(NULL,'abc', 15);
C1: INSERT INTO tb1 VALUES(NULL,'def', 34);
C1: commit work;

/* test case */
C1: INSERT INTO tb1 VALUES(NULL,'tes', 2);
C1: RENAME TABLE tb1 AS tb2;
MC: wait until C1 ready;
C2: UPDATE tb2 SET grade=grade+10 WHERE grade < 20;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: select * from tb2 order by id;
C2: commit work;
C2: select * from tb2 order by id;
C2: commit;

C2: quit;
C1: quit;

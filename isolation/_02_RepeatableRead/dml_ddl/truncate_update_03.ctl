/*
Test Case: truncate table & update
Priority: 2 
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/truncate_update_01.ctl
Author: Lily

Test Point:
-    Truncate table: SCH_M_LOCK on the table.
-    Update: X_LOCK acquired on current instance. 
C1 update rows, C2 truncate the table, then C2 is blocked.
when C1 committed, C2 succeeded truncate. 

NUM_CLIENTS = 2
C1: UPDATE tb1 SET grade=grade+10 WHERE grade < 20;
C2: TRUNCATE TABLE tb1; 

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
C1: UPDATE tb1 SET grade=grade+10 WHERE grade < 20;
MC: wait until C1 ready;
C2: TRUNCATE TABLE tb1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: select * from tb1 order by id;
C2: commit work;
/* expected no rows */
C2: select * from tb1 order by id;
C2: commit;

C2: quit;
C1: quit;

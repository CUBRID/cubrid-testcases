/*
Test Case: alter table & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_select_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table object.
-    select: no row locks acquired but IS_LOCK for table.
C1 select rows, C2 alter table, then C2 is blocked.
when C1 committed, C2 succeeded alter table. 

NUM_CLIENTS = 2
C1: SELECT id,col,grade FROM tb1 order by 1,2;
C2: ALTER TABLE tb1 MODIFY grade VARCHAR(10);

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
c1: INSERT INTO tb1 VALUES(NULL,'def', 34);
C1: commit work;

/* test case */
C1: SELECT id,col,grade FROM tb1 order by 1,2;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 MODIFY grade VARCHAR(10);
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: commit work;
C2: DESC tb1;
C2: quit;
C1: quit;

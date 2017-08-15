/*
Test Case: alter table & truncate
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_truncate_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table.
-    truncate: X_LOCK on the table.
T1 alter a table, T2 truncate the table, then T2 is blocked.
when T1 rollback, T2 succeeded truncate.

NUM_CLIENTS = 2
C1: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 10;
C2: TRUNCATE TABLE tb1;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 values(1,'abc');
C1: INSERT INTO tb1 values(2,'def');
C1: commit work;

/* test case */
C1: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 10;
MC: wait until C1 ready;
C2: TRUNCATE TABLE tb1;
MC: sleep 1;
MC: wait until C2 blocked;
C1: rollback;

MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * from tb1 order by 1,2;
MC: wait until C1 ready;
C2: DESC tb1;
C2: commit work;

C2: quit;
C1: quit;

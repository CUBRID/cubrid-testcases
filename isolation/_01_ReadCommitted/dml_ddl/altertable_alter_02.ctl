/*
Test Case: alter table & alter table
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_alter_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table.
-    alter table: X_LOCK on the table.
C1 alter table, C2 also alter the table, then C2 is blocked.
when C1 rollback, C2 succeeded alter.

NUM_CLIENTS = 2
C1: ALTER TABLE tb1 DROP COLUMN grade;
C2: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 0 NOT NULL;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,'abc',10,'mike@nnn.com');
C1: INSERT INTO tb1 VALUES(2,'edf',20,'sofy@nnn.com');
C1: commit work;

/* test case */
C1: ALTER TABLE tb1 DROP COLUMN grade;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 0 NOT NULL;
MC: sleep 1;
MC: wait until C2 blocked;
C1: rollback;

MC: wait until C2 ready;
C2: commit work;
C2: SELECT * FROM tb1 order by 1,2;
C2: commit work;

C2: quit;
C1: quit;

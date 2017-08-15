/*
Test Case: alter table & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_insert_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table. 
-    Insert: X_LOCK on first key OID for unique indexes. 
C1 insert a row, C2 alter a table, then C2 is blocked.
when C1 committed, C2 failed insert(because of unique constraint). 

NUM_CLIENTS = 2
C1: INSERT INTO tb1 VALUES(2,'abc');
C2: ALTER TABLE tb1 ADD CONSTRAINT u_key1 UNIQUE (col);
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
C1: INSERT INTO tb1 VALUES(2,'abc');
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD CONSTRAINT u_key1 UNIQUE (col);
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: commit work;
C1: show index from tb1; 
C2: commit;

C2: quit;
C1: quit;

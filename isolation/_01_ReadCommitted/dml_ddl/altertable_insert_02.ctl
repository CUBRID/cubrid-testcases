/*
Test Case: alter table & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_insert_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table object
-    Insert: X_LOCK on first key OID for unique indexes. 
C1 alter table, C2 insert a row, then C2 is blocked.
when C1 rollback, C2 succeeded insert. 

NUM_CLIENTS = 2
C1: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 0 NOT NULL; 
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
C1: ALTER TABLE tb1 ADD COLUMN age INT DEFAULT 0 NOT NULL;
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(2,'abcdef');
MC: sleep 1;
MC: wait until C2 blocked;
C1: rollback;

MC: wait until C2 ready;
C2: commit work;
C2: SELECT * FROM tb1 order by 1,2;
C2: commit work;

C2: quit;
C1: quit;

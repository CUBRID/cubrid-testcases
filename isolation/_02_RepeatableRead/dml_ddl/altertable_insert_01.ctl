/*
Test Case: alter table & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table object
-    Insert: X_LOCK on first key OID for unique indexes. 
C1 alter table, C2 insert a row, then C2 is blocked.
when C1 committed, C2 failed insert. 

NUM_CLIENTS = 2
C1: ALTER TABLE tb1 ADD COLUMN age int DEFAULT 0 NOT NULL; 
C2: INSERT INTO tb1 VALUES(2,'abcdef');

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: show tables;
MC: wait until C2 ready;
C1: INSERT INTO tb1(id, col) VALUES(2,'abcdef');
C1: ALTER TABLE tb1 ADD COLUMN age int DEFAULT 0 NOT NULL;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C2: INSERT INTO tb1(id, col) VALUES(2,'def');
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;

C2: select * from tb1 order by 1,2;
MC: wait until C2 ready;
C2: commit work;
C2: select * from tb1 order by 1,2;
C2: commit work;

C2: quit;
C1: quit;

/*
Test Case: alter table & truncate
Priority: 1
Reference case:
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table.
-    truncate: X_LOCK on the table. 
T1 truncate a table, T2 alter the table, then T2 is blocked.
when T1 committed, T2 succeeded alter. 

NUM_CLIENTS = 2
C1: TRUNCATE TABLE tb1;
C2: ALTER TABLE tb1 ADD CONSTRAINT pk_tb1_id PRIMARY KEY(id);

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 values(1,'abc');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD CONSTRAINT pk_tb1_id PRIMARY KEY(id);
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: select * from tb1 order by id;
C2: commit work;
C2: select * from tb1 order by id;
MC: wait until C2 ready;
C1: show index from tb1;
C1: commit work;

C2: quit;
C1: quit;

/*
Test Case: alter table & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/altertable_delete_01.ctl
Author: Lily

Test Point:
-    Alter table: SCH_M_LOCK on the table object
-    Delete: X_LOCK acquired on current instance. 
C1 delete rows, C2 add a index, then C2 is blocked.
when C1 committed, C2 succeeded add a index. 

NUM_CLIENTS = 2
C1: DELET FROM tb1 where id > 2; 
C2: ALTER TABLE tb1 ADD INDEX inx_1(grade DESC);

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id int primary key,col varchar(10), grade int);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 where id > 2;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD INDEX inx_1(grade DESC);
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: commit work;
C2: SELECT * FROM tb1 order by 1,2; 
C2: show index from tb1;
C2: commit work;

C2: quit;
C1: quit;

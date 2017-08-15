/*
Test Case: truncate table & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/truncate_insert_01.ctl
Author: Lily

Test Point:
-    Truncate table: SCH_M_LOCK on a table.
-    Insert: X_LOCK on first key OID for unique indexes.
C1 insert a row, C2 truncate the table, then C2 is blocked.
when C1 committed, C2 succeeded truncate.

NUM_CLIENTS = 2
C1: INSERT INTO tb1 VALUES(2,'abcdef');
C2: TRUNCATE TABLE tb1;

*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: commit work;

/* test case */
C1: INSERT INTO tb1 VALUES(2,'abcdef');
MC: wait until C1 ready;

C2: TRUNCATE TABLE tb1;
MC: wait until C2 blocked;

C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: select * from tb1 order by id,2;
MC: wait until C1 blocked;

C2: select * from tb1 order by id,2;
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;

/* expected no rows */
C2: select * from tb1 order by id,2;
C2: commit work;
MC: wait until C2 ready;

C1: commit;
C2: quit;
C1: quit;

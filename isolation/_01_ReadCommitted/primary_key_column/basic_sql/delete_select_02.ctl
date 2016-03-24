/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 delete rows, C2 select rows, overlapped.
C1 rollback, C2 succeeded select.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 2;
C2: SELECT * FROM tb1 ORDER BY id;
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
C1: INSERT INTO tb1 VALUES(2,'EFD');
C1: INSERT INTO tb1 VALUES(3,'IHT');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 2;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: DELETE FROM tb1 WHERE id = 3;
MC: wait until C2 ready;
C1: rollback;
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit work;

C2: quit;
C1: quit;

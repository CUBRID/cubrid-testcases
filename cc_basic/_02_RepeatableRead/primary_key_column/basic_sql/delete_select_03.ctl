/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
change made by current transaction is visible.

NUM_CLIENTS = 1
C1: DELETE FROM tb1 WHERE id =1;
C1: DELETE FROM tb1 WHERE id =3;
C1: SELECT * FROM tb1 ORDER BY id;
C1: rollback;
C1: SELECT * FROM tb1 ORDER BY id;
*/

MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: INSERT INTO tb1 VALUES(2,'EFD');
C1: INSERT INTO tb1 VALUES(3,'IHT');
C1: INSERT INTO tb1 VALUES(4,'Test');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id = 1;
C1: DELETE FROM tb1 WHERE id = 3;
MC: wait until C1 ready;
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C1: rollback;
C1: SELECT * FROM tb1 ORDER BY id;
C1: commit work;

C1: quit;

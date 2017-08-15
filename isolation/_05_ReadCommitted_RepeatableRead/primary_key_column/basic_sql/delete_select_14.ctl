/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
more transactions delete rows;

NUM_CLIENTS = 3
C1: DELETE FROM tb1 WHERE id <= 2;
C2: SELECT * FROM tb1 ORDER BY id;
C3: DELETE FROM tb1 WHERE id >5;
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(2,'EFD');INSERT INTO tb1 VALUES(3,'IHT');INSERT INTO tb1 VALUES(4,'xyz');INSERT INTO tb1 VALUES(5,'mnf');INSERT INTO tb1 VALUES(6,'lop');INSERT INTO tb1 VALUES(7,'tea');
C1: commit work;
MC: wait until C1 ready;
/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
C1: commit;
MC: wait until C1 ready;
C2: SELECT tb1.* FROM tb1 ORDER BY id;
MC: wait until C2 ready;
C3: DELETE FROM tb1 WHERE id >5;
C3: commit work;
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE id >0 ORDER BY id;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE id >0 ORDER BY id;
MC: wait until C2 ready;
C3: SELECT * FROM tb1 WHERE id >0 ORDER BY id;
MC: wait until C3 ready;
C3: commit;
C2: commit;
C1: commit;
C3: quit;
C2: quit;
C1: quit;

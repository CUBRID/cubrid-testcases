/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/select_delete_01.ctl
Author: Lily

Test Point:
C1 select rows, C2 delete rows, not blocked.
C1 rollback, C2 succeeded delete.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 ORDER BY id;
C2: DELETE FROM tb1 WHERE id <= 2;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: INSERT INTO tb1 VALUES(2,'EFD');
C1: INSERT INTO tb1 VALUES(3,'IHT');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id <= 2;
MC: wait until C2 ready;
MC: sleep 10;
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C2: rollback;
C2: SELECT * FROM tb1 ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY id;
C1: commit work;

C2: commit;
C2: quit;
C1: quit;

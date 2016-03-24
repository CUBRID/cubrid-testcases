/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql
Author: Lily

Test Point:
changes can be seen after committed.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 2;
C2: SELECT * FROM tb1 ORDER BY id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'EFD'),(3,'IHT'),(4,'xyz'),(5,'mnf'),(6,'lop'),(7,'tea');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
C1: insert into tb1 values(1,'first');
C1: commit;
C1: DELETE FROM tb1 WHERE id in (5,6,7);
MC: sleep 2;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit;
C2: quit;
C1: quit;

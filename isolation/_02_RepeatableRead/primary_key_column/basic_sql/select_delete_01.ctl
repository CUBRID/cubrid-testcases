/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
test if the time of getting snapshot is at transaction start.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 ORDER BY id;
C2: DELETE FROM tb1 WHERE id <= 2;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
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
C2: show tables;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id<=2;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY id;
C1: commit;
C1: INSERT INTO tb1 VALUES(1,'abc');
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id = 3;
C2: commit;
MC: wait until C2 ready;
/* expect 2 rows */
C1: SELECT * FROM tb1 ORDER BY id;
C1: commit;
C1: SELECT * FROM tb1 ORDER BY id;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C1: commit;
C2: commit;

C2: quit;
C1: quit;

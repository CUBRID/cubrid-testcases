/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 delete rows, C2 select rows, overlapped.
you can not see the commintted change made by transaction whose ID is smaller than current.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 2;
C2: SELECT * FROM tb1 ORDER BY id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');
C1: INSERT INTO tb1 VALUES(2,'EFD');
C1: INSERT INTO tb1 VALUES(3,'IHT');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 2;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expect 3 rows */
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit;

C2: quit;
C1: quit;

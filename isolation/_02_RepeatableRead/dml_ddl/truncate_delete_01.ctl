/*
Test Case: truncate table & delete
Priority: 1
Reference case:
Author: Lily

Test Point:

NUM_CLIENTS = 2
C1: TRUNCATE TABLE tb1;
C2: DELETE FROM tb1 WHERE id >1;

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
C1: INSERT INTO tb1 VALUES(2,'defg');
C1: INSERT INTO tb1 VALUES(3,'htelp');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;

C2: DELETE FROM tb1 WHERE id >1;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit work;
/* expected no rows */
C2: select * from tb1 order by id,2;
C2: commit work;
C2: select * from tb1 order by id,2;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;

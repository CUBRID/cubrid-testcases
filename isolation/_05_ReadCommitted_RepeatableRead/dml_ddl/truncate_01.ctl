/*
Test Case: truncate table & delete
Priority: 1
Reference case:
Author: Lily

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(2,'defg');INSERT INTO tb1 VALUES(3,'help');INSERT INTO tb1 VALUES(4,'fan');INSERT INTO tb1 VALUES(5,NULL);INSERT INTO tb1 VALUES(6,'');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;
C2: TRUNCATE TABLE tb1;
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: SELECT * FROM tb1 order by 1,2;
C1: drop table tb1;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM db_class where owner_name='PUBLIC';
C2: commit;
C2: quit;
C1: quit;


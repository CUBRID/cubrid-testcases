/*
Test Case: drop table & delete
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
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit;

/* test case */
C2: DROP TABLE tb1;
MC: wait until C2 ready;
C1: CREATE TABLE tb1(id int, name char(4));
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: INSERT INTO tb1 VALUES(5,'a');INSERT INTO tb1 VALUES(1,'tea');INSERT INTO tb1 VALUES(7,'scanindex');
C1: select * from tb1 where id>1 order by 1,2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id > 1;
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit;
C2: select * from tb1 where id>1 order by 1,2;
C2: commit;
MC: wait until C1 ready;

C2: set transaction isolation level repeatable read;
C2: commit;
C2: DROP TABLE tb1;
MC: wait until C2 ready;
C1: CREATE TABLE tb1(id int, name char(4));
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: INSERT INTO tb1 VALUES(5,'a');INSERT INTO tb1 VALUES(1,'tea');INSERT INTO tb1 VALUES(7,'scanindex');
C1: select * from tb1 where id>1 order by 1,2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id > 1;
MC: sleep 1;
MC: wait until C2 blocked;
C1: commit;
C2: select * from tb1 where id>1 order by 1,2;
C2: commit;
C2: select * from tb1 where id>1;
C2: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;


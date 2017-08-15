/*
Test Case: alter table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
changes can been seen in current transaction.

NUM_CLIENTS = 1
C1: DELETE FROM tb1 WHERE col='efg';
C1: SELECT * FROM tb1 ORDER BY id;
C1: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20); 
C1: INSERT INTO tb1 VALUES(5,'Test',4,'test@nnn.com'); --commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 WHERE col='efg';
C1: SELECT * FROM tb1 ORDER BY id;
C1: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20);
C1: INSERT INTO tb1 VALUES(5,'Test',4,'test@nnn.com');
C1: commit work;
C1: SELECT * FROM tb1 ORDER BY id;
C1: quit;

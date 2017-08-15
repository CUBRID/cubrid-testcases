/*
Test Case: alter table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 select table, C2 alter table,other tansactions are blocked.

NUM_CLIENTS = 4
C1: SELECT * FROM tb1 WHERE id=2;
C2: INSERT INTO tb1 VALUES(5,'Test',4);
C3: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20);  --committed
C4: DELETE FROM tb1 WHERE col='efg'; 
*/

MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;

/* test case */
C4: SELECT * FROM tb1 WHERE id>1;
MC: wait until C4 ready;
C1: SELECT * FROM tb1 WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(5,'Test',4);
MC: wait until C2 ready;
C3: SELECT * FROM tb1 WHERE id>1;
C3: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20);
MC: wait until C3 blocked;
C4: DELETE FROM tb1 WHERE col='efg';
MC: wait until C4 ready;
C1: commit work;
C2: commit work;
C4: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C4 ready;
C3: SELECT * FROM tb1 ORDER BY id;
C3: commit;
MC: wait until C3 ready;
C4: SELECT * FROM tb1 ORDER BY id;
MC: wait until C4 ready;
C3: SELECT * FROM tb1 ORDER BY id;
C4: commit;
C3: commit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

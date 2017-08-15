/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: DELETE FROM tb1;
C2: select three times - before C1 commit, after C1 commit, after C2 commit. 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10),PRIMARY KEY (id,col));
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(1,'efd');INSERT INTO tb1 VALUES(2,'xyz');INSERT INTO tb1 VALUES(2,'tea');INSERT INTO tb1 VALUES(2,'web');INSERT INTO tb1 VALUES(2,'two');INSERT INTO tb1 VALUES(3,'fun');INSERT INTO tb1 VALUES(3,'sun');
C1: commit;
MC: wait until C1 ready;

/* test case */
C2: SELECT * FROM tb1 WHERE id>0 AND col NOT LIKE 't%' and (select sleep(2)) = 0;
C1: DELETE FROM tb1 WHERE id=2;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT * FROM tb1 WHERE id>0;
C1: SELECT * FROM tb1 WHERE id>0;
C1: commit;
C2: commit;

C2: quit;
C1: quit;

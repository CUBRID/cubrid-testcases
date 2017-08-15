/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/multiple_pk/delete_select_01.ctl
Author: Lily

Test Point:
Uncommitted data are never seen by other queries.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 ;
C2: SELECT * FROM tb1 ORDER BY id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10),PRIMARY KEY (id,col));
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(1,'efd');INSERT INTO tb1 VALUES(2,'xyz');INSERT INTO tb1 VALUES(2,'tea');INSERT INTO tb1 VALUES(2,'web');INSERT INTO tb1 VALUES(3,'xyz');INSERT INTO tb1 VALUES(3,'fun');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id=3;
MC: wait until C1 ready;
C2: SELECT tb1.* FROM tb1 WHERE id >0 ORDER BY id; 
MC: sleep 1;
C1: commit;
C2: SELECT * FROM tb1 WHERE id >0 ORDER BY id;
C2: commit;
C2: SELECT * FROM tb1 WHERE id >0 ORDER BY id;
C2: commit;
C2: quit;
C1: quit;

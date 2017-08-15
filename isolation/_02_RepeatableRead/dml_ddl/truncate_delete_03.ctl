/*
Test Case: truncate table & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/truncate_delete_01.ctl
Author: Lily

Test Point:
delete block truncate.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id >1;
C1: TRUNCATE TABLE tb1;

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
C1: DELETE FROM tb1 WHERE id >1;
MC: wait until C1 ready;

C2: TRUNCATE TABLE tb1;
MC: wait until C2 blocked;

C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: select * from tb1 order by id,2;
MC: wait until C1 blocked;

C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;

/* expected no rows */
C1: select * from tb1 order by id,2;
C1: commit work;
C1: select * from tb1 order by id,2;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;

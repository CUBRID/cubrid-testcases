/*
Test Case: truncate table & rename
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/truncate_03.ctl
Author: Lily

Test Point:

NUM_CLIENTS = 2
C1: TRUNCATE TABLE tb1;
C2: RENAME TABLE tb1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%200 FROM db_class a,db_class b,db_class c limit 10000;
C1: CREATE INDEX idx ON tb1(col);
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;
C2: RENAME TABLE tb1 AS aa_tb1;
MC: wait until C2 blocked;
C1: commit;

MC: wait until C2 ready;
/* expected no rows */
C2: SELECT * FROM aa_tb1 order by 1,2;
C2: commit work;
C2: SELECT * FROM aa_tb1 order by 1,2; 
C2: commit work;
MC: wait until C2 ready; 
C1: SELECT * FROM aa_tb1 order by 1,2;  
C1: commit work;  
C2: quit;
C1: quit;

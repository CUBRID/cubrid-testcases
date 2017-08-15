/*
Test Case: truncate table & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/dml_ddl/truncate_01.ctl
Author: Lily

Test Point:
C1 truncate table, C2 truncate table, then C2 is blocked.
when C1 rollback, C2 succeeded truncate.

NUM_CLIENTS = 2
C1: TRUNCATE TABLE tb1;
C2: TRUNCATE TABLE tb1;
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'defg'),(3,'help'),(4,'fan'),(5,NULL),(6,'');
C1: commit work;

/* test case */
C1: TRUNCATE TABLE tb1;
MC: wait until C1 ready;
C2: TRUNCATE TABLE tb1;
MC: wait until C2 blocked;
C1: rollback;

MC: wait until C2 ready;
/* expected no rows */
C2: select * from tb1 order by id;
C2: commit work;
C2: select * from tb1 order by id; 
C2: commit work; 
C2: quit;
C1: quit;

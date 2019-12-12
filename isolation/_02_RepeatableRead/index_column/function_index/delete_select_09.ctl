/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
use  ABC(number) to create index.

NUM_CLIENTS = 2 
C1: DELETE FROM tb1;
C2: SELECT FROM tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT NOT NULL,col FLOAT);
C1: INSERT INTO tb1 VALUES(1,12.3), (2,-12.3), (3,-12.3000),(4,0.0);
C1: CREATE INDEX idx ON tb1(ABS(col));
C1: CREATE INDEX idx_id ON tb1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 USE INDEX (idx) WHERE ABS(col)=12.3 AND (select sleep(2))=0;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE id <4 order by 1;
C2: SELECT * FROM tb1 USE INDEX (idx) WHERE ABS(col)=12.3 order by 1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C2: SELECT * FROM tb1 order by id;
C2: commit;

C2: quit;
C1: quit;


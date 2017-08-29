/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
use  CHAR_LENGTH(string) to create index.

NUM_CLIENTS = 2 
C1: select * from tb1 where sleep(1,col); 
C2: delete * from tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,'a'),(2,'an'),(4,'java'),(4,'sales'),(3,'net'),(3,'web');
C1: CREATE INDEX idx ON tb1(CHAR_LENGTH(col));
C1: commit;

/* test case */
C2: DELETE FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id;
C2: SELECT * FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id order by 1,2;
MC: wait until C2 ready;
C1: SELECT tb1.* FROM (select sleep(1)) x, tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id order by 1,2;
MC: wait until C1 ready;
C1: SELECT * FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id order by 1,2;

C1: commit;
C2: quit;
C1: quit;


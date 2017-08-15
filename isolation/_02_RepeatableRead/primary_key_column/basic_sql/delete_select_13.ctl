/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:

NUM_CLIENTS = 2
C1: delete from tb1; 
C2: delete from tb1;
C1: commit
C1: delete from tb1;
C2: select * from tb1 order by id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col INT, PRIMARY KEY (id));
C1: INSERT INTO tb1 SELECT rownum,rownum%100 FROM db_class a,db_class b,db_class c limit 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id<10;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id >90 AND id<100;
MC: sleep 1;
C1: commit;
C1: DELETE FROM tb1 WHERE id>190 AND id<200;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1 WHERE id<200;
MC: wait until C2 ready;
C1: commit;
C2: commit work;

C2: SELECT COUNT(*) FROM tb1 WHERE id<200;
C2: commit;

C2: quit;
C1: quit;


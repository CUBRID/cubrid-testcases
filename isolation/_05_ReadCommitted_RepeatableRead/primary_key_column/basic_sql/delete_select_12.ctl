/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
index skip scan

NUM_CLIENTS = 2
C1: delete from tb1; 
C2: select * from tb1 order by id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT NOT NULL,col INT, PRIMARY KEY (id,col));
C1: INSERT INTO tb1 SELECT mod(rownum,2),rownum FROM db_class a,db_class b,db_class c where rownum<=10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id=1 and col>10 AND col<60;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE id=1 and col>20 AND col<40;
MC: wait until C2 ready;
C1: SELECT count(*) FROM tb1 ORDER BY col;
MC: wait until C1 ready;
C1: commit;
C2: SELECT * FROM tb1 WHERE id=1 and col>20 AND col<40;
C2: commit work;
C2: SELECT * FROM tb1 WHERE id=1 and col>20 AND col<40;

C2: SELECT count(*) FROM tb1 ORDER BY col;
C2: commit;

C2: quit;
C1: quit;


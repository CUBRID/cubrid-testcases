/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test point:
extended case of combination of delete and select.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b where rownum<=500;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id between 30 and 90;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 where id >= 25 and id <= 40 ORDER BY id;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE id between 1 and 100 ORDER BY id;
C2: commit;

C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;
C1: DELETE FROM tb1 WHERE id between 130 and 190;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 where id >= 125 and id <= 140 ORDER BY id;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 where id between 100 and 200 ORDER BY id;
C2: commit;
C2: SELECT * FROM tb1 where id between 100 and 200 ORDER BY id ;
C2: commit;
MC: wait until C2 ready;

C2: set transaction isolation level read committed;
C2: commit;
MC: wait until C2 ready;
C1: DELETE FROM tb1 WHERE id between 230 and 290;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 where id >= 225 and id <= 240 ORDER BY id;
MC: wait until C2 ready;
C1: select count(*) from tb1;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 where id between 200 and 300 ORDER BY id;
C2: commit;
MC: wait until C2 ready;
C1: select count(*) from tb1;
C1: commit;
C2: quit;
C1: quit;

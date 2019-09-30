/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 delete rows, C2 select rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE sleep(1);
C2: SELECT * FROM tb1 order by 1,2; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, acol int, bcol int);
C1: INSERT INTO tb1 SELECT rownum%10,rownum%50,rownum%100 FROM db_class a,db_class b where rownum <= 500;
C1: CREATE INDEX idx_all ON tb1(id,acol,bcol) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE acol > 48 and bcol > 70 ;
MC: sleep 1;
C2: SELECT * FROM tb1 WHERE id =1 and acol > 40  and bcol >70 ORDER BY id;
MC: wait until C2 ready;
C2: commit work;
MC: sleep 10;
MC: wait until C1 ready;
C1: commit work;
C2: SELECT COUNT(*) FROM tb1 ORDER BY id;
C2: commit;

C2: quit;
C1: quit;

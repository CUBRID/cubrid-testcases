/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 select rows, C2 delete rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT FROM tb1; --using index skip scan 
C2: DELETE FROM tb1; 
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, acol int, bcol int);
C1: INSERT INTO tb1 SELECT rownum%2,rownum%50,rownum%100 FROM db_class a,db_class b LIMIT 500;
C1: CREATE INDEX idx_all ON tb1(id,acol,bcol);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 WHERE id=0 and acol >=30 and bcol>50 order by 1,2;
C1: SELECT * FROM tb1 WHERE id =0 and acol < 10 and bcol > 50 order by 1,2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id =0 and acol < 40 and bcol > 50;
MC: wait until C2 ready;
C2: commit work;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: SELECT COUNT(*) FROM tb1 ORDER BY id;
C1: commit;
C2: quit;
C1: quit;

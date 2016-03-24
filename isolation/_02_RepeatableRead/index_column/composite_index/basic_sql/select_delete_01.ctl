/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 select rows, C2 delete rows, not overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: select * from tb1 order by id;
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
C1: CREATE TABLE tb1( id INT, acol VARCHAR(10), bcol VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum%30,rownum%50,rownum%100 FROM db_class a,db_class b LIMIT 500;
C1: CREATE INDEX idx_all ON tb1(id,acol,bcol);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id=7 and acol='7';
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE acol='3' and bcol='3';
C2: SELECT * FROM tb1 WHERE acol ='7' and bcol ='7' ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE acol='3' and bcol='3' order by id;
C1: commit;
C1: SELECT COUNT(*) FROM tb1;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: SELECT COUNT(*) FROM tb1;
C1: commit;
C1: SELECT * FROM tb1 WHERE acol='3' and bcol='3' order by id;
C1: SELECT COUNT(*) FROM tb1;
C1: commit;
C2: quit;
C1: quit;

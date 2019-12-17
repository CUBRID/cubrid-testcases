/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 select rows, C2 delete rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 order by 1,2;
C2: DELETE FROM tb1 WHERE id <= 3;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: INSERT INTO tb1 SELECT rownum,rownum%100 FROM db_class a,db_class b where rownum <= 500;
C1: CREATE INDEX idx_id on tb1(col) with online parallel 3;
C1: CREATE INDEX idx_col on tb1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 WHERE col='2' ORDER BY id,2;
MC: sleep 1;
C2: DELETE FROM tb1 WHERE id> 100 and id <= 103;
C2: SELECT * FROM tb1 WHERE id> 100 and id <= 103 order by 1,2;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;

C1: SELECT COUNT(*) FROM tb1;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;

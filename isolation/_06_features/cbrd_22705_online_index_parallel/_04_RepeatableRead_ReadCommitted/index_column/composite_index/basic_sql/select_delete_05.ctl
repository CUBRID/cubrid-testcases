/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/composite_index/basic_sql/select_delete_01.ctl 
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 select rows, C2 delete rows,overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 order by 1,2;
C2: DELETE FROM tb1;
C2: rollback
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, acol int, bcol int);
C1: INSERT INTO tb1 SELECT rownum%30,rownum%50,rownum%100 FROM db_class a,db_class b where rownum <= 500;
C1: CREATE INDEX idx_all ON tb1(id,acol,bcol) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 WHERE acol =7 and bcol =7 ORDER BY id;
MC: wait until C1 ready;

C2: DELETE FROM tb1 WHERE acol=7 and bcol=7;
MC: wait until C2 ready;

C2: SELECT * FROM tb1 WHERE acol =7 and bcol =7 ORDER BY id;
C2: rollback;
MC: wait until C2 ready;

C1: commit;
C1: SELECT COUNT(*) FROM tb1 ORDER BY id;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
